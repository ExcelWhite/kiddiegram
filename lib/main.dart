import 'package:flutter/material.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/kiddiegram.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const Kiddiegram(),
    ),
  );
}
