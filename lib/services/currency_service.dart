// // services/currency_service.dart
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class CurrencyService {
//   static const _apiKey = 'YOUR_API_KEY'; // Get from https://exchangerate-api.com
//   static const _baseUrl = 'https://v6.exchangerate-api.com/v6';
  
//   Future<double> convert(String from, String to, double amount) async {
//     final url = '$_baseUrl/$_apiKey/pair/$from/$to/$amount';
//     final response = await http.get(Uri.parse(url));
    
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       return data['conversion_result'];
//     } else {
//       throw Exception('Failed to convert currency');
//     }
//   }
// }

// // Then add to calculator controller
// final CurrencyService _currencyService = CurrencyService();

// Future<void> convertCurrency(String expression) async {
//   // Parse expression like "100 USD to EUR"
//   final parts = expression.split(' ');
//   if (parts.length == 4 && parts[2] == 'to') {
//     try {
//       final amount = double.parse(parts[0]);
//       final from = parts[1].toUpperCase();
//       final to = parts[3].toUpperCase();
      
//       final result = await _currencyService.convert(from, to, amount);
//       currentResult.value = '$result $to';
//     } catch (e) {
//       currentResult.value = 'Conversion error';
//     }
//   }
// }