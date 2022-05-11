import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:igra_asocijacije/screens/options_screen.dart';
import 'package:igra_asocijacije/screens/playgame_screen.dart';
import 'package:igra_asocijacije/screens/rules_screen.dart';

class StartGame extends StatefulWidget {
  static int roundDuration = 180;
  static int changeTermNumber = 3;

  @override
  _StartGameState createState() => _StartGameState();
}

class _StartGameState extends State<StartGame> {
  AudioCache audioCache = AudioCache();

  TextEditingController timJedanIme = TextEditingController()..text = 'TIM 1';
  TextEditingController timDvaIme = TextEditingController()..text = 'TIM 2';

  @override
  void initState() {
    audioCache.load('start.mp3');
  }

  @override
  void dispose() {
    audioCache.clearAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return Stack(
      children: <Widget>[
        Image(
          image: const AssetImage("./assets/slikapozadine.jpg"),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          margin: const EdgeInsets.only(right: 12, top: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 1, color: Colors.white),
                ),
                child: const Text(
                  "PODEŠAVANJA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  audioCache.play('start.mp3');
                  audioCache.clear(Uri.parse('start.mp3'));
                  Navigator.of(context).pushNamed(Options.RouteName);
                },
                child: const Icon(
                  Icons.settings,
                  size: 35,
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const CircleBorder(
                          side: BorderSide(
                        width: 1,
                        color: Colors.white,
                      )),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(10))),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 25),
                child: textButtonWidget(true, "START")),
            Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 25),
                child: textButtonWidget(false, "PRAVILA")),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            textField(timJedanIme, Alignment.bottomLeft, Colors.blueAccent),
            textField(timDvaIme, Alignment.bottomRight, Colors.red),
          ],
        )
      ],
    );
  }

  Widget textButtonWidget(bool game, String title) {
    return TextButton.icon(
      onPressed: () {
        audioCache.play('start.mp3');
        audioCache.clear(Uri.parse('start.mp3'));
        if (game) {
          Navigator.of(context).pushNamed(PlayGame.routeName, arguments: {
            'timJedan': timJedanIme.text,
            'timDva': timDvaIme.text
          });
        } else {
          Navigator.of(context).pushNamed(RulesScreen.RouteName);
        }
      },
      icon: Icon(
        game ? Icons.play_arrow_rounded : Icons.rule,
        size: 45.0,
        color: game ? Colors.green : Colors.yellow,
      ),
      label: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
        padding: const EdgeInsets.all(12),
        enableFeedback: false,
        backgroundColor: Colors.purple,
        onSurface: Colors.white,
        textStyle: const TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget textField(controller, alignment, boja) {
    return Container(
      alignment: alignment,
      width: 200,
      margin: const EdgeInsets.all(20),
      child: TextField(
        maxLength: 10,
        onSubmitted: (text) {
          controller.text = text;
        },
        cursorColor: Colors.black,
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
        decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: boja,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black87)),
            hintText: 'Unesite naziv tima'),
      ),
    );
  }
}
