class DocumentModel {
  final String name;
  final String path;
  final int pages;
  final double sizeMB;
  final DateTime createdAt;

  DocumentModel({
    required this.name,
    required this.path,
    required this.pages,
    required this.sizeMB,
    required this.createdAt,
  });
}
