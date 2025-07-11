import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/calculator_controller.dart';
import '../widgets/calculator_button.dart';

class CalculatorView extends StatelessWidget {
  final CalculatorController _controller = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Display Area with Gradient Background
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Get.theme.colorScheme.background,
                      Get.theme.colorScheme.background.withOpacity(0.9),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(
                        () => Text(
                          _controller.currentExpression.value.isEmpty
                              ? '0'
                              : _controller.currentExpression.value,
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            color: Get.theme.colorScheme.onBackground
                                .withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(
                        () => Text(
                          _controller.currentResult.value,
                          style: GoogleFonts.inter(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Get.theme.colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons Grid
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.surface.withOpacity(0.95),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Obx(
                  () =>
                      _controller.isScientificMode.value
                          ? _buildScientificButtons()
                          : _buildBasicButtons(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        // Only show if there's something to save and it's not an error
        if (_controller.currentExpression.isEmpty ||
            _controller.currentResult.value == 'Error' ||
            _controller.currentResult.value == '0') {
          return SizedBox.shrink();
        }
        return FloatingActionButton.extended(
          onPressed: () async {
            await _controller.saveCalculation();
            Get.snackbar(
              'Saved',
              'Calculation saved to history',
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              backgroundColor: Get.theme.colorScheme.primary.withOpacity(0.9),
              colorText: Get.theme.colorScheme.onPrimary,
              borderRadius: 12,
              margin: EdgeInsets.all(16),
              snackStyle: SnackStyle.FLOATING,
            );
          },
          icon: Icon(Icons.save, size: 20),
          label: Text(
            'Save',
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Get.theme.colorScheme.primary,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      }),
    );
  }

  Widget _buildBasicButtons() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        CalculatorButton(
          text: 'C',
          color: Get.theme.colorScheme.error,
          onTap: _controller.clearExpression,
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '⌫',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.deleteLastCharacter,
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '%',
          color: Get.theme.colorScheme.secondary,
          onTap: () => _controller.appendToExpression('%'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '÷',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('÷'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '7',
          onTap: () => _controller.appendToExpression('7'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '8',
          onTap: () => _controller.appendToExpression('8'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '9',
          onTap: () => _controller.appendToExpression('9'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '×',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('×'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '4',
          onTap: () => _controller.appendToExpression('4'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '5',
          onTap: () => _controller.appendToExpression('5'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '6',
          onTap: () => _controller.appendToExpression('6'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '-',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('-'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '1',
          onTap: () => _controller.appendToExpression('1'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '2',
          onTap: () => _controller.appendToExpression('2'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '3',
          onTap: () => _controller.appendToExpression('3'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '+',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('+'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '☰',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.toggleScientificMode,
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '0',
          onTap: () => _controller.appendToExpression('0'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '.',
          onTap: () => _controller.appendToExpression('.'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '=',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('='),
          isNeumorphic: true,
        ),
      ],
    );
  }

  Widget _buildScientificButtons() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1,
      children: [
        CalculatorButton(
          text: 'sin',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('sin('),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: 'cos',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('cos('),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: 'tan',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('tan('),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: 'log',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('log('),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '√',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('√('),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: 'π',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('3.14159265359'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: 'e',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('2.71828182846'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '(',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('('),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: ')',
          fontSize: 16,
          onTap: () => _controller.appendToExpression(')'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '^',
          fontSize: 16,
          onTap: () => _controller.appendToExpression('^'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: 'C',
          color: Get.theme.colorScheme.error,
          onTap: _controller.clearExpression,
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '⌫',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.deleteLastCharacter,
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '%',
          color: Get.theme.colorScheme.secondary,
          onTap: () => _controller.appendToExpression('%'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '÷',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('÷'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '☰',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.toggleScientificMode,
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '7',
          onTap: () => _controller.appendToExpression('7'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '8',
          onTap: () => _controller.appendToExpression('8'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '9',
          onTap: () => _controller.appendToExpression('9'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '×',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('×'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '4',
          onTap: () => _controller.appendToExpression('4'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '5',
          onTap: () => _controller.appendToExpression('5'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '6',
          onTap: () => _controller.appendToExpression('6'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '-',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('-'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '=',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('='),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '1',
          onTap: () => _controller.appendToExpression('1'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '2',
          onTap: () => _controller.appendToExpression('2'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '3',
          onTap: () => _controller.appendToExpression('3'),
          isNeumorphic: true,
        ),
        CalculatorButton(
          text: '+',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('+'),
          isNeumorphic: true,
        ),
      ],
    );
  }
}
