import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../scanner/scanner_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _statsRow(),
                  const SizedBox(height: 14),
                  _quickScan(context),
                  const SizedBox(height: 18),
                  _toolsGrid(),
                  const SizedBox(height: 18),
                  _recentDocs(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accent2]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                "A",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Good morning,", style: AppTextStyles.smallMuted),
              Text("Alex Johnson", style: AppTextStyles.title),
            ],
          ),
          const Spacer(),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.bgRaised,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.notifications, size: 18, color: AppColors.text2),
          )
        ],
      ),
    );
  }

  Widget _statsRow() {
    return Row(
      children: [
        _statCard("Scanned", "128", AppColors.accent),
        const SizedBox(width: 8),
        _statCard("PDFs", "47", AppColors.accent2),
        const SizedBox(width: 8),
        _statCard("Saved MB", "2.4", AppColors.accent3),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.bgSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.smallMuted),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.statValue.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickScan(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ScannerScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accent2]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tap to start", style: AppTextStyles.smallMuted.copyWith(color: Colors.white70)),
                Text("Quick Scan", style: AppTextStyles.title.copyWith(color: Colors.white)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.white54),
          ],
        ),
      ),
    );
  }

  Widget _toolsGrid() {
    final tools = [
      ("Compress", Icons.compress),
      ("Split", Icons.content_cut),
      ("Merge", Icons.merge),
      ("Encrypt", Icons.lock),
      ("Convert", Icons.sync),
      ("Sign", Icons.edit),
    ];

    return Column(
      children: [
        Row(
          children: [
            Text("PDF Tools", style: AppTextStyles.title),
            const Spacer(),
            Text("See all", style: AppTextStyles.subtitle.copyWith(color: AppColors.accent)),
          ],
        ),
        const SizedBox(height: 10),
        GridView.builder(
          itemCount: tools.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (_, i) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.bgSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(tools[i].$2, color: AppColors.text2),
                  const SizedBox(height: 6),
                  Text(tools[i].$1, style: AppTextStyles.subtitle.copyWith(fontSize: 10)),
                ],
              ),
            );
          },
        )
      ],
    );
  }

  Widget _recentDocs() {
    return Column(
      children: [
        Row(
          children: [
            Text("Recent Docs", style: AppTextStyles.title),
            const Spacer(),
            Text("View all", style: AppTextStyles.subtitle.copyWith(color: AppColors.accent)),
          ],
        ),
        const SizedBox(height: 10),
        _recentTile("Contract_2024.pdf", "2.4 MB · 12 pages · Today", AppColors.danger),
        const SizedBox(height: 8),
        _recentTile("Invoice_March.pdf", "840 KB · 3 pages · Yesterday", AppColors.accent),
        const SizedBox(height: 8),
        _recentTile("Meeting_Notes.pdf", "1.1 MB · 6 pages · Mon", AppColors.accent3),
      ],
    );
  }

  Widget _recentTile(String name, String meta, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.picture_as_pdf, size: 18, color: AppColors.text1),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.subtitle.copyWith(color: AppColors.text1)),
                const SizedBox(height: 2),
                Text(meta, style: AppTextStyles.smallMuted),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.text3),
        ],
      ),
    );
  }
}
