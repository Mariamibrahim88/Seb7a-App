import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  CustomCard({
    super.key,
    required this.text,
    required this.onCardTap,
  });
  final String text;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onCardTap,
        child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14), color: Colors.white),
          child: Center(child: Text(text)),
        ),
      ),
    );
  }
}
