import 'package:flutter/material.dart';
import 'package:kiddiegram/functions/notification_manager.dart';
import 'package:kiddiegram/functions/permission_manager.dart';
import 'package:kiddiegram/models/notification.dart';
import 'package:kiddiegram/state/theme_provider.dart';
import 'package:kiddiegram/widgets/background_widgets.dart';
import 'package:kiddiegram/widgets/notification_widget.dart';
import 'package:kiddiegram/widgets/reusables.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final PermissionManager _permissionManager = PermissionManager();
  final NotificationManager _notificationManager = NotificationManager();
  final List<NotificationModel> _notifications = [];
  
  @override
  Widget build(BuildContext context) {

    var theme = Provider.of<ThemeProvider>(context).currentTheme;
    return Scaffold(
      
      body: Stack(
        children: [
          BackgroundWidget(backgroundImageUrl: theme.backgroundImageUrl),
          Positioned(
            top: 80,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ReusableTextWidget(text: 'Notifications', fontSize: 30, fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: theme.primaryFieldColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: theme.primaryFieldColor,
                      width: 4,
                    ),
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      children: _notifications
                          .map((notification) => NotificationWidget(
                            notification: notification)).toList(),
                    ),
                  ),
                ),
              ],
            )
          ),

        ],
      ),

      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () async { 
            final notificationAccess = await _permissionManager.requestNotificationPermission(context);
            if(notificationAccess){
              final notification = NotificationModel(
                id: 0, 
                title: "Kiddigram notification", 
                body: "Kiddiegram update will be available soon",
              );
              setState(() {
                _notifications.add(notification);
              });
              await _notificationManager.showNotification(
                id: notification.id, 
                title: notification.title, 
                body: notification.body,
              );
            }

          },
          
          child: Container(
            width: MediaQuery.of(context).size.width *0.6,
            height: 44,
            decoration: BoxDecoration(
              color: theme.primaryButtonColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.notifications_active_outlined),
                ReusableTextWidget(
                  text: 'Get a notification', 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}