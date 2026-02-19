import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanRepository {

  Future<String> createPdfFromImage({
    required File imageFile,
    required String fileName,
  }) async {

    // Request storage permission
    await Permission.storage.request();

    final pdf = pw.Document();

    final imageBytes = await imageFile.readAsBytes();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Center(
            child: pw.Image(image, fit: pw.BoxFit.contain),
          );
        },
      ),
    );

    final bytes = await pdf.save();

    // Get Documents directory
    final directory = await getExternalStorageDirectory();

    final folder = Directory("${directory!.path}/ScanVault");

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    final filePath = "${folder.path}/$fileName.pdf";

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return file.path;
  }
}
