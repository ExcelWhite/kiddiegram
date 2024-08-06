
class Feed {
  String avatarUrl;
  String username;
  List<String> posts;
  String caption;


  Feed({
    required this.avatarUrl,
    required this.username,
    required this.posts,
    required this.caption,
  });

  //user profile to map
  Map<String, dynamic> toMap() {
    return {
      'avatarUrl': avatarUrl,
      'username': username,
      'posts': posts,
      'caption': caption,
    };
  }

  //map to user profile
  factory Feed.fromMap(Map<String, dynamic> map) {
    return Feed(
      avatarUrl: map['avatarUrl'],
      username: map['username'],
      posts: List<String>.from(map['posts']),
      caption: map['caption'],
    );
  }
}