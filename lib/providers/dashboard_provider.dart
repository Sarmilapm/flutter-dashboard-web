import 'package:flutter/material.dart';
import '../models/dashboard_data.dart';
import '../services/csv_parser.dart';

class DashboardProvider extends ChangeNotifier {
  List<DashboardData> _allData = [];
  List<DashboardData> _filteredData = [];

  String? _selectedSite;
  String? _selectedIndividual;
  DateTime? _selectedDate;

  bool _isLoading = true;

  List<DashboardData> get filteredData => _filteredData;
  List<DashboardData> get allData => _allData;
  bool get isLoading => _isLoading;
  String? get selectedSite => _selectedSite;
  String? get selectedIndividual => _selectedIndividual;
  DateTime? get selectedDate => _selectedDate;

  DashboardProvider() {
    loadCSVData();
  }

  Future<void> loadCSVData() async {
    _isLoading = true;
    notifyListeners();

    final data = await CSVParser.loadDashboardData();
    _allData = data;
    _filteredData = data;
    _isLoading = false;
    notifyListeners();
  }

  void applyFilters() {
    _filteredData = _allData.where((d) {
      final matchSite = _selectedSite == null || d.site == _selectedSite;
      final matchInd = _selectedIndividual == null || d.individual == _selectedIndividual;
      final matchDate = _selectedDate == null ||
          (d.date.year == _selectedDate!.year &&
              d.date.month == _selectedDate!.month &&
              d.date.day == _selectedDate!.day);
      return matchSite && matchInd && matchDate;
    }).toList();
    notifyListeners();
  }

  void setSite(String? site) {
    _selectedSite = site;
    _selectedIndividual = null;
    applyFilters();
  }

  void setIndividual(String? individual) {
    _selectedIndividual = individual;
    applyFilters();
  }

  void setDate(DateTime? date) {
    _selectedDate = date;
    applyFilters();
  }

  void clearFilters() {
    _selectedSite = null;
    _selectedIndividual = null;
    _selectedDate = null;
    _filteredData = _allData;
    notifyListeners();
  }
}
