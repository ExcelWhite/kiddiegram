import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/feed_widget.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeProvider>(context).currentTheme;
    final AuthService authService = context.read<AuthService>();
    // final currentUser = authService.currentUser;


    Future<void> _signout() async{
      try{
        await authService.signOut();
        Navigator.pushNamed(context, '/select_profile');
      } on AppwriteException catch(e){
        print(e.message);
      }
      
    }
    BoxDecoration backgroundDecoration (){
      return BoxDecoration(
        image: DecorationImage(
          image: AssetImage(theme.backgroundImageUrl),
          fit: BoxFit.cover,
        ),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: GoToWidget(
        routeName: '/register',
        text: 'View Authentication pages',
      ),
      body: CustomScrollView(
        slivers: [
          //serves as app bar
          SliverAppBar(
            toolbarHeight: 60,
            automaticallyImplyLeading: false,
            elevation: 0,
            pinned: false,
            floating: true,
            flexibleSpace: Container(
              decoration: backgroundDecoration(),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ImageIcon(
                  AssetImage('assets/icons/light_theme_icon.png'),
                  size: 30,
                ),
                const Spacer(),
                Center(
                  child: Text(
                    'Kiddiegram',
                    style: GoogleFonts.grandHotel(fontSize: 32),
                  ),
                ),
                const Spacer(),
                Transform.flip(
                  flipX: true,
                  child: IconButton(
                    icon: Icon(Icons.chat_bubble),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Can't access inbox in demo mode"),
                        duration: Duration(seconds: 3),
                      )
                    );
                    },
                    )
                ),
                
              ],
            ),
          ),

          //body
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeedWidget(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}