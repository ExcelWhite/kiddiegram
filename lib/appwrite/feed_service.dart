import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:kiddiegram/appwrite/client_service.dart';
import 'package:kiddiegram/appwrite/database_service.dart';
import 'package:kiddiegram/appwrite/user_service.dart';
import 'package:kiddiegram/models/feed_model.dart';

class FeedService{
  final DatabaseService _databaseService;
  final UserService _userService;
  final Storage _storage;

  FeedService( this._databaseService, this._userService) 
    : _storage = Storage(ClientService.instance.client);


  Future<List<Feed>> fetchFeeds() async {
    try{
      final fetchedFeeds = await _databaseService.fetchFeeds();
      return fetchedFeeds;
    } catch(e){
      print(e);
      throw Exception('Failed to fetch feeds: $e');
    }    
  }
}