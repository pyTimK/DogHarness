import 'package:bluetooth_app_test/components/bouncing.dart';
import 'package:bluetooth_app_test/components/myCircleAvatar.dart';
import 'package:bluetooth_app_test/models/dog.dart';
import 'package:bluetooth_app_test/models/owner.dart';
import 'package:bluetooth_app_test/styles.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  const MyListTile(
      {required this.title, required this.subtitle, required this.leading, required this.onPressed, super.key});
  final String title;
  final String subtitle;
  final Widget leading;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Bouncing(
      onPressed: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: MyStyles.dark,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          textColor: MyStyles.white,
          leading: leading,
          title: Text(title, style: MyStyles.h2),
          subtitle: Text(subtitle, style: MyStyles.p),
        ),
      ),
    );
  }
}

class _MyListView<T> extends StatelessWidget {
  const _MyListView(
      {required this.items,
      required this.onPressed,
      required this.leading,
      required this.title,
      required this.subtitle,
      super.key});
  // factory MyListView.dogs({required List<Dog> dogs, required void Function(Dog) onPressed}) {
  //   return MyListView(
  //     items: dogs,
  //     onPressed: onPressed,
  //     leading: (dog) => MyCircleAvatar(
  //       image: dog.image,
  //       radius: 30,
  //     ),
  //     title: (dog) => dog.name,
  //     subtitle: (dog) => dog.breed,
  //   );
  // }

  final List<T> items;
  final Function(T) onPressed;
  final Widget Function(T) leading;
  final String Function(T) title;
  final String Function(T) subtitle;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return MyListTile(
          leading: leading(item),
          title: title(item),
          subtitle: subtitle(item),
          onPressed: () => onPressed(item),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
    );
  }
}

class DogListView extends StatelessWidget {
  const DogListView({required this.dogs, required this.onPressed, super.key});

  final List<Dog> dogs;
  final Function(Dog) onPressed;

  @override
  Widget build(BuildContext context) {
    return _MyListView(
      items: dogs,
      onPressed: onPressed,
      leading: (dog) => MyCircleAvatar.dog(dog),
      title: (dog) => dog.name,
      subtitle: (dog) => dog.breed.toString(),
    );
  }
}

class OwnerListView extends StatelessWidget {
  const OwnerListView({required this.owners, required this.onPressed, super.key});

  final List<Owner> owners;
  final Function(Owner) onPressed;

  @override
  Widget build(BuildContext context) {
    return _MyListView(
      items: owners,
      onPressed: onPressed,
      leading: (owner) => MyCircleAvatar.owner(owner),
      title: (owner) => owner.nickname,
      subtitle: (owner) => owner.email,
    );
  }
}
