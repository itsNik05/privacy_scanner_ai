import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../data/repositories/scan_repository.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/models/document_model.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {

  List<File> capturedImages = [];

  // Capture image and store in list
  Future<void> _captureImage() async {
    final picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    setState(() {
      capturedImages.add(File(image.path));
    });
  }

  // Save multi-page PDF
  Future<void> _savePdf(BuildContext context) async {
    if (capturedImages.isEmpty) return;

    final scanRepo = ScanRepository();
    final fileName =
        "Scan_${DateTime.now().millisecondsSinceEpoch}";

    final savedPath = await scanRepo.createMultiPagePdf(
      images: capturedImages,
      fileName: fileName,
    );

    final savedFile = File(savedPath);
    final sizeMB =
        (await savedFile.length()) / (1024 * 1024);

    final doc = DocumentModel(
      name: "$fileName.pdf",
      path: savedPath,
      pages: capturedImages.length,
      sizeMB:
      double.parse(sizeMB.toStringAsFixed(2)),
      createdAt: DateTime.now(),
    );

    await Provider.of<DocumentRepository>(
      context,
      listen: false,
    ).addDocument(doc);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: SafeArea(
        child: Column(
          children: [

            _header(context),

            // Camera preview takes remaining space
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _viewFinder(),
                    _modes(),

                    if (capturedImages.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: capturedImages.length,
                          itemBuilder: (_, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 70,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: FileImage(capturedImages[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        capturedImages.removeAt(index);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close,
                                          size: 12, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 10),

                    _controls(context),

                    _tips(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.bgRaised,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Document Scanner",
              style: AppTextStyles.title,
            ),
          ),
          if (capturedImages.isNotEmpty)
            ElevatedButton(
              onPressed: () => _savePdf(context),
              child: Text("Export (${capturedImages.length})"),
            ),
        ],
      ),
    );
  }


  Widget _viewFinder() {
    return Container(
      height: 260,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 24,
            right: 24,
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: AppColors.accent.withOpacity(0.5)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color:
                AppColors.accent3.withOpacity(0.15),
                borderRadius:
                BorderRadius.circular(50),
                border: Border.all(
                    color:
                    AppColors.accent3.withOpacity(
                        0.3)),
              ),
              child: const Text(
                "✓ Document Detected",
                style: TextStyle(
                    fontSize: 10,
                    color: AppColors.accent3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modes() {
    final modes = [
      "Auto",
      "Manual",
      "Whiteboard",
      "Business Card",
      "Book"
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.only(top: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding:
        const EdgeInsets.symmetric(horizontal: 16),
        itemCount: modes.length,
        itemBuilder: (_, i) {
          final active = i == 0;
          return Container(
            margin:
            const EdgeInsets.only(right: 8),
            padding:
            const EdgeInsets.symmetric(
                horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: active
                  ? AppColors.accent
                  : AppColors.bgSurface,
              borderRadius:
              BorderRadius.circular(50),
              border: Border.all(
                  color: AppColors.border),
            ),
            child: Text(
              modes[i],
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                FontWeight.w500,
                color: active
                    ? Colors.white
                    : AppColors.text2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _controls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Capture Button
          GestureDetector(
            onTap: _captureImage,
            child: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent,
                    AppColors.accent2,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 28,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }


  Widget _tips() {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: _tipCard(
                  Icons.lightbulb,
                  "Good lighting improves accuracy")),
          const SizedBox(width: 8),
          Expanded(
              child: _tipCard(
                  Icons.square_foot,
                  "Align within the guide frame")),
        ],
      ),
    );
  }

  Widget _tipCard(
      IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius:
        BorderRadius.circular(12),
        border:
        Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: AppColors.text2),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles
                  .subtitle
                  .copyWith(fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
