// views/history_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/history_controller.dart';
import '../models/calculation.dart';
import '../widgets/history_item.dart';

class HistoryView extends StatelessWidget {
  final HistoryController _controller = Get.put(HistoryController());
  final TextEditingController _searchController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculation History', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _showClearHistoryDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search history...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) => _controller.searchCalculations(value),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              if (_controller.calculations.isEmpty) {
                return Center(
                  child: Text(
                    'No history yet',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Get.theme.colorScheme.onBackground.withOpacity(0.5),
                    ),
                  ),
                );
              }
              
              return ListView.builder(
                itemCount: _controller.calculations.length,
                itemBuilder: (context, index) {
                  final calculation = _controller.calculations[index];
                  return HistoryItem(
                    calculation: calculation,
                    onTap: () => _controller.useCalculation(calculation),
                    onFavorite: (isFavorite) => 
                      _controller.toggleFavorite(calculation.id!, isFavorite),
                    onDelete: () => _controller.deleteCalculation(calculation.id!),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
  
  void _showClearHistoryDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Clear History', style: GoogleFonts.poppins()),
        content: Text('Are you sure you want to delete all history?', 
          style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              _controller.clearAllHistory();
              Get.back();
              Get.snackbar(
                'History Cleared',
                'All calculations have been deleted',
                snackPosition: SnackPosition.BOTTOM,
                duration: Duration(seconds: 3),
                mainButton: TextButton(
                  onPressed: () => _controller.undoClear(),
                  child: Text('UNDO', style: TextStyle(color: Colors.white)),
                ),
              );
            },
            child: Text('Delete', style: GoogleFonts.poppins(
              color: Get.theme.colorScheme.error,
            )),
          ),
        ],
      ),
    );
  }
}