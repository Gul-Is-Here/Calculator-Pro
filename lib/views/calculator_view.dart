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

      // 🔘 Floating Save Button
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
            );
          },
          icon: Icon(Icons.save),
          label: Text('Save'),
        );
      }),

      body: SafeArea(
        child: Column(
          children: [
            // Display Area
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => Text(
                        _controller.currentExpression.value,
                        style: GoogleFonts.robotoMono(
                          fontSize: 20,
                          color: Get.theme.colorScheme.onBackground.withOpacity(
                            0.7,
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        _controller.currentResult.value,
                        style: GoogleFonts.robotoMono(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons Grid
            Expanded(
              flex: 5,
              child: Obx(
                () =>
                    _controller.isScientificMode.value
                        ? _buildScientificButtons()
                        : _buildBasicButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicButtons() {
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 4,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        CalculatorButton(
          text: 'C',
          color: Get.theme.colorScheme.error,
          onTap: _controller.clearExpression,
        ),
        CalculatorButton(
          text: '⌫',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.deleteLastCharacter,
        ),
        CalculatorButton(
          text: '%',
          color: Get.theme.colorScheme.secondary,
          onTap: () => _controller.appendToExpression('%'),
        ),
        CalculatorButton(
          text: '÷',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('÷'),
        ),
        CalculatorButton(
          text: '7',
          onTap: () => _controller.appendToExpression('7'),
        ),
        CalculatorButton(
          text: '8',
          onTap: () => _controller.appendToExpression('8'),
        ),
        CalculatorButton(
          text: '9',
          onTap: () => _controller.appendToExpression('9'),
        ),
        CalculatorButton(
          text: '×',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('×'),
        ),
        CalculatorButton(
          text: '4',
          onTap: () => _controller.appendToExpression('4'),
        ),
        CalculatorButton(
          text: '5',
          onTap: () => _controller.appendToExpression('5'),
        ),
        CalculatorButton(
          text: '6',
          onTap: () => _controller.appendToExpression('6'),
        ),
        CalculatorButton(
          text: '-',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('-'),
        ),
        CalculatorButton(
          text: '1',
          onTap: () => _controller.appendToExpression('1'),
        ),
        CalculatorButton(
          text: '2',
          onTap: () => _controller.appendToExpression('2'),
        ),
        CalculatorButton(
          text: '3',
          onTap: () => _controller.appendToExpression('3'),
        ),
        CalculatorButton(
          text: '+',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('+'),
        ),
        CalculatorButton(
          text: '☰',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.toggleScientificMode,
        ),
        CalculatorButton(
          text: '0',
          onTap: () => _controller.appendToExpression('0'),
        ),
        CalculatorButton(
          text: '.',
          onTap: () => _controller.appendToExpression('.'),
        ),
        CalculatorButton(
          text: '=',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('='),
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
          fontSize: 18,
          onTap: () => _controller.appendToExpression('sin('),
        ),
        CalculatorButton(
          text: 'cos',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('cos('),
        ),
        CalculatorButton(
          text: 'tan',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('tan('),
        ),
        CalculatorButton(
          text: 'log',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('log('),
        ),
        CalculatorButton(
          text: '√',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('√('),
        ),
        CalculatorButton(
          text: 'π',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('3.14159265359'),
        ),
        CalculatorButton(
          text: 'e',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('2.71828182846'),
        ),
        CalculatorButton(
          text: '(',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('('),
        ),
        CalculatorButton(
          text: ')',
          fontSize: 18,
          onTap: () => _controller.appendToExpression(')'),
        ),
        CalculatorButton(
          text: '^',
          fontSize: 18,
          onTap: () => _controller.appendToExpression('^'),
        ),
        CalculatorButton(
          text: 'C',
          color: Get.theme.colorScheme.error,
          onTap: _controller.clearExpression,
        ),
        CalculatorButton(
          text: '⌫',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.deleteLastCharacter,
        ),
        CalculatorButton(
          text: '%',
          color: Get.theme.colorScheme.secondary,
          onTap: () => _controller.appendToExpression('%'),
        ),
        CalculatorButton(
          text: '÷',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('÷'),
        ),
        CalculatorButton(
          text: '☰',
          color: Get.theme.colorScheme.secondary,
          onTap: _controller.toggleScientificMode,
        ),
        CalculatorButton(
          text: '7',
          onTap: () => _controller.appendToExpression('7'),
        ),
        CalculatorButton(
          text: '8',
          onTap: () => _controller.appendToExpression('8'),
        ),
        CalculatorButton(
          text: '9',
          onTap: () => _controller.appendToExpression('9'),
        ),
        CalculatorButton(
          text: '×',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('×'),
        ),
        CalculatorButton(
          text: '4',
          onTap: () => _controller.appendToExpression('4'),
        ),
        CalculatorButton(
          text: '5',
          onTap: () => _controller.appendToExpression('5'),
        ),
        CalculatorButton(
          text: '6',
          onTap: () => _controller.appendToExpression('6'),
        ),
        CalculatorButton(
          text: '-',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('-'),
        ),
        CalculatorButton(
          text: '=',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('='),
        ),
        CalculatorButton(
          text: '1',
          onTap: () => _controller.appendToExpression('1'),
        ),
        CalculatorButton(
          text: '2',
          onTap: () => _controller.appendToExpression('2'),
        ),
        CalculatorButton(
          text: '3',
          onTap: () => _controller.appendToExpression('3'),
        ),
        CalculatorButton(
          text: '+',
          color: Get.theme.colorScheme.primary,
          onTap: () => _controller.appendToExpression('+'),
        ),
      ],
    );
  }
}
