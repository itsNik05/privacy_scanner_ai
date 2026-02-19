import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
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

  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  List<File> capturedImages = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    _initializeControllerFuture = _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Capture Image
  Future<void> _captureImage() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller!.takePicture();

      setState(() {
        capturedImages.add(File(image.path));
      });

    } catch (e) {
      print(e);
    }
  }

  // Save Multi Page PDF
  Future<void> _savePdf() async {
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

            _header(),

            Expanded(
              child: Stack(
                children: [

                  // Camera Preview
                  FutureBuilder(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.done) {
                        return CameraPreview(_controller!);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),

                  // Bottom Controls
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20),
                      color: Colors.black.withOpacity(0.5),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          // Capture Button
                          GestureDetector(
                            onTap: _captureImage,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration:
                              const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.accent,
                                    AppColors.accent2,
                                  ],
                                ),
                                shape:
                                BoxShape.circle,
                              ),
                              child: const Icon(
                                  Icons.camera_alt,
                                  size: 28,
                                  color: Colors.white),
                            ),
                          ),

                          const SizedBox(width: 20),

                          if (capturedImages.isNotEmpty)
                            ElevatedButton(
                              onPressed: _savePdf,
                              child: Text(
                                  "Export (${capturedImages.length})"),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
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
                borderRadius:
                BorderRadius.circular(20),
                border:
                Border.all(color: AppColors.border),
              ),
              child: const Icon(
                  Icons.arrow_back_ios_new,
                  size: 16),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Document Scanner",
              style: AppTextStyles.title,
            ),
          ),
        ],
      ),
    );
  }
}
