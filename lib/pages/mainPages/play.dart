import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:app_settings/app_settings.dart';
import 'package:bluetooth_app_test/classes/bluetooth_data.dart';
import 'package:bluetooth_app_test/components/bluetoothIcon.dart';
import 'package:bluetooth_app_test/components/myButtons.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/components/myDogDropdown.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/components/pageLayout.dart';
import 'package:bluetooth_app_test/constants.dart';
import 'package:bluetooth_app_test/functions/steps_to_distance.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/helpers/date_helper.dart';
import 'package:bluetooth_app_test/logger.dart';
import 'package:bluetooth_app_test/models/record.dart';
import 'package:bluetooth_app_test/models/record_date.dart';
import 'package:bluetooth_app_test/providers/bluetooth.dart';
import 'package:bluetooth_app_test/providers/breath.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:bluetooth_app_test/providers/pulse.dart';
import 'package:bluetooth_app_test/providers/steps.dart';
import 'package:bluetooth_app_test/services/storage/firebase_firestore.dart';
import 'package:bluetooth_app_test/services/storage/shared_preferences_service.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter_blue/flutter_blue.dart';

final _storageService = SharedPreferencesService();

class PlayPage extends ConsumerStatefulWidget {
  const PlayPage({super.key});

  @override
  PlayPageState createState() => PlayPageState();
}

class PlayPageState extends ConsumerState<PlayPage> with AutomaticKeepAliveClientMixin<PlayPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var bluetoothState = ref.watch(bluetoothStateProvider).value;
    var bluetoothData = ref.watch(connectedDeviceProvider).value;
    var walkingDog = ref.watch(walkingDogProvider);
    var isListening = ref.watch(isListeningProvider).value ?? false;
    var doneWalking = ref.watch(doneWalkingForTodayProvider);

    if (doneWalking) return const _DoneWalking();

    bool isBluetoothOff = bluetoothState != BluetoothState.on;

    if (isBluetoothOff) return const _BluetoothDisabled();
    if (bluetoothData == null) return const _FindingDevice();
    if (walkingDog == null || !isListening) return const _SelectWalkingDog();
    return const _MainPage();

    //! MAIN PAGE
  }
}

//! MAIN
class _MainPage extends ConsumerStatefulWidget {
  const _MainPage({super.key});

  @override
  __MainPageState createState() => __MainPageState();
}

class __MainPageState extends ConsumerState<_MainPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(dataStreamProvider, (oldData, newData) {
      var bluetoothData = newData.value;
      if (bluetoothData == null) return;
      bluetoothData.handleData(ref);
      // if (newData.value?.dataType == DataTypes.step) {
      //   logger.e("STEP RECEIVED");
      //   ref.read(stepProvider.notifier).add();
      // }
    });

    var walkingDog = ref.watch(walkingDogProvider);
    var owner = ref.watch(ownerProvider).value;

    return PageScrollLayout(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
            offset: const Offset(10, 0), child: const Align(alignment: Alignment.centerRight, child: BluetoothIcon())),
        const SizedBox(height: 5),
        const MyText.h1("WALKING"),
        const SizedBox(height: 20),
        const MyText.p("Enjoy."),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyCircleAvatar.owner(owner),
            Container(
              width: 100,
              height: 2,
              color: MyStyles.dark,
            ),
            MyCircleAvatar.dog(walkingDog),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              alignment: Alignment.topCenter,
              child: MyText.h3(owner?.nickname ?? ""),
            ),
            const SizedBox(
              width: 62,
              height: 1,
            ),
            Container(
              width: 100,
              alignment: Alignment.topCenter,
              child: MyText.h3(walkingDog?.name ?? ""),
            ),
          ],
        ),
        const SizedBox(height: 50),
        const _StepAndDistance(),
        const SizedBox(height: 50),
        _Pulse(),
        const SizedBox(height: 50),
        _Breath(),
        const SizedBox(height: 50),
        // const LineChartSample10(),
        // const SizedBox(height: 50),
        MyButton.outline(
          label: "DONE WALKING",
          labelColor: MyStyles.red,
          outlineColor: MyStyles.red,
          onPressed: () async {
            if (walkingDog == null) return;

            //! Update Record
            Record prevRecord = await CloudFirestoreService.getRecord(walkingDog.id) ?? Record.fromNull(walkingDog.id);

            Record newRecord = Record(
              id: walkingDog.id,
              numSteps: prevRecord.numSteps + ref.read(stepProvider),
              avePulse: getNewAve(
                  prevRecord.avePulse, prevRecord.numPulse, await _storageService.getInt(StorageNames.pulseAve),
                  newNum: await _storageService.getInt(StorageNames.pulseNum)),
              numPulse: prevRecord.numPulse + await _storageService.getInt(StorageNames.pulseNum),
              aveBreath: getNewAve(
                  prevRecord.aveBreath, prevRecord.numBreath, await _storageService.getInt(StorageNames.breathPerMin)),
              numBreath: prevRecord.numBreath + 1,
            );

            await CloudFirestoreService.setRecord(newRecord);

            //! Update Record Date
            String date = DateHelper.toDateString(DateTime.now());
            RecordDate prevRecordDate =
                await CloudFirestoreService.getRecordDate(walkingDog.id, date) ?? RecordDate.fromNull(walkingDog.id);

            RecordDate newRecordDate = RecordDate(
              id: date,
              numSteps: prevRecordDate.numSteps + ref.read(stepProvider),
              avePulse: getNewAve(
                  prevRecordDate.avePulse, prevRecordDate.numPulse, await _storageService.getInt(StorageNames.pulseAve),
                  newNum: await _storageService.getInt(StorageNames.pulseNum)),
              numPulse: prevRecordDate.numPulse + await _storageService.getInt(StorageNames.pulseNum),
              aveBreath: getNewAve(prevRecordDate.aveBreath, prevRecordDate.numBreath,
                  await _storageService.getInt(StorageNames.breathPerMin)),
              numBreath: prevRecord.numBreath + 1,
            );

            await CloudFirestoreService.setRecordDate(newRecordDate, walkingDog.id);

            ref.read(stepProvider.notifier).reset();
            ref.read(pulseProvider.notifier).reset();
            ref.read(breathProvider.notifier).reset();
            resetBreathingValues();

            ref.read(doneWalkingForTodayProvider.notifier).state = true;
            ref.read(walkingDogProvider.notifier).state = null;
          },
        ),
      ],
    );
  }
}

//! Breath
class _Breath extends ConsumerStatefulWidget {
  _Breath({super.key});
  final interval = 20.0;

  @override
  _BreathState createState() => _BreathState();
}

class _BreathState extends ConsumerState<_Breath> {
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = MyStyles.p.copyWith(color: MyStyles.dark60);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    var spots = ref.watch(breathProvider);
    var breathAve = ref.watch(breathAveProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: MyStyles.white,
        border: Border.all(color: MyStyles.dark, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    tooltipBgColor: MyStyles.white,
                    tooltipBorder: const BorderSide(color: MyStyles.dark),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ?? touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: Colors.black,
                    spots: spots.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameSize: 16,
                    // axisNameWidget: const Padding(
                    //   padding: EdgeInsets.only(bottom: 0),
                    //   child: Text('BPM'),
                    // ),
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: widget.interval,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 45,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                minY: 5,
                maxY: 18,
                // maxY: (spots.reduce(math.max).toDouble() / widget.interval).ceil() * widget.interval + widget.interval,
                minX: spots.length.toDouble() - 20,
                maxX: spots.length.toDouble(),
                clipData: FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  // horizontalInterval: 1.5,
                  // verticalInterval: 5,
                  // checkToShowHorizontalLine: (value) {
                  //   return value.toInt() == 0;
                  // },
                  // checkToShowVerticalLine: (value) {
                  //   return value.toInt() == 0;
                  // },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const MyText.h2("Breath"),
          MyText.p("$breathAve BPM"),
        ],
      ),
    );
  }
}

//! PULSE
class _Pulse extends ConsumerStatefulWidget {
  _Pulse({super.key});
  final interval = 20.0;

  @override
  _PulseState createState() => _PulseState();
}

class _PulseState extends ConsumerState<_Pulse> {
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    var style = MyStyles.p.copyWith(color: MyStyles.dark60);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    var spots = ref.watch(pulseProvider);
    var pulseAve = ref.watch(pulseAveProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: MyStyles.white,
        border: Border.all(color: MyStyles.dark, width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    tooltipBgColor: MyStyles.white,
                    tooltipBorder: const BorderSide(color: MyStyles.dark),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ?? touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${touchedSpot.x}, ${touchedSpot.y.toStringAsFixed(2)}',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                ),
                lineBarsData: [
                  LineChartBarData(
                    color: Colors.black,
                    spots: spots.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameSize: 16,
                    axisNameWidget: const Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Text('BPM'),
                    ),
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: widget.interval,
                      getTitlesWidget: leftTitleWidgets,
                      reservedSize: 45,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                minY: 0,
                maxY: (spots.reduce(math.max).toDouble() / widget.interval).ceil() * widget.interval + widget.interval,
                minX: spots.length.toDouble() - 10,
                maxX: spots.length.toDouble(),
                clipData: FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  // horizontalInterval: 1.5,
                  // verticalInterval: 5,
                  // checkToShowHorizontalLine: (value) {
                  //   return value.toInt() == 0;
                  // },
                  // checkToShowVerticalLine: (value) {
                  //   return value.toInt() == 0;
                  // },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const MyText.h2("Heartbeat"),
          MyText.p("$pulseAve BPM"),
        ],
      ),
    );
  }
}

//! STEP
class _StepAndDistance extends ConsumerWidget {
  const _StepAndDistance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var step = ref.watch(stepProvider);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        // shape: BoxShape.circle,
        border: Border.fromBorderSide(BorderSide(color: MyStyles.dark, width: 1)),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              SvgPicture.asset("assets/svg/small-paw.svg"),
              const SizedBox(height: 5),
              MyText.h1("$step"),
              const MyText.h2("steps", color: MyStyles.dark60),
            ],
          ),
          const SizedBox(width: 100),
          Column(
            children: [
              SvgPicture.asset("assets/svg/small-navigation.svg"),
              const SizedBox(height: 5),
              MyText.h1("${stepsToDistance(step)}"),
              const MyText.h2("meters", color: MyStyles.dark60),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectWalkingDog extends ConsumerStatefulWidget {
  const _SelectWalkingDog({super.key});

  @override
  _SelectWalkingDogState createState() => _SelectWalkingDogState();
}

class _SelectWalkingDogState extends ConsumerState<_SelectWalkingDog> {
  final _dropdownController = MyDogDropdownController();

  void selectWalkingDog() async {
    final dog = _dropdownController.value;
    if (dog == null) return;
    ref.read(walkingDogProvider.notifier).state = dog;
    ref.read(shouldListenProvider.notifier).state = true;

    final queryParameters = {
      'dogId': dog.id,
    };
    final uri = Uri.https('late-pond-5613.fly.dev', '/changeDogId', queryParameters);
    final response = await http.post(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const MyText.h1("Who will you walk today?"),
            const SizedBox(height: 40),
            MyDogDropdown(controller: _dropdownController),
            const SizedBox(height: 200),
            MyButton(
              label: "CONTINUE",
              onPressed: selectWalkingDog,
            ),
          ],
        ),
      ),
    );
  }
}

class _BluetoothDisabled extends StatelessWidget {
  const _BluetoothDisabled({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MyText.h1("Bluetooth disabled"),
          const SizedBox(height: 25),
          SvgPicture.asset("assets/svg/dog-crying.svg"),
          const SizedBox(height: 25),
          const MyText.p("Please turn on bluetooth to continue"),
          const SizedBox(height: 25),
          const MyButton.shrink(
            label: "Turn On",
            onPressed: AppSettings.openBluetoothSettings,
          ),
        ],
      ),
    );
  }
}

class _DoneWalking extends ConsumerWidget {
  const _DoneWalking({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MyText.h1("You have walked your dog today!"),
          const SizedBox(height: 25),
          const MyText.p("Wanna walk again?"),
          const SizedBox(height: 25),
          MyButton.shrink(
            label: "Walk",
            onPressed: () {
              ref.read(doneWalkingForTodayProvider.notifier).state = false;
            },
          ),
        ],
      ),
    );
  }
}

class _FindingDevice extends ConsumerStatefulWidget {
  const _FindingDevice({super.key});

  @override
  _FindingDeviceState createState() => _FindingDeviceState();
}

class _FindingDeviceState extends ConsumerState<_FindingDevice> {
  @override
  void initState() {
    super.initState();
    bool isAutoConnect = ref.read(isConnectAutomaticallyProvider.notifier).state;
    if (isAutoConnect) connect();
  }

  Future<void> connect() async {
    await ref.read(connectedDeviceProvider.notifier).connect();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(isConnectAutomaticallyProvider, (oldValue, newValue) {
      if (newValue) {
        connect();
      }
    });

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          // SvgPicture.asset("assets/svg/bluetooth-circle.svg"),

          AvatarGlow(
            glowColor: MyStyles.dark,
            endRadius: 130.0,
            child: CircleAvatar(
              radius: 73,
              backgroundColor: MyStyles.dark,
              child: Icon(Icons.bluetooth_rounded, size: 100, color: MyStyles.white),
            ),
          ),
          SizedBox(height: 10),
          MyText.h1("Finding your device"),
          SizedBox(height: 10),
          MyText.p("Please make sure that the device is already turned on"),
        ],
      ),
    );
  }
}

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DELETE
class LineChartSample10 extends StatefulWidget {
  const LineChartSample10({super.key});

  @override
  State<LineChartSample10> createState() => _LineChartSample10State();
}

class _LineChartSample10State extends State<LineChartSample10> {
  final Color sinColor = Colors.redAccent;

  final limitCount = 100;
  final sinPoints = <FlSpot>[];

  double xValue = 0;
  double step = 0.05;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      while (sinPoints.length > limitCount) {
        sinPoints.removeAt(0);
      }
      setState(() {
        sinPoints.add(FlSpot(xValue, math.sin(xValue)));
      });
      xValue += step;
    });
  }

  @override
  Widget build(BuildContext context) {
    // logger.d("minX: ${sinPoints.first.x}, maxX: ${sinPoints.last.x}");
    return sinPoints.isNotEmpty
        ? SizedBox(
            width: 300,
            height: 300,
            child: LineChart(
              LineChartData(
                minY: -1,
                maxY: 1,
                minX: sinPoints.first.x,
                maxX: sinPoints.last.x,
                lineTouchData: LineTouchData(enabled: false),
                clipData: FlClipData.all(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                ),
                lineBarsData: [
                  sinLine(sinPoints),
                ],
                titlesData: FlTitlesData(
                  show: true,
                ),
              ),
            ),
          )
        : Container();
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [sinColor, sinColor],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
