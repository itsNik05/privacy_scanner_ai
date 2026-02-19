import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'navigation/main_navigation.dart';
import 'data/repositories/document_repository.dart';

class ScanVaultApp extends StatelessWidget {
  const ScanVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final repo = DocumentRepository();
            repo.loadDocs();
            return repo;
          },
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "ScanVault",
        theme: AppTheme.darkTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
