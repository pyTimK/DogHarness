import 'package:bluetooth_app_test/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void signOut(WidgetRef ref) {
  FirebaseAuth.instance.signOut();
  ref.invalidate(defaultDateProvider.notifier);
}
