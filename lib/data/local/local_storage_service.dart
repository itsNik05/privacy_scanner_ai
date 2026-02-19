import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _docsKey = "saved_documents";

  Future<void> saveDocuments(List<Map<String, dynamic>> docs) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_docsKey, jsonEncode(docs));
  }

  Future<List<Map<String, dynamic>>> loadDocuments() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_docsKey);

    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }
}
