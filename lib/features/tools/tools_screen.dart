import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          _header(),
          _searchBar(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _section("Optimize"),
                _toolTile("Compress PDF", "Reduce file size up to 80%", Icons.compress, badge: "NEW"),
                _toolTile("Convert PDF", "PDF ↔ Word, Excel, JPG…", Icons.sync),

                const SizedBox(height: 16),
                _section("Organize"),
                _toolTile("Split PDF", "Extract or split pages", Icons.content_cut),
                _toolTile("Merge PDF", "Combine multiple files", Icons.merge),
                _toolTile("Reorder Pages", "Drag to rearrange pages", Icons.swap_vert),

                const SizedBox(height: 16),
                _section("Security"),
                _toolTile("Encrypt PDF", "Password-protect your docs", Icons.lock, badge: "PRO"),
                _toolTile("Sign PDF", "Draw or insert signature", Icons.edit, badge: "PRO"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("PDF Tools", style: AppTextStyles.heading),
          const SizedBox(height: 2),
          Text("10 tools available", style: AppTextStyles.smallMuted),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgRaised,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 18, color: AppColors.text3),
          const SizedBox(width: 10),
          Text("Search tools…", style: AppTextStyles.smallMuted),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.smallMuted.copyWith(
          letterSpacing: 1,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _toolTile(String name, String desc, IconData icon, {String? badge}) {
    return Container(
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
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.text2),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.subtitle.copyWith(color: AppColors.text1)),
                const SizedBox(height: 2),
                Text(desc, style: AppTextStyles.smallMuted),
              ],
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: badge == "PRO"
                    ? AppColors.warn.withOpacity(0.15)
                    : AppColors.accent3.withOpacity(0.15),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: badge == "PRO" ? AppColors.warn : AppColors.accent3,
                ),
              ),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.text3),
        ],
      ),
    );
  }
}
