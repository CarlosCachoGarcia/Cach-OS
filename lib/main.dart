import 'package:flutter/material.dart';

import 'app.dart';
import 'core/dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StoreApp(Dependencies()));
}
