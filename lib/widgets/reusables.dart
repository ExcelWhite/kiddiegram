import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kiddiegram/models/user_profile_model.dart';

class ReusableTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;

  
  const ReusableTextWidget({
    super.key, 
    required this.text, 
    required this.fontSize, 
    required this.fontWeight, 
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.baloo2(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

class BackgroundDecoration extends BoxDecoration {
  BackgroundDecoration(String backgroundUrl)
    : super(
        image: DecorationImage(
          image: AssetImage(backgroundUrl),
          fit: BoxFit.cover,
        ),
      );
}

class GoToWidget extends StatelessWidget {
  final String routeName;
  final String text;
  const GoToWidget({
    super.key, required this.routeName, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () async => await Navigator.pushNamed(context, routeName) ,
        child: Container(
          height: 44,
          width: MediaQuery.of(context).size.width *0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black,
          ),
          child: Row(
            children: [
              SizedBox(width: 20,),
              const Icon(Icons.arrow_back, color: Colors.white,),
              const SizedBox(width: 10,),
              ReusableTextWidget(text: text, fontSize: 14, fontWeight: FontWeight.bold),
            ],
          ),
        )
      ),
    );
  }
}


class DisplayThemeWidget extends StatelessWidget {
  final Color color;
  final String url;
  final String text;

  const DisplayThemeWidget({
    super.key, required this.color, required this.url, required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 5.0),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image(
              image: AssetImage(url),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5,),
        ReusableTextWidget(text: text, fontSize: 14, fontWeight: FontWeight.bold)
      ],
    );
  }
}


class ProfileDisplay extends StatelessWidget {
  final bool isLoading;
  final List<UserProfile> profiles;
  final int index;



  const ProfileDisplay({
    super.key,
    required this.isLoading,
    required this.profiles,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return CircularProgressIndicator();
    } else if (profiles.isNotEmpty) {
      return Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(profiles[index].avatarUrl),
          ),
          const SizedBox(height: 5),
          ReusableTextWidget(
            text: profiles[index].username, 
            fontSize: 12, 
            fontWeight: FontWeight.bold
          ),
        ],
      );
    } else {
      return const Text(
        'No profiles available',
        style: TextStyle(fontSize: 18),
      );
    }
  }
}



//caption widget

class CaptionWidget extends StatefulWidget {
  final String username;
  final String caption;

  CaptionWidget({required this.username, required this.caption});

  @override
  _CaptionWidgetState createState() => _CaptionWidgetState();
}

class _CaptionWidgetState extends State<CaptionWidget> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: widget.username + ' ',
            style: GoogleFonts.baloo2(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: _showMore
                ? widget.caption
                : widget.caption.length > 70
                    ? widget.caption.substring(0, 70) + ' '
                    : widget.caption,
            style: GoogleFonts.baloo2(
              fontSize: 16,
            ),
          ),
          if (!_showMore && widget.caption.length > 70)
            TextSpan(
              text: '>more',
              style: GoogleFonts.baloo2(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    _showMore = true;
                  });
                },
            ),

          if (_showMore && widget.caption.length > 70)
            TextSpan(
              text: ' <less',
              style: GoogleFonts.baloo2(
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    _showMore = false;
                  });
                },
            ),
        ],
      ),
    );
  }
}


//more on feed widget:

class MoreOnFeedWidget extends StatelessWidget {
  const MoreOnFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const ReusableTextWidget(
            text: "About this account",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: (){print('about account');}
        ),
        ListTile(
          title: const ReusableTextWidget(
            text: "Report",
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          trailing: const Icon(Icons.report_gmailerrorred,),
          onTap: (){print('Report');}
        ),
      ],
    );
  }
}
