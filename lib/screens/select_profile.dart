import 'dart:math';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/appwrite/database_service.dart';
import 'package:kiddiegram/constants.dart';
import 'package:kiddiegram/models/user_profile_model.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectProfile extends StatefulWidget {
  const SelectProfile({super.key});

  @override
  State<SelectProfile> createState() => _SelectProfileState();
}

class _SelectProfileState extends State<SelectProfile> {
  late DatabaseService databaseService;
  List<UserProfile> profiles = [];
  bool isLoading = true;

  late List<int> randomIndex;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomIndex = pickIndex();
    databaseService = DatabaseService();
    fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {

    final _authService = context.read<AuthService>();

    // Future<void> _signout() async {
    //   try {
    //     await _authService.signOut();
    //     Navigator.pushNamed(context, '/select_profile');
    //   } on AppwriteException catch (e) {
    //     print(e.message);
    //   }
    // }

    var theme = Provider.of<ThemeProvider>(context).currentTheme;
    var translucientFieldColor = theme.primaryFieldColor.withOpacity(0.4);

    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: GoToWidget(
        routeName: '/register',
        text: 'View Authentication pages',
      ),

      appBar: AppBar(
        title: Center(
          child: Text(
            'Kiddigram',
            style: GoogleFonts.grandHotel(
              fontSize: 40,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),

      body: Stack(
        children: [
          BackgroundWidget(backgroundImageUrl: theme.backgroundImageUrl,),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.primaryTextColor, width: 4.0),
                        borderRadius: BorderRadius.circular(10),
                        color: translucientFieldColor,
                      ),
                      child: const ReusableTextWidget(
                        text: 'DISCLAIMER: All profiles used here are AI generated and none is real',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const ReusableTextWidget(
                    text: 'Choose a Demo profile \nto login in with', 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _login(profiles[randomIndex[0]]);
                              },
                            child: ProfileDisplay(
                              isLoading: isLoading, 
                              profiles: profiles,
                              index: randomIndex[0]
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _login(profiles[randomIndex[1]]);
                              },
                            child: ProfileDisplay(
                              isLoading: isLoading, 
                              profiles: profiles,
                              index: randomIndex[1]
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _login(
                                profiles[randomIndex[2]]);
                              },
                            child: ProfileDisplay(
                              isLoading: isLoading, 
                              profiles: profiles,
                              index: randomIndex[2]
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _login(
                                profiles[randomIndex[3]]);
                              },
                            child: ProfileDisplay(
                              isLoading: isLoading, 
                              profiles: profiles,
                              index: randomIndex[3]
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const ReusableTextWidget(
                    text: 'Choose a theme', 
                    fontSize: 24, 
                    fontWeight: FontWeight.bold
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Provider.of<ThemeProvider>(context, listen: false).changeTheme(0);
                        },
                        child: const DisplayThemeWidget(
                          color: AppColors.light_theme_milk,
                          url: 'assets/images/light_theme_bg.png',
                          text: 'Light',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<ThemeProvider>(context, listen: false).changeTheme(1);
                        },
                        child: const DisplayThemeWidget(
                          color: AppColors.dark_theme_purple,
                          url: 'assets/images/dark_theme_bg.png',
                          text: 'Dark',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<ThemeProvider>(context, listen: false).changeTheme(2);
                        },
                        child: const DisplayThemeWidget(
                          color: AppColors.orange_season_theme_orange,
                          url: 'assets/images/mango_season_bg.png',
                          text: 'Orange Season',
                        ),
                      ),
                    ]
                  ),
                ],
              ),
            )
          )
        ]
      ),
    );
  }

  Future<void> fetchProfiles() async {
    try{
      final fetchedProfiles = await databaseService.fetchProfiles();
      setState(() {
        profiles = fetchedProfiles;
        isLoading = false;
      });
    } catch(e){
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _login(UserProfile profile) async{
    try{
      final AuthService authService = context.read<AuthService>();
      //await authService.signOut();
      final password = getPassword(profile.username);
      // ignore: unused_local_variable
      final user = await authService.createEmailPasswordSession(email: profile.email, password: password);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString('username', profile.username);
      prefs.setString('email', profile.email);
      prefs.setString('avatarUrl', profile.avatarUrl);

      await Navigator.pushNamed(context, '/navigation');
    } on AppwriteException catch(e){
      if (kDebugMode) {
        print('app write execption caught');
        print(e);
      }
    }
  }

  List<int> pickIndex(){
    Random random = Random();
    List<int> numbers = List.generate(10, (index) => index);
    List<int> pickedNumbers = [];

    for(int i=0; i<4; i++){
      int index = random.nextInt(numbers.length);
      pickedNumbers.add(numbers[index]);
      numbers.removeAt(index);
    }

    return pickedNumbers;

  }

   String getPassword(String username) {
    int startIndex = username.indexOf('the');
    if (startIndex != -1) {
      String password = username.substring(startIndex);
      if (password.length < 8) {
        password += '0' * (8 - password.length);
      }
      return password;
    } else {
      return 'Invalid username';
    }
  }
}

