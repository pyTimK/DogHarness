import 'dart:convert';

import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:bluetooth_app_test/services/storage/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class DataObject {
  DataObject(
    this.data,
    this.datetime,
  );

  DataObject.now(this.data) : datetime = DateTime.now();

  final String data;
  final DateTime datetime;
}

class BluetoothData extends ChangeNotifier {
  BluetoothData() {
    refreshConnectedDevices().then((_) {
      _getCharacteristics();
    });
    refreshSteps();
  }

  // singletons
  final _storageService = SharedPreferencesService();

  // internals
  List<BluetoothDevice> _connectedDevices = [];
  final List<DataObject> _dataStream = [];
  BluetoothCharacteristic? _notifiableCharacteristic;
  BluetoothCharacteristic? _writableCharacteristic;
  bool _isListening = false;
  int _steps = 0;

  // getters
  List<BluetoothDevice> get connectedDevices => _connectedDevices;
  List<DataObject> get dataStream => _dataStream;
  BluetoothCharacteristic? get notifiableCharacteristic => _notifiableCharacteristic;
  BluetoothCharacteristic? get writableCharacteristic => _writableCharacteristic;
  bool get isListening => _isListening;
  int get steps => _steps;

  BluetoothDevice? get connectedDevice {
    if (_connectedDevices.isEmpty) {
      return null;
    }
    return _connectedDevices.first;
  }

  bool get isConnected => _connectedDevices.isNotEmpty;

  Future<List<BluetoothService>> get services async {
    if (_connectedDevices.isEmpty) {
      return [];
    }

    var device = _connectedDevices.first;
    return await device.discoverServices();
  }

  // private methods
  //! CHARACTERISTICS
  _getCharacteristics() async {
    if (connectedDevice == null) {
      return;
    }

    List<BluetoothService> awaitedServices = await services;

    // get the notifiable characteristic
    for (BluetoothService service in awaitedServices) {
      if (_notifiableCharacteristic != null) {
        break;
      }

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          _notifiableCharacteristic = characteristic;
          await listen();
          break;
        }
      }
    }

    // get the writable characteristic
    for (BluetoothService service in awaitedServices) {
      if (_writableCharacteristic != null) {
        break;
      }

      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          _writableCharacteristic = characteristic;
          break;
        }
      }
    }
  }

  // public methods
  //! CONNECTED DEVICES
  Future<void> refreshConnectedDevices() async {
    _connectedDevices = await flutterBlue.connectedDevices;
    notifyListeners();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevices.add(device);
    await _getCharacteristics();
    notifyListeners();
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    await device.disconnect();
    _connectedDevices.remove(device);
    notifyListeners();
  }

  Future<void> startScanning() async {
    var isScanning = await flutterBlue.isScanning.first;

    if (!isScanning) {
      flutterBlue.startScan();
    }
  }

  Future<void> stopScanning() async {
    var isScanning = await flutterBlue.isScanning.first;

    if (isScanning) {
      flutterBlue.stopScan();
    }
  }

  //! NOTIFIABLE CHARACTERISTIC
  Future<void> listen() async {
    if (_isListening || _notifiableCharacteristic == null) {
      return;
    }

    var characteristic = _notifiableCharacteristic!;

    await characteristic.setNotifyValue(true);
    characteristic.value.listen((data) {
      var ascii = String.fromCharCodes(data).trim();
      _dataStream.add(DataObject.now(ascii));
      _handleData(ascii);
      logger.d(ascii);
      notifyListeners();
    });
    _isListening = true;
  }

  Future<void> stopListening(BluetoothCharacteristic characteristic) async {
    if (!_isListening) {
      return;
    }

    await characteristic.setNotifyValue(false);
    _isListening = false;
  }

  Future<void> _handleData(String data) async {
    switch (data) {
      case "STEP":
        logger.wtf(data);
        addStep();
        break;

      default:
        break;
    }
  }

  //! WRITABLE CHARACTERISTIC
  Future<void> write(String data) async {
    if (_writableCharacteristic == null) {
      try {
        await _getCharacteristics();
      } catch (e) {
        logger.e(e);
        return;
      }
    }

    var characteristic = _writableCharacteristic!;

    await characteristic.write(utf8.encode(data));
  }

  //! STEPS
  Future<void> refreshSteps() async {
    _steps = await _storageService.getInt(StorageNames.steps);
    notifyListeners();
  }

  Future<void> resetSteps() async {
    _steps = 0;
    await _storageService.setInt(StorageNames.steps, _steps);
    notifyListeners();
  }

  Future<void> setSteps(int steps) async {
    _steps = steps;
    await _storageService.setInt(StorageNames.steps, _steps);
    notifyListeners();
  }

  Future<void> addStep() async {
    _steps++;
    await _storageService.setInt(StorageNames.steps, _steps);
    notifyListeners();
  }

  Future<void> removeStep() async {
    _steps--;
    await _storageService.setInt(StorageNames.steps, _steps);
    notifyListeners();
  }

  Future<void> addSteps(int steps) async {
    _steps += steps;
    await _storageService.setInt(StorageNames.steps, _steps);
    notifyListeners();
  }

  Future<void> removeSteps(int steps) async {
    _steps -= steps;
    await _storageService.setInt(StorageNames.steps, _steps);
    notifyListeners();
  }
}
