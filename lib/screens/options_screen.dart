import 'package:flutter/material.dart';
import 'package:igra_asocijacije/screens/startgame_screen.dart';

class Options extends StatefulWidget {
  static const RouteName = "/options";

  @override
  _OptionsState createState() => _OptionsState();
}

class _OptionsState extends State<Options> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return Stack(
      children: [
        Image(
          image: const AssetImage("./assets/slikapozadine.jpg"),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.arrow_back, size: 35,),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const CircleBorder(),
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(8))
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 50),
                    child: const Text(
                      "OPCIJE",
                      style: TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text(""),
                ],
              ),
              const Text(
                "Vrijeme trajanja runde (sekunde)",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        value: 120,
                        groupValue: StartGame.roundDuration,
                        onChanged: (val) {
                          setState(() {
                            StartGame.roundDuration = val as int;
                          });
                        },
                        activeColor: Colors.green,
                        title: const Text(
                          "120",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        value: 180,
                        groupValue: StartGame.roundDuration,
                        onChanged: (val) {
                          setState(() {
                            StartGame.roundDuration = val as int;
                          });
                        },
                        activeColor: Colors.green,
                        title: const Text(
                          "180",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        value: 300,
                        groupValue: StartGame.roundDuration,
                        onChanged: (val) {
                          setState(() {
                            StartGame.roundDuration = val as int;
                          });
                        },
                        activeColor: Colors.green,
                        title: const Text(
                          "300",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Broj dozvoljenih promjena pojma po rundi",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        value: 1,
                        groupValue: StartGame.changeTermNumber,
                        onChanged: (val) {
                          setState(() {
                            StartGame.changeTermNumber = val as int;
                          });
                        },
                        activeColor: Colors.green,
                        title: const Text(
                          "1",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        value: 3,
                        groupValue: StartGame.changeTermNumber,
                        onChanged: (val) {
                          setState(() {
                            StartGame.changeTermNumber = val as int;
                          });
                        },
                        activeColor: Colors.green,
                        title: const Text(
                          "3",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile(
                        value: 5,
                        groupValue: StartGame.changeTermNumber,
                        onChanged: (val) {
                          setState(() {
                            StartGame.changeTermNumber = val as int;
                          });
                        },
                        activeColor: Colors.green,
                        title: const Text(
                          "5",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
