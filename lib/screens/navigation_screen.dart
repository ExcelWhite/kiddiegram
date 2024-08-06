import 'package:flutter/material.dart';
import 'package:kiddiegram/screens/navigated_screens/account_screen.dart';
import 'package:kiddiegram/screens/navigated_screens/home_screen.dart';
import 'package:kiddiegram/screens/navigated_screens/new_post_screen.dart';
import 'package:kiddiegram/screens/navigated_screens/notifications_screen.dart';
import 'package:kiddiegram/screens/navigated_screens/search_screen.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {

  int _currentIndex = 0;
  String _avatarUrl = '';

  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    NewPostScreen(),
    NotificationsScreen(),
    AccountScreen(),
  ];

  void initState(){
    super.initState();
    _getAvatarUrl();
  }

  void _onItemTapped(int index){
    if(index == 2){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: ReusableTextWidget(
            text: 'This feature is inaccessible in demo mode for now!',
            fontSize: 16,
            fontWeight: FontWeight.bold,)),
      );
    } else{
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<void> _getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: _onItemTapped, 
      items: [
        const  BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
        const BottomNavigationBarItem(icon: Icon(Icons.search), activeIcon: Icon(Icons.search_outlined), label: 'Search'),
        const BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline_rounded), activeIcon: Icon(Icons.add_circle_rounded), label: 'Add'),
        const BottomNavigationBarItem(icon: Icon(Icons.notifications_active_outlined), activeIcon: Icon(Icons.notifications_active_rounded), label: 'Settings'),
        BottomNavigationBarItem(
          icon: _avatarUrl.isNotEmpty
          ? CircleAvatar(
            radius: 15,
            backgroundImage: NetworkImage(_avatarUrl),
          )
          : const Icon(Icons.person_outline),

          label: 'Account'

        ),
        
      ]),
    );
  }
}