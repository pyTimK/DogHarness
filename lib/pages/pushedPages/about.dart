import 'package:bluetooth_app_test/components/myEditableAvatar.dart';
import 'package:bluetooth_app_test/components/myText.dart';
import 'package:bluetooth_app_test/components/rotatingBlobs.dart';
import 'package:bluetooth_app_test/pages/pushedPages/pushedPageLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PushedPageLayout(
      title: "About",
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        MyText.p("The App  to monitor  your pet buddy’s  health status through your smart mobile."),
        SizedBox(height: 50),
        MyText.p("With DogtAPP, you can monitor the  latest condition of your  dog wellness including: "),
        SizedBox(height: 20),
        _Feature("Step-counts (Pedometer)"),
        SizedBox(height: 20),
        _Feature("BPM heart rate"),
        SizedBox(height: 20),
        _Feature("Breathing counts"),
        SizedBox(height: 20),
        _Feature("GPS  tracking features with SMS (nearby location)"),
        SizedBox(height: 50),
        Align(
          alignment: Alignment.centerLeft,
          child: MyText.p("Android 12 Support"),
        ),
        SizedBox(height: 50),
        MyText.h1("Developers"),
        SizedBox(height: 20),
        _Developer("ilagan", "ILAGAN, HJ."),
        _Developer("deleon", "DE LEON, SP."),
        _Developer("bejer", "BEJER, MC."),
        _Developer("eseque", "ESEQUE, A."),
      ],
    );
  }
}

class _Developer extends StatefulWidget {
  const _Developer(this.imgName, this.name, {super.key});

  final String imgName;
  final String name;

  @override
  State<_Developer> createState() => _DeveloperState();
}

class _DeveloperState extends State<_Developer> {
  final _avatarTempController = MyEditableAvatarController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            const RotatingBlobs(),
            MyEditableAvatar(
              controller: _avatarTempController,
              defaultImage: Image.asset("assets/images/${widget.imgName}.png", fit: BoxFit.cover),
              radius: 70,
              isEditable: false,
            ),
          ],
        ),
        const SizedBox(height: 10),
        MyText.h1UnBold(widget.name),
        const SizedBox(height: 60),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: Row(
        children: [
          const Icon(Icons.check),
          const SizedBox(width: 20),
          Expanded(
            child: MyText.p(text),
          )
        ],
      ),
    );
  }
}
