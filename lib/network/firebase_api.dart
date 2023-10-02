import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:pesantren_flutter/res/my_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title : ${message.notification?.title}');
    print('Body : ${message.notification?.body}');
    print('Payload : ${message.data}');
    instantNotify(message);
  }

  void handleForegroundMessage(RemoteMessage message) {
    print('Foreground Message:');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Payload: ${message.data}');
    instantNotify(message);
  }

   

  static Future<bool> instantNotify(RemoteMessage message)async{
    final AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    return awesomeNotifications.createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'basic_channel',
        title: message.notification?.title ?? 'Ini adalah title notifikasi',
        body: 'Ini adalah body notifikasi',
        notificationLayout: NotificationLayout.BigPicture,
        bigPicture: 'https://picsum.photos/200/300',
        icon: 'https://picsum.photos/200/300',
        color: Colors.red,
        displayOnBackground: true,
        displayOnForeground: true,
      ),
    );
  }
  
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final FcmToken = await _firebaseMessaging.getToken();
    print('FcmToken: $FcmToken');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FCM_TOKEN', FcmToken ?? '');
    FirebaseMessaging.onBackgroundMessage(instantNotify);
    FirebaseMessaging.onMessage.listen(instantNotify);
  }


  Future<void> initAwesomeNotification() async {
    AwesomeNotifications().initialize(
      'resource://drawable/icon',
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: MyColors.primary,
          ledColor: Colors.white,
        )
    ]);

    notificationPermission();
    
  }

  void notificationPermission(){
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}