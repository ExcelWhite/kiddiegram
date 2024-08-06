import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/appwrite/database_service.dart';
import 'package:kiddiegram/appwrite/feed_service.dart';
import 'package:kiddiegram/appwrite/user_service.dart';
import 'package:kiddiegram/models/feed_model.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'dart:typed_data';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _avatarUrl = '';
  String _currentUsername = '';

  late DatabaseService _databaseService;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _databaseService = DatabaseService();
    _initFuture = _init();
  }

  Future<void> _init() async {
    await _getUsername();
    await _getAvatarUrl();
  }

  Future<List<Feed>> _fetchPosts() async {
    List<Feed> posts = await _databaseService.fetchMyFeeds(username: _currentUsername);
    return posts;
  }

  Future<void> _getAvatarUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _avatarUrl = prefs.getString('avatarUrl') ?? '';
    });
  }

  Future<void> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUsername = prefs.getString('username') ?? '';
    });
  }

  Future<Uint8List?> _generateThumbnail(String videoUrl) async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 25,
    );
    return thumbnail;
  }

  @override
  Widget build(BuildContext context) {
    final _authService = context.read<AuthService>();

    Future<void> _signout() async {
      try {
        await _authService.signOut();
        Navigator.pushNamed(context, '/select_profile');
      } on AppwriteException catch (e) {
        print(e.message);
      }
    }

    var theme = Provider.of<ThemeProvider>(context).currentTheme;

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: ReusableTextWidget(
            text: 'Account',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _signout,
            icon: Icon(Icons.exit_to_app_rounded),
          )
        ],
      ),
      body: Stack(
        children: [
          BackgroundWidget(backgroundImageUrl: theme.backgroundImageUrl),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: deviceHeight / 8,
                  left: deviceWidth / 2 - 75,
                  right: deviceWidth / 2 - 75,
                ),
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.primaryFieldColor, width: 4),
                      ),
                      child: _avatarUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 46,
                              backgroundImage: NetworkImage(_avatarUrl),
                            )
                          : const Icon(Icons.person, size: 75),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 10,
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: ReusableTextWidget(
                                text: 'This feature is inaccessible in demo mode for now!',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: theme.primaryButtonColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.backgroundBlendColor, width: 2),
                          ),
                          child: const Icon(Icons.camera_alt_outlined, size: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ReusableTextWidget(
                text: '@${_currentUsername}',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 30),
              Container(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: ReusableTextWidget(
                    text: 'My Posts',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),


              Container(
                height: deviceHeight * 0.45,
                width: deviceWidth * 0.9,
                decoration: BoxDecoration(
                  color: theme.primaryFieldColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: theme.primaryFieldColor,
                    width: 4,
                  ),
                ),
                child: FutureBuilder(
                  future: _fetchPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || (snapshot.data as List<Feed>).isEmpty) {
                      return const Center(child: Text('No posts available'));
                    }

                    List<Feed> feeds = snapshot.data as List<Feed>;

                    return GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of items per row
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: feeds.length,
                      itemBuilder: (context, index) {
                        String postUrl = feeds[index].posts.isNotEmpty ? feeds[index].posts[0] : '';

                        if (postUrl.isEmpty) {
                          return const Center(child: Text('No thumbnail available'));
                        }

                        String type = _extractTypeFromUrl(postUrl);

                        return GestureDetector(
                          onTap: () async => await Navigator.pushNamed(context, '/posts'),
                          child: Container(
                            width: deviceWidth * 0.3,
                            height: deviceWidth * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: theme.primaryFieldColor, width: 2),
                            ),
                            child: type == 'image'
                                ? Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(postUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : FutureBuilder(
                                    future: _generateThumbnail(postUrl),
                                    builder: (context, thumbnailSnapshot) {
                                      if (thumbnailSnapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      if (thumbnailSnapshot.hasError || !thumbnailSnapshot.hasData) {
                                        return const Center(child: Text('Error generating thumbnail'));
                                      }
                                      Uint8List? thumbnail = thumbnailSnapshot.data as Uint8List?;
                                      return thumbnail != null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: MemoryImage(thumbnail),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : const Center(child: Text('No thumbnail available'));
                                    },
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),


            ],
          ),
        ],
      ),
    );
  }

  String _extractTypeFromUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters['type'] ?? 'unknown';
  }
}
