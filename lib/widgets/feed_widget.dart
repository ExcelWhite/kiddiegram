import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/appwrite/database_service.dart';
import 'package:kiddiegram/appwrite/feed_service.dart';
import 'package:kiddiegram/appwrite/user_service.dart';
import 'package:kiddiegram/constants.dart';
import 'package:kiddiegram/models/feed_model.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:kiddiegram/widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FeedLikeState {
  int likes;
  bool isLiked;

  FeedLikeState({required this.likes, this.isLiked = false});
}


class FeedWidget extends StatefulWidget {
  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final PageController _pageController = PageController();

  late DatabaseService _databaseService;
  late UserService _userService;
  late FeedService _feedService;
  late Future<List<Feed>> _feedsFuture;

  String _currentUsername = '';

  late List<FeedLikeState> _feedLikeStates;


  @override
  void initState() {
    super.initState();
    _getUsername();
    _feedLikeStates =[];
    _databaseService = DatabaseService();
    _userService = UserService(_databaseService.database);
    _feedService = FeedService(_databaseService, _userService);
    _feedsFuture = _fetchAndShuffleFeeds();
  }

  Future<List<Feed>> _fetchAndShuffleFeeds() async {
    List<Feed> feeds = await _feedService.fetchFeeds();
    feeds.shuffle();
    return feeds;
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('username') ?? '';
    });
  }


  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context).currentTheme;

    void _showAccountInfoWidget(BuildContext context, Feed feed) {
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
                    backgroundImage: NetworkImage(feed.avatarUrl),
                  ),
                  
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ReusableTextWidget(
                        text: feed.username, 
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

    void _showMoreOnFeedWidget(BuildContext context, Feed feed) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.15,
            decoration: BoxDecoration(
              color: theme.primaryFieldColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.person, color: theme.primaryTextColor,),
                      const SizedBox(width: 10),
                      Text(
                        "About this account",
                        style: GoogleFonts.baloo2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                    _showAccountInfoWidget(context, feed);
                  }
                ),
                ListTile(
                  title: Row(
                    children: [
                      const Icon(Icons.report_gmailerrorred, color: AppColors.error_red,),
                      const SizedBox(width: 10),
                      Text(
                        "Report",
                        style: GoogleFonts.baloo2(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.error_red,
                        ),
                      ),
                    ],
                  ),
                  onTap: (){
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Can't report an account in demo mode"),
                        duration: Duration(seconds: 3),
                      )
                    );
                  }
                ),
              ],
            ),
          );
        },
      );
    }


    
    return FutureBuilder<List<Feed>>(
      future: _feedsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(_feedLikeStates.isEmpty){
            _feedLikeStates = snapshot.data!.map((feed) => FeedLikeState(likes: _generateRandomLikes())).toList();
          }
          return Container(
            decoration: BackgroundDecoration(theme.backgroundImageUrl),
            padding: EdgeInsets.zero,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, feedIndex) {
                if (snapshot.data![feedIndex].username != _currentUsername) {
                  return Column(
                    children: [
                      Container(
                        height: 50,
                        decoration: BackgroundDecoration(theme.backgroundImageUrl),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(snapshot.data![feedIndex].avatarUrl,)
                              ),
                              SizedBox(width: 10),
                              ReusableTextWidget(
                                text: snapshot.data![feedIndex].username,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.more_horiz),
                                onPressed: () => _showMoreOnFeedWidget(context, snapshot.data![feedIndex]),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: snapshot.data![feedIndex].posts.length,
                          itemBuilder: (context, contentIndex) {
                            print('url: ${snapshot.data![feedIndex].posts[contentIndex]}');
                            return _buildMediaWidget(
                              snapshot.data![feedIndex].posts[contentIndex],
                              contentIndex+1,
                              snapshot.data![feedIndex].posts.length
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BackgroundDecoration(theme.backgroundImageUrl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    child: Icon(_feedLikeStates[feedIndex].isLiked ? Icons.favorite : Icons.favorite_border_outlined),
                                    onTap: () {
                                      setState(() {
                                        if(!_feedLikeStates[feedIndex].isLiked){
                                          _feedLikeStates[feedIndex].likes++;
                                        } else{
                                          _feedLikeStates[feedIndex].likes--;
                                        }
                                        _feedLikeStates[feedIndex].isLiked = !_feedLikeStates[feedIndex].isLiked;
                                      });
                                    }
                                  ),
                                  SizedBox(width: 10),
                                  // Icon(Icons.comment),
                                  // SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () { 
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Can't share post in demo mode"),
                                          duration: Duration(seconds: 3),
                                        )
                                      );
                                    },
                                    child: Transform.rotate(angle: -22.5*pi/180, child: Icon(Icons.send_rounded))
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () { 
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Can't bookmark post in demo mode"),
                                          duration: Duration(seconds: 3),
                                        )
                                      );
                                    },
                                    child: Icon(Icons.bookmark_outline_outlined)
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            ReusableTextWidget(
                              text: '${_feedLikeStates[feedIndex].likes} likes', 
                              fontSize: 16, 
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10,),
                            CaptionWidget(
                              username: snapshot.data![feedIndex].username, 
                              caption: snapshot.data![feedIndex].caption,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildMediaWidget(String fileUrl, int currentIndex, int totalItems) {
    var theme = Provider.of<ThemeProvider>(context).currentTheme;
    var translucientFieldColor = theme.primaryFieldColor.withOpacity(0.4);

    final type = _extractTypeFromUrl(fileUrl);
    return Stack(
      fit: StackFit.expand,
      children: [
        type == 'image'
            ? Container(
                decoration: BackgroundDecoration(theme.backgroundImageUrl),
                child: Image.network(fileUrl, fit: BoxFit.cover))
            : Container(
                decoration: BackgroundDecoration(theme.backgroundImageUrl),
                child: VideoPlayerWidget(fileUrl: fileUrl)),
        totalItems > 1 
        ? Positioned(
            top: 10,
            right: 10,
            
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: translucientFieldColor,
                borderRadius: BorderRadius.circular(20),
              ),
              
              child: ReusableTextWidget(
                text: '$currentIndex/$totalItems',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Container(),
      ],
    );
  }


  String _extractTypeFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['type'] ?? 'unknown';
  }

  int _generateRandomLikes() {
    return Random().nextInt(4001) + 1000;
  }  

}

