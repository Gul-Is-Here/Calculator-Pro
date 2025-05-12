// widgets/history_item.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/calculation.dart';

class HistoryItem extends StatelessWidget {
  final Calculation calculation;
  final VoidCallback onTap;
  final Function(bool) onFavorite;
  final VoidCallback onDelete;
  
  const HistoryItem({
    required this.calculation,
    required this.onTap,
    required this.onFavorite,
    required this.onDelete,
    Key? key,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      calculation.expression,
                      style: GoogleFonts.robotoMono(
                        fontSize: 18,
                        color: Get.theme.colorScheme.onBackground,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      calculation.isFavorite 
                        ? Icons.favorite 
                        : Icons.favorite_border,
                      color: calculation.isFavorite 
                        ? Colors.red 
                        : Get.theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                    onPressed: () => onFavorite(!calculation.isFavorite),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '= ${calculation.result}',
                style: GoogleFonts.robotoMono(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    calculation.formattedDate,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Get.theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline,
                      color: Get.theme.colorScheme.error.withOpacity(0.7)),
                    onPressed: onDelete,
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}