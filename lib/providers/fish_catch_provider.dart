import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/fish_catch.dart'; // Importer FishCatch depuis models/fish_catch.dart

class FishCatchProvider with ChangeNotifier {
  List<FishCatch> _fishCatches = [];

  List<FishCatch> get fishCatches => _fishCatches;

  FishCatchProvider() {
    _loadFishCatches();
  }

  Future<void> addFishCatch(FishCatch fishCatch) async {
    _fishCatches.add(fishCatch);
    notifyListeners();
    await _saveFishCatches();
  }

  Future<void> _saveFishCatches() async {
    final prefs = await SharedPreferences.getInstance();
    final String fishCatchesJson = jsonEncode(_fishCatches.map((fc) => fc.toJson()).toList());
    prefs.setString('fishCatches', fishCatchesJson);
  }

  Future<void> _loadFishCatches() async {
    final prefs = await SharedPreferences.getInstance();
    final String? fishCatchesJson = prefs.getString('fishCatches');
    if (fishCatchesJson != null) {
      final List<dynamic> fishCatchesList = jsonDecode(fishCatchesJson);
      _fishCatches = fishCatchesList.map((json) => FishCatch.fromJson(json)).toList();
      notifyListeners();
    }
  }

  void removeFishCatch(FishCatch fishCatch) {
    _fishCatches.remove(fishCatch);
    _saveFishCatches();
    notifyListeners();
  }
}
