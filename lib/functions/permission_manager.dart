import 'package:flutter/material.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager{
  Future<bool> requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.status;
    if(status != PermissionStatus.granted){
     final result = await showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const ReusableTextWidget(text: 'Notification Permission', fontSize: 16, fontWeight: FontWeight.bold,),
          content: const ReusableTextWidget(
            text: 'Kiddiegram needs notification permission granted', 
            fontSize: 16, 
            fontWeight: FontWeight.bold,
          ),

          actions: [
            TextButton(
              child: const ReusableTextWidget(text: 'Cancel', fontSize: 16, fontWeight: FontWeight.bold,),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const ReusableTextWidget(text: 'OK', fontSize: 16, fontWeight: FontWeight.bold,),
              onPressed: () async {
                final status = await Permission.notification.request();
                if (status == PermissionStatus.granted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: ReusableTextWidget(
                        text: 'Notification access granted',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: ReusableTextWidget(
                        text: 'Notification access denied',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
                Navigator.pop(context);
              },
            ),
          ],
        )
      );

      return result ?? false;
    } else{
      return true;
    }
  }
}