import 'package:flutter/material.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:kiddiegram/widgets/post_widget.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const ReusableTextWidget(text: 'My Posts', fontSize: 24, fontWeight: FontWeight.bold),
      ),

      body: Stack(
        children: [
          BackgroundWidget(backgroundImageUrl: theme.backgroundImageUrl),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              PostsWidget(),
            ],
          )
        ],
        
      ),
    );
  }
}