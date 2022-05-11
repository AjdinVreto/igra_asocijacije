import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({Key? key}) : super(key: key);
  static const RouteName = '/rules';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bodyWidget(context),
    );
  }

  Widget bodyWidget(context) {
    return Stack(
      children: <Widget>[
        Image(
          image: const AssetImage("./assets/slikapozadine.jpg"),
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 35,
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
                    backgroundColor:
                        MaterialStateProperty.all(Colors.orangeAccent),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "PRAVILO 1. Za igru je potrebno 4 igrača koji će biti podijeljeni u dva tima.",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
