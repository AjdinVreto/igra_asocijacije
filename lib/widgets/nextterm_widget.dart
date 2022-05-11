import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class NextTerm extends StatelessWidget {
  Function refresh;

  NextTerm(this.refresh);

  @override
  Widget build(BuildContext context) {
    AudioCache audioCache = AudioCache();

    return Container(
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.only(bottom: 25),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextButton.icon(
          icon: const Icon(
            Icons.navigate_before,
            size: 40,
            color: Colors.yellow,
          ),
          onPressed: () {
            audioCache.play('next.mp3');
            audioCache.clear(Uri.parse('next.mp3'));
            refresh();
          },
          label: const Text(
            'Sljedeći pojam',
            style: TextStyle(color: Colors.white),
          ),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Colors.white,
                width: 1,
              ),
            ),
            enableFeedback: false,
            backgroundColor: Colors.purple,
            textStyle:
                const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }
}
