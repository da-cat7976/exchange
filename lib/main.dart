import 'package:exchange/gen/strings.g.dart';
import 'package:exchange/view/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();

  runApp(ProviderScope(child: ExchangeApp()));
}
