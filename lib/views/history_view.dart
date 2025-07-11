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
      backgroundColor: Get.theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Calculation History',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Get.theme.colorScheme.onBackground,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, size: 24),
            onPressed: _showClearHistoryDialog,
            color: Get.theme.colorScheme.onBackground.withOpacity(0.7),
            tooltip: 'Clear History',
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar with Neumorphic Style
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface.withOpacity(0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(4, 4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  offset: Offset(-4, -4),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                hintText: 'Search history...',
                hintStyle: GoogleFonts.inter(
                  fontSize: 16,
                  color: Get.theme.colorScheme.onSurface.withOpacity(0.5),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              style: GoogleFonts.inter(
                fontSize: 16,
                color: Get.theme.colorScheme.onSurface,
              ),
              onChanged: (value) => _controller.searchCalculations(value),
            ),
          ),
          // History List
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Get.theme.colorScheme.primary,
                    ),
                  ),
                );
              }

              if (_controller.calculations.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history_toggle_off,
                        size: 48,
                        color: Get.theme.colorScheme.onBackground.withOpacity(
                          0.3,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No history yet',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Get.theme.colorScheme.onBackground.withOpacity(
                            0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                itemCount: _controller.calculations.length,
                itemBuilder: (context, index) {
                  final calculation = _controller.calculations[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HistoryItem(
                      calculation: calculation,
                      onTap: () => _controller.useCalculation(calculation),
                      onFavorite:
                          (isFavorite) => _controller.toggleFavorite(
                            calculation.id!,
                            isFavorite,
                          ),
                      onDelete:
                          () => _controller.deleteCalculation(calculation.id!),
                    ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Get.theme.colorScheme.surface,
        title: Text(
          'Clear History',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Get.theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all history?',
          style: GoogleFonts.inter(
            fontSize: 16,
            color: Get.theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
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
                backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.9),
                colorText: Get.theme.colorScheme.onPrimary,
                borderRadius: 12,
                margin: EdgeInsets.all(16),
                snackStyle: SnackStyle.FLOATING,
                mainButton: TextButton(
                  onPressed: () => _controller.undoClear(),
                  child: Text(
                    'UNDO',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Get.theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Get.theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
