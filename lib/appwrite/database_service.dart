import 'package:appwrite/appwrite.dart';
import 'package:kiddiegram/appwrite/auth_service.dart';
import 'package:kiddiegram/appwrite/client_service.dart';
import 'package:kiddiegram/constants.dart';
import 'package:kiddiegram/models/feed_model.dart';
import 'package:kiddiegram/models/user_profile_model.dart';

class DatabaseService {
  final Account account = AccountService.instance.account;
  late final Databases database;
  late AuthService authService = AuthService();

  DatabaseService(){init();}

  init(){  
    database = Databases(ClientService.instance.client);
  }


  Future<List<UserProfile>> fetchProfiles() async {
    final response = await database.listDocuments(
      databaseId: APPWRITE_DB_ID,
      collectionId: COLLECTION_USERS,
    );

    return response.documents.map((doc) => UserProfile.fromMap(doc.data)).toList();
  }

  Future<List<UserProfile>> searchProfiles({String? searchQuery}) async{
  try {
    final response = await database.listDocuments(
      databaseId: APPWRITE_DB_ID,
      collectionId: COLLECTION_USERS,
      queries: [
        Query.search('username', searchQuery!),
      ]
    );

    print('response gotten');

    return response.documents.map((doc) => UserProfile.fromMap(doc.data)).toList();
  } catch (e) {
    print('Error searching profiles: $e');
    return []; // or rethrow the error, depending on your needs
  }
}

  Future<List<Feed>> fetchFeeds() async{
    final response = await database.listDocuments(
      databaseId: APPWRITE_DB_ID, 
      collectionId: COLLECTION_FEEDS,
    );

    return response.documents.map((doc) => Feed.fromMap(doc.data)).toList();
  }

  Future<List<Feed>> fetchMyFeeds({String? username}) async{
    try {
      print(username);
      final response = await database.listDocuments(
        databaseId: APPWRITE_DB_ID,
        collectionId: COLLECTION_FEEDS,
        queries: [
          Query.search('username', username!),
        ],
      );
      print(username);
      return response.documents.map((doc) => Feed.fromMap(doc.data)).toList();
    } catch (e) {
      print(e);
      return [];
    }

  }
}