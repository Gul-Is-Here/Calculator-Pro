// controllers/calculator_controller.dart
import 'package:calculator_app/controllers/history_controller.dart';
import 'package:get/get.dart';
import 'package:calculator_app/services/calculator_service.dart';
import 'package:calculator_app/repositories/history_repository.dart';
import 'package:calculator_app/models/calculation.dart';

class CalculatorController extends GetxController {
  final CalculatorService _calculatorService = CalculatorService();
  final HistoryRepository _historyRepository = HistoryRepository();

  RxString currentExpression = ''.obs;
  RxString currentResult = '0'.obs;
  RxBool isScientificMode = false.obs;

  void appendToExpression(String value) {
    // Handle number input
    if (_isDigit(value) || value == '.') {
      // If last input was an operator or expression is empty, just add the digit
      if (currentExpression.isEmpty || _endsWithOperator()) {
        currentExpression.value += value;
      }
      // If we're continuing a number
      else {
        // Get the last number in the expression
        final lastNumber = _getLastNumber();
        // Don't allow multiple decimal points in a number
        if (value == '.' && lastNumber.contains('.')) {
          return;
        }
        currentExpression.value += value;
      }
    }
    // Handle operator input
    else if (_isOperator(value)) {
      // Don't allow operators at the start (except minus for negative numbers)
      if (currentExpression.isEmpty && value != '-') {
        return;
      }

      // Don't allow multiple operators in a row
      if (_endsWithOperator()) {
        // Replace the last operator with the new one
        currentExpression.value =
            currentExpression.value.substring(
              0,
              currentExpression.value.length - _getLastOperator().length,
            ) +
            value;
      } else {
        currentExpression.value += value;
      }
    }
    // Handle equals
    else if (value == '=') {
      if (!_endsWithOperator() && currentExpression.isNotEmpty) {
        _evaluateExpression();
        currentExpression.value = currentResult.value;
      }
    }
    // Handle other inputs (parentheses, etc.)
    else {
      currentExpression.value += value;
    }

    _evaluateExpression();
  }

  void clearExpression() {
    currentExpression.value = '';
    currentResult.value = '0';
  }

  void deleteLastCharacter() {
    if (currentExpression.isNotEmpty) {
      currentExpression.value = currentExpression.value.substring(
        0,
        currentExpression.value.length - 1,
      );
      _evaluateExpression();
    }
  }

  void _evaluateExpression() {
    if (currentExpression.isEmpty) {
      currentResult.value = '0';
      return;
    }

    // Try to "close" open functions for preview
    String expression = currentExpression.value;

    // Auto-close open parentheses if a number follows
    if (_hasUnbalancedFunctionParenthesis(expression)) {
      expression += ')'; // try closing the function call
    }

    try {
      currentResult.value = _calculatorService.evaluate(expression);
    } catch (e) {
      currentResult.value = '';
    }
  }

  bool _hasUnbalancedFunctionParenthesis(String expr) {
    final openFunctions = ['sin(', 'cos(', 'tan(', 'log(', '√('];
    for (var func in openFunctions) {
      if (expr.contains(func) && !expr.contains(')')) {
        return true;
      }
    }
    return false;
  }

  bool _endsWithDecimal() {
    return currentExpression.value.endsWith('.');
  }

  bool _endsWithOpenFunction() {
    return currentExpression.value.endsWith('sin(') ||
        currentExpression.value.endsWith('cos(') ||
        currentExpression.value.endsWith('tan(') ||
        currentExpression.value.endsWith('log(') ||
        currentExpression.value.endsWith('√(');
  }

  bool _hasBalancedParentheses() {
    int open = '('.allMatches(currentExpression.value).length;
    int close = ')'.allMatches(currentExpression.value).length;
    return open == close;
  }

  bool _isDigit(String value) {
    return RegExp(r'[0-9]').hasMatch(value);
  }

  bool _isOperator(String value) {
    return ['+', '-', '×', '÷', '%', '^'].contains(value);
  }

  bool _endsWithOperator() {
    if (currentExpression.isEmpty) return false;
    return _isOperator(
      currentExpression.value.substring(currentExpression.value.length - 1),
    );
  }

  String _getLastOperator() {
    if (currentExpression.isEmpty) return '';
    final lastChar = currentExpression.value.substring(
      currentExpression.value.length - 1,
    );
    return _isOperator(lastChar) ? lastChar : '';
  }

  String _getLastNumber() {
    if (currentExpression.isEmpty) return '';

    final chars = currentExpression.value.split('');
    String number = '';

    // Work backwards through the expression to find the last number
    for (int i = chars.length - 1; i >= 0; i--) {
      if (_isDigit(chars[i]) || chars[i] == '.') {
        number = chars[i] + number;
      } else {
        break;
      }
    }

    return number;
  }

  void toggleScientificMode() {
    isScientificMode.toggle();
  }

  Future<void> saveCalculation() async {
    if (currentExpression.isNotEmpty && currentResult.value != 'Error') {
      final calculation = Calculation(
        expression: currentExpression.value,
        result: currentResult.value,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      await _historyRepository.insertCalculation(calculation);

      // 🔁 Refresh history in real-time if it's in memory
      if (Get.isRegistered<HistoryController>()) {
        Get.find<HistoryController>().loadCalculations();
      }
    }
  }

  void useCalculation(Calculation calculation) {
    currentExpression.value = calculation.expression;
    currentResult.value = calculation.result;
  }
}
