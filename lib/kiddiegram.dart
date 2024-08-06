import 'package:flutter/material.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/screens/auth/forgot_password_screen.dart';
import 'package:kiddiegram/screens/auth/login_screen.dart';
import 'package:kiddiegram/screens/auth/register_screen.dart';
import 'package:kiddiegram/screens/auth/reset_password_screen.dart';
import 'package:kiddiegram/screens/navigated_screens/home_screen.dart';
import 'package:kiddiegram/screens/navigation_screen.dart';
import 'package:kiddiegram/screens/posts_screen.dart';
import 'package:kiddiegram/screens/select_profile.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:provider/provider.dart';

class Kiddiegram extends StatelessWidget {
  const Kiddiegram({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Kiddiegram',
          theme: themeProvider.currentTheme.getTheme(),
          home: Builder(
            builder: (context) {
              if (authService.status == AuthStatus.uninitialized) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return authService.status == AuthStatus.authenticated
                  ? const NavigationScreen()
                  : const SelectProfile();
            },
          ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/forgot_password': (context) => const ForgotPasswordScreen(),
            '/reset_password': (context) => const ResetPasswordScreen(),
            '/home': (context) => const HomeScreen(),
            '/select_profile': (context) => const SelectProfile(),
            '/navigation': (context) => const NavigationScreen(),
            '/posts': (context) => const PostsScreen(),
          },
        );
      },
    );
  }
}
