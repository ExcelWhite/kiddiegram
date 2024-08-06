import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kiddiegram/appwrite/database_service.dart';
import 'package:kiddiegram/appwrite/feed_service.dart';
import 'package:kiddiegram/appwrite/user_service.dart';
import 'package:kiddiegram/models/feed_model.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/feed_widget.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:kiddiegram/widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostLikeState {
  int likes;
  bool isLiked;

  PostLikeState({required this.likes, this.isLiked = false});
}

class PostsWidget extends StatefulWidget {
  @override
  _PostsWidgetState createState() => _PostsWidgetState();
}


class _PostsWidgetState extends State<PostsWidget> {
  final PageController _pageController = PageController();
  String _avatarUrl = '';
  String _currentUsername = '';

  late DatabaseService _databaseService;
  late Future<void> _initFuture;


  //String _currentUsername = '';

  late List<PostLikeState> _postLikeStates;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _initFuture = _init();
    _postLikeStates = [];
  }

  Future<void> _init() async {
    await _getUsername();
    await _getAvatarUrl();
  }

  Future<List<Feed>> _fetchPosts() async {
    List<Feed> posts = await _databaseService.fetchMyFeeds(username: _currentUsername);
    return posts;
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('username') ?? '';
    });
  }
  Future<void> _getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context).currentTheme;

    return FutureBuilder<List<Feed>>(
      future: _fetchPosts(), 
      builder: (context, snapshot){
        if(snapshot.hasData){
          if(_postLikeStates.isEmpty){
          _postLikeStates = snapshot.data!.map((feed) => PostLikeState(likes: _generateRandomLikes())).toList();
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
                if (snapshot.data![feedIndex].username == _currentUsername) {
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
                                    child: Icon(_postLikeStates[feedIndex].isLiked ? Icons.favorite : Icons.favorite_border_outlined),
                                    onTap: () {
                                      setState(() {
                                        if(!_postLikeStates[feedIndex].isLiked){
                                          _postLikeStates[feedIndex].likes++;
                                        } else{
                                          _postLikeStates[feedIndex].likes--;
                                        }
                                        _postLikeStates[feedIndex].isLiked = !_postLikeStates[feedIndex].isLiked;
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
                              text: '${_postLikeStates[feedIndex].likes} likes', 
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
        } else {
          return const Center(child: CircularProgressIndicator(),);
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