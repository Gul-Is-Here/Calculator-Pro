import 'dart:math';

import 'package:math_expressions/math_expressions.dart';

class CalculatorService {
  String evaluate(String expression) {
    try {
      // Replace × and ÷ with * and /
      expression = expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Replace scientific functions like sin(), log(), √(), etc.
      expression = _replaceScientificFunctions(expression);

      // Evaluate the expression using math_expressions
      final result = _evaluateExpression(expression);

      // Return formatted result without unnecessary trailing zeros
      return result.toString().replaceAllMapped(
        RegExp(r'\.0+$|(\.\d*?[1-9])0+$'),
        (match) => match.group(1) ?? '',
      );
    } catch (e) {
      throw Exception('Invalid expression');
    }
  }

  double _evaluateExpression(String expression) {
    final parser = Parser();
    final exp = parser.parse(expression);
    final cm = ContextModel();
    return exp.evaluate(EvaluationType.REAL, cm);
  }

  String _replaceScientificFunctions(String expression) {
    final functions = {
      'sin': (double x) => sin(x),
      'cos': (double x) => cos(x),
      'tan': (double x) => tan(x),
      'log': (double x) => log(x),
      '√': (double x) => sqrt(x),
      '%': (double x) => x / 100,
    };

    functions.forEach((fn, operation) {
      final pattern = RegExp('$fn\\(([^)]+)\\)');
      while (expression.contains(pattern)) {
        final match = pattern.firstMatch(expression);
        if (match == null) break;

        final value = double.parse(match.group(1)!);
        final result = operation(value);
        expression = expression.replaceRange(
          match.start,
          match.end,
          result.toString(),
        );
      }
    });

    return expression;
  }
}
