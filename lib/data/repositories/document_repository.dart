import 'package:flutter/material.dart';
import '../local/local_storage_service.dart';
import '../models/document_model.dart';

class DocumentRepository extends ChangeNotifier {
  final LocalStorageService _storage = LocalStorageService();

  List<DocumentModel> documents = [];

  Future<void> loadDocs() async {
    final rawDocs = await _storage.loadDocuments();

    documents = rawDocs.map((d) {
      return DocumentModel(
        name: d["name"],
        path: d["path"],
        pages: d["pages"],
        sizeMB: d["sizeMB"],
        createdAt: DateTime.parse(d["createdAt"]),
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addDocument(DocumentModel doc) async {
    documents.insert(0, doc);

    final jsonDocs = documents.map((d) {
      return {
        "name": d.name,
        "path": d.path,
        "pages": d.pages,
        "sizeMB": d.sizeMB,
        "createdAt": d.createdAt.toIso8601String(),
      };
    }).toList();

    await _storage.saveDocuments(jsonDocs);

    notifyListeners();
  }
}
