import 'dart:math';

import 'package:flutter/material.dart';

class BinaryPainter extends CustomPainter {
  BinaryPainter({ Listenable? repaint }) : super(repaint: repaint);

  int decimal2binary(int input) {
    int binary = 0, i = 1;
    while (input > 0) {
      binary = binary + (input % 2)*i;
      input = (input/2).floor();
      i = i * 10;
    }
    return binary;
  }

  @override
  void paint(Canvas canvas, Size sizeT) {
    final width = sizeT.width;
    final DateTime now = DateTime.now();

    final hour = now.hour;
    final mins = now.minute;
    final secs = now.second;

    final int gap = 15;
    final int cols = 6;

    final double size = (width / (cols * 2)) - (((gap / cols ) * (cols - 1)) / 2);
    double posX = size;
    double posY = size;

    int counter = 0;

    for (int time in [hour, mins, secs]) {
      counter++;

      final formattedTime = time.toString().padLeft(2, '0');
      final firstDigit = formattedTime[0];
      final lastDigit = formattedTime[1];

      for(int i = 0; i < 2; i++) {
        posY = 0;
        String? digit;
        digit = i % 2 == 0 ? firstDigit : lastDigit;

        final textPainter = TextPainter(
            text: TextSpan(
              text: counter < 2 ? 'H' : counter < 3 ? 'M' : 'S',
              style: const TextStyle(
                color: Color(0xFF57c5ab),
                fontSize: 30,
              ),
            ),
            textDirection: TextDirection.rtl,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: width,
        );
        textPainter.paint(canvas, Offset(posX - size / 2, posY));

        posY = 10 + size * 2 + gap;

        final binary = decimal2binary(int.parse(digit)).toString().padLeft(4, '0');
        for(String char in binary.split('')) {
          final paints = Paint()
            ..style = char == '0' ? PaintingStyle.stroke : PaintingStyle.fill
            ..strokeWidth = 4.0
            ..color = const Color(0xFF57c5ab);
          final offset = Offset(posX, posY);
          canvas.drawCircle(offset, size, paints);
          posY += size * 2 + gap;
        }
        posX += size * 2 + gap;
      }
    }
  }

  @override
  bool shouldRepaint(BinaryPainter oldDelegate) => true;
}