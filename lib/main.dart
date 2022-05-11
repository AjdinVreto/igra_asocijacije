import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:igra_asocijacije/screens/options_screen.dart';
import 'package:igra_asocijacije/screens/playgame_screen.dart';
import 'package:igra_asocijacije/screens/rules_screen.dart';

import 'Screens/startgame_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Igra Asocijacije",
      home: SafeArea(child: StartGame()),
      routes: {
        "/playgame": (ctx) => const PlayGame(),
        "/rules": (ctx) => const RulesScreen(),
        "/options": (ctx) => Options(),
      },
    );
  }
}
