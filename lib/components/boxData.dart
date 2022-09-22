import 'package:bluetooth_app_test/classes/data_status.dart';
import 'package:bluetooth_app_test/components/bouncing.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BoxData extends StatelessWidget {
  const BoxData(this.dataStatus, {required this.onPress, super.key});
  final DataStatus dataStatus;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPress: onPress,
      child: Container(
        width: MediaQuery.of(context).size.width * .40,
        height: MediaQuery.of(context).size.width * .40,
        padding: const EdgeInsets.only(left: 18, top: 18),
        decoration: BoxDecoration(
          color: MyStyles.dark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(children: [
          Positioned(bottom: 12, right: -10, child: SvgPicture.asset("assets/svg/${dataStatus.icon}.svg")),
          Positioned(
              bottom: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: dataStatus.color,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text("$dataStatus", style: MyStyles.p.copyWith(color: MyStyles.white60)),
                ],
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${dataStatus.value}", style: MyStyles.title.colour(MyStyles.white)),
              const SizedBox(height: 7),
              Text(dataStatus.label, style: MyStyles.h2.colour(MyStyles.white60)),
            ],
          ),
        ]),
      ),
    );
  }
}
