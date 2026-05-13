import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

final customerInfoProvider = FutureProvider<CustomerInfo?>((ref) async {
  try {
    return await Purchases.getCustomerInfo();
  } catch (_) {
    return null;
  }
});

final isSubscribedProvider = Provider<bool>((ref) {
  final info = ref.watch(customerInfoProvider).valueOrNull;
  return info?.entitlements.active.containsKey('pro') ?? false;
});
