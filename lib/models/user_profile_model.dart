class UserProfile{
  final String username;
  final String email;
  final String avatarUrl;

  UserProfile({
    required this.username, 
    required this.email, 
    required this.avatarUrl,
  });

  //user profile to map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }

  //map to user profile
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'],
      email: map['email'],
      avatarUrl: map['avatarUrl'],
    );
  }
}