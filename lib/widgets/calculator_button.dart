// widgets/calculator_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final VoidCallback onTap;
  
  const CalculatorButton({
    required this.text,
    required this.onTap,
    this.color,
    this.fontSize,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.robotoMono(
              fontSize: fontSize ?? 24,
              fontWeight: FontWeight.w500,
              color: color != null 
                ? Theme.of(context).colorScheme.onPrimary 
                : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}