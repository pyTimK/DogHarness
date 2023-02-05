import 'package:bluetooth_app_test/components/myAlertDialog.dart';
import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/components/rotatingBlobs.dart';
import 'package:bluetooth_app_test/functions/utils.dart';
import 'package:bluetooth_app_test/models/record_location.dart';
import 'package:bluetooth_app_test/pages/pushedPages/pushedPageLayout.dart';
import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class GPSData extends ConsumerStatefulWidget {
  const GPSData({super.key});

  @override
  _GPSDataState createState() => _GPSDataState();
}

class _GPSDataState extends ConsumerState<GPSData> {
  void _showData(RecordLocation recordLocation) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(children: [
          MyText.h1(recordLocation.id),
          const SizedBox(height: 15),
          Column(
            children: [
              MyText.p("Altitude: ${recordLocation.altitude}"),
              const SizedBox(height: 5),
              MyText.p("Latitude: ${recordLocation.latitude}"),
              const SizedBox(height: 5),
              MyText.p("Longitude: ${recordLocation.longitude}"),
            ],
          ),
        ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final arguments = (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{}) as Map;
    final defaultDog = ref.watch(defaultDogProvider);
    final defaultDate = ref.watch(defaultDateProvider);
    final recordLocations = ref.watch(recordLocationProvider).value ?? [];

    return PushedPageLayout(
      title: "GPS Data",
      crossAxisAlignment: CrossAxisAlignment.center,
      children: recordLocations.isEmpty
          ? [
              const SizedBox(height: 300),
              const MyText.h2Regular("No GPS Data"),
            ]
          : [
              const SizedBox(height: 20),
              MyText.p(
                  "Below is the summary of GPS data taken in ${getFormattedDate(defaultDate)} when walking with ${defaultDog?.name ?? "your dog"}."),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
                itemCount: recordLocations.length,
                itemBuilder: (context, index) {
                  final recordLocation = recordLocations[index];
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                    ),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showData(recordLocation),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(recordLocation.id),
                          const Icon(Icons.chevron_right_rounded),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
    );
  }
}
