import 'package:appwrite/appwrite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/functions/exceptions.dart';
import 'package:kiddiegram/functions/validators.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _childUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _hasAgreedToTerms = false;
  bool _isAbove18 = false;
  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _serverError;
  

  @override
  Widget build(BuildContext context) {

    final theme = Provider.of<ThemeProvider>(context).currentTheme;
    final translucientFieldColor = theme.primaryFieldColor.withOpacity(0.4);

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget( backgroundImageUrl: theme.backgroundImageUrl,),
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
                                controller: _childUsernameController,
                                style: GoogleFonts.baloo2(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  label: const ReusableTextWidget(
                                    text: "child's username",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  errorText: _usernameError,
                                  filled: true,
                                  fillColor: translucientFieldColor,
                                ),
                                validator: (value) => validateUsername(value),
                                onSaved: (value) => _childUsernameController.text = value!,
                              ),
                              const SizedBox(height: 12,),
                              TextFormField(
                                controller: _passwordController,
                                style: GoogleFonts.baloo2(
                                  fontSize: 14,
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
                              const SizedBox(height: 12,),
                              TextFormField(
                                controller: _confirmPasswordController,
                                style: GoogleFonts.baloo2(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  label: const ReusableTextWidget(
                                    text: "confirm password",
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  errorText: _confirmPasswordError,
                                  filled: true,
                                  fillColor: translucientFieldColor,
                                ),
                                obscureText: true,
                                validator: (value) => validateConfirmPassword(value, _passwordController.text),
                                onSaved: (value) => _confirmPasswordController.text = value!,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12,),
                        _getErrorText(),
                        const SizedBox(height: 28,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.primaryTextColor, width: 4.0),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Checkbox(
                                side: WidgetStateBorderSide.resolveWith((_) => BorderSide.none),
                                value: _hasAgreedToTerms,
                                onChanged: (value) {
                                  setState(() {
                                    _hasAgreedToTerms = value!;
                                  });
                                },
                                checkColor: theme.primaryTextColor,
                                activeColor: theme.backgroundColor1,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.baloo2(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: theme.primaryTextColor
                                  ),
                                  children: [
                                    const TextSpan(text: 'I agree to the '),
                                    TextSpan(
                                      text: 'Terms and Conditions',
                                      style: const TextStyle(decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {},
                                    ),
                                  ]
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                border: Border.all(color: theme.primaryTextColor, width: 4.0),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Checkbox(
                                side: WidgetStateBorderSide.resolveWith((_) => BorderSide.none),
                                value: _isAbove18,
                                onChanged: (value) {
                                  setState(() {
                                    _isAbove18 = value!;
                                  });
                                },
                                checkColor: theme.primaryTextColor,
                                activeColor: theme.backgroundColor1,
                              ),
                            ),
                            const SizedBox(width: 10,),
                            const ReusableTextWidget(
                              text: 'I as the parent am above 18 years of age', 
                              fontSize: 14, 
                              fontWeight: FontWeight.bold, 
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        GestureDetector(
                          onTap: _hasAgreedToTerms && _isAbove18 ? _signup : null,
                          child: Container(
                            alignment: Alignment.center,
                            height: 44,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _hasAgreedToTerms && _isAbove18 ? theme.primaryButtonColor : theme.backgroundBlendColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const ReusableTextWidget(
                              text: "Register",
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 60,),
                        GestureDetector(
                          onTap: () async => await Navigator.pushNamed(context, '/login') ,
                          child: const ReusableTextWidget(
                            text: "CLICK ME IF YOU ALREADY HAVE A \nKIDDIEGRAM ACCOUNT",
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
      floatingActionButton: const GoToWidget(
        routeName: '/select_profile',
        text: 'Go Back to Demo Mode',
      )
    );
  }

  Widget _getErrorText(){
    if(_serverError != null){
      return ReusableTextWidget(
        text: _serverError!, 
        fontSize: 14, 
        fontWeight: FontWeight.normal, 
      );
    } else{
      return Container();
    }
  }

  Future<void> _signup() async{
    // print(_passwordController.text);
    // print(_confirmPasswordController.text);
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      final email = _parentEmailController.text;
      final username = _childUsernameController.text;
      final password = _passwordController.text;
      
      try{
        final AuthService authService = context.read<AuthService>(); 
        await authService.createUser(
          email: email,
          username: username,
          password: password,
        );

        await Navigator.pushNamed(context, '/select_profile');


      } on AppwriteException catch(e){
        if(e.code == 409){
          setState(() {
            _serverError = 'User with email already exist';
          });
        } else{
          setState(() {
            _serverError = 'An error occurred: ${e.message}';
          });
        }
      } on UsernameAlreadyExistsException catch(e){
        setState(() {
          _serverError = e.message;
        });
      } catch(e){
        setState(() {
          _serverError = 'An error occurred: ${e.toString()}';
        });
      }
    } 
  }
}

