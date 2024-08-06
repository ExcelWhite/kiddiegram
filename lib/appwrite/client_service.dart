import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:kiddiegram/constants.dart';

class ClientService {
  ClientService._privateConstructor();

  static final ClientService _instance = ClientService._privateConstructor();
  
  static ClientService get instance {
    WidgetsFlutterBinding.ensureInitialized(); // Ensure initialized before accessing instance
    return _instance;
  }

  final Client client = Client()
    ..setEndpoint(APPWRITE_URL)
    ..setProject(APPWRITE_PROJECT_ID)
    ..setSelfSigned();

}


class AccountService {
  AccountService._privateConstructor();

  static final AccountService _instance = AccountService._privateConstructor();

  static AccountService get instance => _instance;

  final Account account = Account(ClientService.instance.client);
}

