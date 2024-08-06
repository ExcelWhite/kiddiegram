import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiddiegram/constants.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final translucientFieldColor = theme.primaryFieldColor.withOpacity(0.4);

    return Scaffold(
      floatingActionButton: GoToWidget(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                style: GoogleFonts.baloo2(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  label: const ReusableTextWidget(
                                    text: "username",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  filled: true,
                                  fillColor: translucientFieldColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40,),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Forgot password feature disabled in demo mode'),
                                backgroundColor: AppColors.error_red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          
                          child: Container(
                            alignment: Alignment.center,
                            height: 44,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.primaryButtonColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const ReusableTextWidget(
                              text: "Reset Password",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60,),
                        GestureDetector(
                          onTap: () async => Navigator.pushNamed(context, '/register'),
                          child: ReusableTextWidget(
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
  
}