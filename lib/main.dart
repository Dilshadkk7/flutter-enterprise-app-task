import 'package:flutter/material.dart';
import 'package:flutter_enterprise_app/app.dart';
import 'package:flutter_enterprise_app/core/di/service_locator.dart' as di;
import 'package:flutter_enterprise_app/core/persistence/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await di.sl<HiveService>().init();
  runApp(const MyApp());
}