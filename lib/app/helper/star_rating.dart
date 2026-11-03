/*Papabear*/
import 'package:flutter/material.dart';

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color emptyColor;
  final double size;

  const StarRating({
    Key? key,
    this.starCount = 5,
    this.rating = .0,
    required this.onRatingChanged,
    required this.color,
    this.emptyColor = const Color(0x66F2D338),
    this.size = 40,
  }) : super(key: key);

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        size: size,
        color: emptyColor,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        size: size,
        color: color,
      );
    } else {
      icon = Icon(
        Icons.star,
        size: size,
        color: color,
      );
    }
    return InkResponse(
      onTap: () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          List.generate(starCount, (index) => buildStar(context, index)),
    );
  }
}
