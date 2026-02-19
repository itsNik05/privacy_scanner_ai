import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/document_repository.dart';
import 'package:open_filex/open_filex.dart';


class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              _header(),
              _tabs(),
              _storage(),
              Expanded(child: _body(context)),
            ],
          ),

          // Floating FAB like UI
          Positioned(
            right: 16,
            bottom: 20,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accent2]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 26),
            ),
          )
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Row(
        children: [
          Text("My Library", style: AppTextStyles.heading),
          const Spacer(),
          _iconButton(Icons.search),
          const SizedBox(width: 6),
          _iconButton(Icons.grid_view),
          const SizedBox(width: 6),
          _iconButton(Icons.more_vert),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: Icon(icon, size: 18, color: AppColors.text2),
    );
  }

  Widget _tabs() {
    final tabs = ["All Files", "PDFs", "Scans", "Starred ⭐", "Shared"];

    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tabs.length,
        itemBuilder: (_, i) {
          final active = i == 0;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: active ? AppColors.accent.withOpacity(0.15) : AppColors.bgSurface,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              tabs[i],
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: active ? AppColors.accent : AppColors.text2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _storage() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text("Storage used", style: AppTextStyles.subtitle),
              const Spacer(),
              Text("3.1 GB / 5 GB", style: AppTextStyles.subtitle.copyWith(color: AppColors.text1)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.62,
              minHeight: 6,
              backgroundColor: AppColors.bgRaised,
              valueColor: const AlwaysStoppedAnimation(AppColors.accent),
            ),
          )
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final repo = Provider.of<DocumentRepository>(context);

    if (repo.documents.isEmpty) {
      return Center(
        child: Text(
          "No documents yet.\nScan something first.",
          textAlign: TextAlign.center,
          style: AppTextStyles.subtitle,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      itemCount: repo.documents.length,
      itemBuilder: (context, index) {
        final doc = repo.documents[index];

        return GestureDetector(
          onTap: () {
            OpenFilex.open(doc.path);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.picture_as_pdf, color: AppColors.text2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.name, style: AppTextStyles.subtitle.copyWith(color: AppColors.text1)),
                      const SizedBox(height: 2),
                      Text("${doc.pages} pages · ${doc.sizeMB} MB", style: AppTextStyles.smallMuted),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.text3),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _docCard(String name, String date, {bool starred = false}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(Icons.picture_as_pdf, size: 32, color: AppColors.text2),
                  ),
                  if (starred)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(Icons.star, size: 16, color: AppColors.text2),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.subtitle.copyWith(color: AppColors.text1), maxLines: 1),
                const SizedBox(height: 2),
                Text(date, style: AppTextStyles.smallMuted),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _listTile(String name, String meta, String size) {
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
            width: 38,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.picture_as_pdf, color: AppColors.text2),
          ),
          const SizedBox(width: 12),
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
          Text(size, style: AppTextStyles.subtitle),
        ],
      ),
    );
  }
}
