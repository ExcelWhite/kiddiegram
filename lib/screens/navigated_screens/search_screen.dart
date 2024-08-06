// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/appwrite/database_service.dart';
import 'package:kiddiegram/models/feed_model.dart';
import 'package:kiddiegram/models/user_profile_model.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late DatabaseService userDatabase;
  late DatabaseService feedDatabase;
  List<UserProfile> profiles = [];
  List<Feed> feeds = [];
  List<UserProfile> searchHistory = [];

  bool hasSearched = false;

  Future<void> searchProfiles(String searchQuery) async {
    if (searchQuery.isEmpty) {
      setState(() {
        profiles = [];
        hasSearched = true;
      });
      return;
    }

    try {
      final response = await userDatabase.searchProfiles(searchQuery: searchQuery);
      if (mounted) {
        setState(() {
          profiles = response;
          hasSearched = true;
        });
      }
    } catch (e) {
      print('Error searching profiles: $e');
    }
  }



  @override
  void initState() {
    super.initState();
    userDatabase = DatabaseService();
    _searchFocusNode.addListener(() {
      setState(() {
        
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeProvider>(context).currentTheme;

    void _showAccountInfoWidget(BuildContext context, UserProfile user) {
      if(!searchHistory.contains(user)){
        setState(() {
          searchHistory.add(user);
        });
      }
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: BoxDecoration(
              color: theme.primaryFieldColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableTextWidget(
                        text: user.username, 
                        fontSize: 24, 
                        fontWeight: FontWeight.bold
                      ),
                      Container(
                        // width: 70,
                        // height: 40,
                        child: ReusableTextWidget(
                          text: "DEMO \nACCOUNT", 
                          fontSize: 16, 
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
              
                ],
              ),
            ),
          );
        },
      );
    }

    Widget _buildSearchResults() {
      if (profiles.isEmpty && hasSearched) {
        return const Center(
          child: ReusableTextWidget(text: 'No results found', fontSize: 24, fontWeight: FontWeight.bold,),
        );
    } else if (hasSearched) {
        return ListView.builder(
          itemCount: profiles.length,
          itemBuilder: (context, index) {
            return ListTile(
              textColor: theme.primaryTextColor,
              title: GestureDetector(
                onTap: () => _showAccountInfoWidget(context, profiles[index]),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profiles[index].avatarUrl),
                    ),
                    const SizedBox(width: 10),
                    ReusableTextWidget(text: profiles[index].username, fontSize: 16, fontWeight: FontWeight.bold,),
                  ],
                ),
              ),
            );
          }
        );
    } else {
      return Container();
    }
    }

    Widget _buildSearchHistory() {
      if (searchHistory.isEmpty) {
        return Container();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: ReusableTextWidget(text: 'Recents', fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: searchHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    textColor: theme.primaryTextColor,
                    title: GestureDetector(
                      onTap: () => _showAccountInfoWidget(context, searchHistory[index]),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(searchHistory[index].avatarUrl),
                          ),
                          const SizedBox(width: 10),
                          ReusableTextWidget(text: searchHistory[index].username, fontSize: 16, fontWeight: FontWeight.bold,),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Container(
          //padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            style: GoogleFonts.baloo2(fontSize: 14, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search,),
              hintText: 'Search',
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              filled: true,
              fillColor: theme.primaryFieldColor.withOpacity(0.7),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(5),
              )
            ),
            onChanged: (query) {
              searchProfiles(query);
            },
          ),
        ),
      actions: _searchFocusNode.hasFocus
        ? [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: () {
                _searchController.clear();
                _searchFocusNode.unfocus();
                setState(() {
                  hasSearched = false;
                  profiles = [];
                });
              },
              child: const ReusableTextWidget(text: 'Cancel', fontSize: 16, fontWeight: FontWeight.normal,),
            ),
          )
      ] : null,
      ),
      body: Stack(
        children: [
          BackgroundWidget(backgroundImageUrl: theme.backgroundImageUrl),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: _searchFocusNode.hasFocus && _searchController.text.isNotEmpty 
              ? _buildSearchResults()
              : _buildSearchHistory()
          )
        ]
      ),
    );
  }
}