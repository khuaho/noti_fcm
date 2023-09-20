import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noti_fcm/modules/home/home_page.dart';

import 'firebase/firebase_config.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    initFirebaseMessaging();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('resumed');
        // context.read<AppSettingsProvider>().fetch();
        // if (authProvider.isAuth) {
        //   handleUpsertInstallation();
        // }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }

  void initFirebaseMessaging() async {
    final settingFirebase = await FirebaseConfig.requestPermission();
    if (settingFirebase.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        if (notification != null && !kIsWeb) {
          print('notification: $notification');
          // refreshTotalNotifyUnRead();
        }
      });

      // handle message open app when app is running in background
      FirebaseMessaging.onMessageOpenedApp.listen(
        handleNotifyOnBackgroundAndQuitApp,
      );

      // handle message open app when app terminated
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? remoteMessage) {
        if (remoteMessage != null) {
          handleNotifyOnBackgroundAndQuitApp(remoteMessage);
        }
      });
    } else if (settingFirebase.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }

  void handleNotifyOnBackgroundAndQuitApp(RemoteMessage message) {
    if (message.data.isNotEmpty && !kIsWeb) {
      final data = message.data;
      print('data: $data');
      // final notify = jsonDecode(data['notify']);
      // * Handle others Cases with "typeName";
      // _appRouter.push(HomeRoute(children: [
      //   RemotesRoute(
      //     children: [
      //       RemoteDetailsRoute(id: notify['remoteId']),
      //     ],
      //   ),
      // ]));
      // handleReadNotifications(data['notifyId'] as String);
    }
  }
}
