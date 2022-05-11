import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:igra_asocijacije/database/asocijacije_database.dart';
import 'package:igra_asocijacije/screens/startgame_screen.dart';
import 'package:igra_asocijacije/widgets/nextterm_widget.dart';

import '../model/Pojam.dart';
import '../widgets/loadterm_widget.dart';

class PlayGame extends StatefulWidget {
  const PlayGame({Key? key}) : super(key: key);

  static const routeName = "/playgame";

  @override
  _PlayGameState createState() => _PlayGameState();
}

class _PlayGameState extends State<PlayGame> {
  AudioCache audioCache = AudioCache();
  AudioPlayer player = AudioPlayer();
  Random random = Random();
  late int randomNumber;

  List<Pojam>? terms;
  List<int> usedTerms = [];

  int teamOneRounds = 0;
  int teamTwoRounds = 0;
  int teamOnePoints = 0;
  int teamTwoPoints = 0;

  int teamTurn = 0;
  int roundNumber = 0;

  bool winner = false;

  late Timer timer;
  late int timerCounter;
  late int roundDuration;
  late int changeTermNumber;

  bool timerCheck = false;
  bool paused = false;

  @override
  void initState() {
    roundDuration = StartGame.roundDuration;
    changeTermNumber = StartGame.changeTermNumber;

    randomNumber = random.nextInt(222);
    usedTerms.add(randomNumber);

    audioCache.load('ticking.mp3');
    audioCache.load('end.mp3');

    startTimer(3, true);
    super.initState();
  }

  @override
  void dispose() {
    player.stop();
    timer.cancel();
    audioCache.clearAll();
    super.dispose();
  }

  void countSound() async {
    player = await audioCache.play('ticking.mp3');
  }

  void endSound() async {
    await audioCache.play('end.mp3');
  }

  void startTimer(duration, startRoundTimer) {
    timerCounter = duration;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (timerCounter > 0) {
            timerCounter--;
            if (timerCounter == 10) {
              countSound();
            }
            if (timerCounter == 0 && startRoundTimer == false) {
              endSound();
            }
          } else {
            audioCache.clear(Uri.parse('ticking.mp3'));
            timer.cancel();
            timerCounter = -1;

            if (startRoundTimer) {
              startTimer(roundDuration, false);
              timerCheck = true;
            } else {
              timerCheck = false;
            }
          }
        });
      }
    });
  }

  void newTerm() {
    randomNumber = random.nextInt(222);
  }

  void newRound() {
    timer.cancel();
    roundNumber++;

    if (roundNumber % 2 == 0) {
      if (teamOnePoints > teamTwoPoints) {
        teamOneRounds++;
      } else if (teamOnePoints == teamTwoPoints) {
        teamOneRounds = teamOneRounds;
        teamTwoRounds = teamTwoRounds;
      } else {
        teamTwoRounds++;
      }

      teamOnePoints = 0;
      teamTwoPoints = 0;
    }
    teamTurn++;
    changeTermNumber = StartGame.changeTermNumber;

    newTerm();
    checkWinner();
  }

  void checkWinner() {
    if (teamOneRounds - 2 == teamTwoRounds ||
        teamTwoRounds - 2 == teamOneRounds) {
      winner = true;
      setState(() {
        timerCounter = 0;
      });
    } else {
      setState(() {
        startTimer(3, true);
      });
    }
  }

  void refresh() {
    bool termExistsCheck = false;
    newTerm();

    usedTerms.forEach((element) {
      if (element == randomNumber) termExistsCheck = true;
    });

    if (termExistsCheck) {
      refresh();
    } else {
      teamTurn % 2 == 0 ? teamOnePoints++ : teamTwoPoints++;
      setState(() {
        usedTerms.add(randomNumber);
        if (usedTerms.length == 222) usedTerms.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    return Scaffold(body: terms == null ? getData(args) : bodyWidget(args));
  }

  Widget getData(args) {
    return FutureBuilder<List<Pojam>?>(
      future: AsocijacijeDatabase.instance.readAll(),
      builder: (BuildContext context, AsyncSnapshot<List<Pojam>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        } else {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Greska na serveru, pokusajte ponovo"),
            );
          } else {
            terms = snapshot.data;
            return bodyWidget(args);
          }
        }
      },
    );
  }

  Widget bodyWidget(args) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage("./assets/slikapozadine.jpg"),
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          if (timerCounter > -1 && !timerCheck && !winner) ...[
            teamInfo(args),
          ] else if (timerCounter > -1 && timerCheck) ...[
            gamePlay(args)
          ] else if (winner) ...[
            gameWinner(args),
          ] else ...[
            gameInfo(args),
          ]
        ],
      ),
    );
  }

  Widget teamInfo(args) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        teamTurn % 2 == 0
            ? args['timJedan'] + " je na redu " + timerCounter.toString()
            : args['timDva'] + " je na redu " + timerCounter.toString(),
        style: const TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget gamePlay(args) {
    return Stack(
      children: [
        Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left: 4, top: 4),
            child: decoratedBoxWidget(
                args, "timJedan", Colors.blueAccent, teamOneRounds)),
        Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.only(right: 4, top: 4),
            child:
                decoratedBoxWidget(args, "timDva", Colors.red, teamTwoRounds)),
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 4),
          child: timerWidget(),
        ),
        LoadTerm(terms!, randomNumber),
        NextTerm(refresh),
        Container(
          alignment: Alignment.bottomLeft,
          margin: const EdgeInsets.only(bottom: 25, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (changeTermNumber > 0) {
                    setState(() {
                      refresh();
                      changeTermNumber--;
                    });
                  }
                },
                icon: const Icon(
                  Icons.repeat,
                  size: 32,
                ),
                label: Text(
                  "$changeTermNumber",
                  style: const TextStyle(fontSize: 26),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const CircleBorder(
                        side: BorderSide(
                      width: 1,
                      color: Colors.white,
                    )),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(20),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (!paused) {
                      player.pause();
                      timer.cancel();
                      paused = true;
                    } else {
                      player.resume();
                      startTimer(timerCounter, false);
                      paused = false;
                    }
                  });
                },
                child: paused
                    ? const Icon(
                        Icons.play_arrow,
                        size: 32,
                      )
                    : const Icon(
                        Icons.pause,
                        size: 32,
                      ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    const CircleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                  ),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.all(20),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget gameWinner(args) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            teamOneRounds > teamTwoRounds
                ? args['timJedan'] + " pobjednik"
                : args['timDva'] + " pobjednik",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 90),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Završi igru',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.purple,
              textStyle:
                  const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.all(10),
            ),
          ),
        )
      ],
    );
  }

  Widget gameInfo(args) {
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(
            teamTurn % 2 == 0
                ? args['timJedan'] + " - Vaš rezultat je $teamOnePoints"
                : args['timDva'] +
                    " - Vaš rezultat je $teamTwoPoints" +
                    "\n\n           Rezultat runde \n      " +
                    args['timJedan'] +
                    " | $teamOnePoints" +
                    " - " +
                    "$teamTwoPoints | " +
                    args['timDva'],
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 25),
          child: TextButton(
            onPressed: newRound,
            child: const Text(
              'Dalje',
              style: TextStyle(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.purple,
                textStyle:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                padding: const EdgeInsets.all(10)),
          ),
        )
      ],
    );
  }

  Widget decoratedBoxWidget(args, tim, boja, teamRounds) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: boja,
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: const BorderRadius.only(
            bottomRight: Radius.elliptical(40, 15),
            topLeft: Radius.elliptical(40, 15)),
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
        height: 70,
        width: 150,
        child: Column(
          children: [
            Text(
              args[tim],
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              teamRounds.toString(),
              style: const TextStyle(
                fontSize: 35,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timerWidget() {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 40,
      child: CircleAvatar(
        backgroundColor: Colors.green,
        radius: 38,
        child: Text(
          timerCounter.toString(),
          style: const TextStyle(
              fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
