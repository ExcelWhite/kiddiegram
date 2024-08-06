import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:kiddiegram/constants.dart';

class UserService {
  final Databases database;

  UserService(this.database);

  Future<bool> isUsernameTaken(String username) async {
    final response = await database.listDocuments(
      databaseId: APPWRITE_DB_ID,
      collectionId: COLLECTION_USERS,
      queries: [
        Query.equal('username', username),
      ],
    );

    return response.total > 0;
  }

  Future<Document> addUser({required String username, required String email}) {
    return database.createDocument(
      databaseId: APPWRITE_DB_ID,
      collectionId: COLLECTION_USERS,
      documentId: ID.unique(),
      data: {
        'username': username,
        'email': email,
        'avatarUrl': 'https://iconduck.com/icons/168983/profile-user',
      },
    );
  }

  Future<dynamic> deleteUser({required String id}){
    return database.deleteDocument(
      documentId: id,
      collectionId: COLLECTION_USERS,
      databaseId: APPWRITE_DB_ID,
    );
  }
}
