import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Create an instance of Firebase Messaging
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // Create an instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Function to initialize notifications
  Future<void> initNotifications() async {
    // Request permission from the user
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    // Fetch the FCM token for this device
    final fCMToken = await _firebaseMessaging.getToken();
    print('FCM Token: $fCMToken'); // Normally, send this token to the server

    // Initialize the Flutter Local Notifications plugin
    await _initializeLocalNotifications();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background messages when the app is in the background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // Handle messages when the app is terminated and opened by a notification
    FirebaseMessaging.instance.getInitialMessage().then(_handleTerminatedMessage);
  }

  // Function to initialize Flutter Local Notifications for displaying notifications when the app is in the foreground
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      // Replaced onSelectNotification with onDidReceiveNotificationResponse
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          print('Notification tapped with payload: ${notificationResponse.payload}');
        }
      },
    );
  }

  // Function to handle foreground notifications
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('Received foreground message: ${message.notification?.title}, ${message.notification?.body}');
    
    // Display local notification when the app is in the foreground
    _showLocalNotification(message);
  }

  // Function to handle background notifications (when the app is in background but not terminated)
  Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('App opened from background notification: ${message.notification?.title}, ${message.notification?.body}');
    
    // You can handle navigation or custom logic here based on the notification
  }

  // Function to handle messages when the app is terminated and opened by a notification
  Future<void> _handleTerminatedMessage(RemoteMessage? message) async {
    if (message != null) {
      print('App opened from terminated state by notification: ${message.notification?.title}, ${message.notification?.body}');
      
      // You can handle navigation or custom logic here based on the notification
    }
  }

  // Function to show a local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id', // ID for the notification channel
      'Channel Name', // Name for the channel
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title,
      message.notification?.body,
      notificationDetails,
      payload: message.data['payload'], // Add any payload you need for navigation or custom actions
    );
  }
}
