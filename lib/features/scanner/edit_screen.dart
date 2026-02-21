import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class EditScreen extends StatelessWidget {
  final File imageFile;

  const EditScreen({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [

            // Top Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Spacer(),
                  const Text(
                    "Edit Document",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Image Preview
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  // Retake
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // return null
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: const Text(
                      "Retake",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // Continue
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, imageFile); // return image
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    ),
                    child: const Text("Continue"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
