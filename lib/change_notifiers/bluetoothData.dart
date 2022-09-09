import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:bluetooth_app_test/services/storage/storage_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;

class BluetoothData extends ChangeNotifier {
  BluetoothData() {
    refreshConnectedDevices();
    refreshSteps();
  }

  // singletons
  final _storageService = SharedPreferencesService();

  // internals
  List<BluetoothDevice> _connectedDevices = [];
  List<String> _dataStream = [];
  bool _isListening = false;
  int _steps = 0;

  // getters
  List<BluetoothDevice> get connectedDevices => _connectedDevices;
  List<String> get dataStream => _dataStream;
  int get steps => _steps;

  Future<List<BluetoothService>> get services async {
    if (_connectedDevices.isEmpty) {
      return [];
    }

    var device = _connectedDevices.first;
    return await device.discoverServices();
  }

  // methods
  Future<void> refreshConnectedDevices() async {
    _connectedDevices = await flutterBlue.connectedDevices;
    notifyListeners();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    _connectedDevices.add(device);
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

  Future<void> listen(BluetoothCharacteristic characteristic) async {
    if (_isListening) {
      return;
    }

    await characteristic.setNotifyValue(true);
    characteristic.value.listen((data) {
      var ascii = String.fromCharCodes(data).trim();
      _dataStream.add(ascii);
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
