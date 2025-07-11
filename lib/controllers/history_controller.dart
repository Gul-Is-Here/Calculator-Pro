// controllers/history_controller.dart
import 'package:calculator_app/controllers/calculator_controller.dart';
import 'package:get/get.dart';
import 'package:calculator_app/repositories/history_repository.dart';
import 'package:calculator_app/models/calculation.dart';

class HistoryController extends GetxController {
  final HistoryRepository _historyRepository = HistoryRepository();
  
  RxList<Calculation> calculations = <Calculation>[].obs;
  RxBool isLoading = true.obs;
  List<Calculation> _backupCalculations = [];
  
  @override
  void onInit() {
    super.onInit();
    loadCalculations();
  }
  
Future<void> loadCalculations() async {
  isLoading.value = true;
  calculations.value = await _historyRepository.getAllCalculations();
  print("Loaded history: ${calculations.length} items");
  isLoading.value = false;
}
  
  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await _historyRepository.toggleFavorite(id, isFavorite);
    loadCalculations();
  }
  
  Future<void> deleteCalculation(int id) async {
    await _historyRepository.deleteCalculation(id);
    loadCalculations();
  }
  
  Future<void> clearAllHistory() async {
    _backupCalculations = calculations.toList();
    await _historyRepository.clearAllHistory();
    calculations.clear();
  }
  
  Future<void> undoClear() async {
    for (final calculation in _backupCalculations) {
      await _historyRepository.insertCalculation(calculation);
    }
    loadCalculations();
  }
  
  Future<void> searchCalculations(String query) async {
    if (query.isEmpty) {
      loadCalculations();
    } else {
      calculations.value = await _historyRepository.searchCalculations(query);
    }
  }
  
  void useCalculation(Calculation calculation) {
    Get.find<CalculatorController>().useCalculation(calculation);
    Get.back(); // Navigate back to calculator if coming from history
  }
}