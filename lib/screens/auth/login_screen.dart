import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/functions/validators.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _parentEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _serverError;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final translucientFieldColor = theme.primaryFieldColor.withOpacity(0.4);


    return Scaffold(
      floatingActionButton: const GoToWidget(
        routeName: '/select_profile',
        text: 'Go Back to Demo Mode',
      ),
      body: Stack(
        children: [
          BackgroundWidget(backgroundImageUrl: theme.backgroundImageUrl,),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kiddiegram',
                    style: GoogleFonts.grandHotel(
                      fontSize: 54,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: _parentEmailController,
                                style: GoogleFonts.baloo2(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  label: const ReusableTextWidget(
                                    text: "parent's email",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  errorText: _emailError,
                                  filled: true,
                                  fillColor: translucientFieldColor,
                                ),
                                validator: (value) => validateEmail(value),
                                onSaved: (value) => _parentEmailController.text = value!,
                              ),
                              const SizedBox(height: 12,),
                              TextFormField(
                                controller: _passwordController,
                                style: GoogleFonts.baloo2(
                                  fontSize: 14,
                                  //color: AppColors.light_theme_red,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  label: const ReusableTextWidget(
                                    text: "password",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  errorText: _passwordError,
                                  filled: true,
                                  fillColor: translucientFieldColor,
                                ),
                                obscureText: true,
                                validator: (value) => validatePassword(value),
                                onSaved: (value) => _passwordController.text = value!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40,),
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            alignment: Alignment.center,
                            height: 44,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.primaryButtonColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const ReusableTextWidget(
                              text: "Login",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60,),
                        GestureDetector(
                          onTap: () async => await Navigator.pushNamed(context, '/forgot_password'),
                          child: const ReusableTextWidget(
                            text: "Click me if you have forgotten your password?",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () async => await Navigator.pushNamed(context, '/register'),
                          child: const ReusableTextWidget(
                            text: "CLICK ME IF YOU DO NOT HAVE A \nKIDDIEGRAM ACCOUNT",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                  ),
                ]
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _login() async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      final email = _parentEmailController.text;
      final password = _passwordController.text;

      try{
        final AuthService authService = context.read<AuthService>();
        // ignore: unused_local_variable
        final user = await authService.createEmailPasswordSession(email: email, password: password);

        Navigator.pushNamed(context, '/homepage');
      } on AppwriteException catch(e){
        setState(() {
          _serverError = e.message;
        });
        print(_serverError);
      }
    }
  }
}

