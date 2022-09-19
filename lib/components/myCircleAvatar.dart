import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyCircleAvatar extends StatelessWidget {
  const MyCircleAvatar.owner(this.owner, {this.radius = 30, super.key})
      : isOwner = true,
        dog = null;
  const MyCircleAvatar.dog(this.dog, {this.radius = 30, super.key})
      : isOwner = false,
        owner = null;

  final bool isOwner;
  final Owner? owner;
  final Dog? dog;
  final double radius;

  @override
  Widget build(BuildContext context) {
    //isOwner
    if (isOwner) {
      if (owner?.photoUrl == null) {
        return SvgPicture.asset('assets/svg/owner-empty-avatar.svg', height: 60);
      }
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(owner!.photoUrl!),
      );
    }

    // isDog
    if (dog?.photoUrl == null) {
      return SvgPicture.asset('assets/svg/dog-empty-avatar.svg', height: 60);
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(dog!.photoUrl!),
    );
  }
}
