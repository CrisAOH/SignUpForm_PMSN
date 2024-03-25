//import 'dart:math';
import 'package:flutter/material.dart';

class RatingCircle extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final double borderWidth;

  const RatingCircle({
    Key? key,
    required this.rating,
    this.size = 80,
    this.color = Colors.amber,
    this.borderWidth = 7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size -
                borderWidth *
                    2, // Ajustar el tamaño del CircularProgressIndicator
            height: size -
                borderWidth *
                    2, // Ajustar el tamaño del CircularProgressIndicator
            child: CircularProgressIndicator(
              value: rating / 10,
              strokeWidth: borderWidth,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              backgroundColor: Colors.grey.withOpacity(0.3),
            ),
          ),
          Text(
            '${(rating * 10).toInt()}%', // Mostrar el porcentaje de la calificación
            style: TextStyle(
              fontSize: size * 0.2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
