import 'package:flutter/material.dart';

import '../model/Pojam.dart';


class LoadTerm extends StatelessWidget {
  List<Pojam> pojmovi;
  int randomBroj;

  LoadTerm(this.pojmovi, this.randomBroj);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        pojmovi[randomBroj].Naziv!,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 48,
          color: Colors.white
        ),
      ),
    );
  }
}
