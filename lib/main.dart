import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/notification_controller.dart';
import 'views/notification_list_view.dart';

void main() {
  runApp(const MyApp());
}

/// Root application widget
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationController(),
      child: MaterialApp(
        title: 'Notification Listener',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const NotificationListView(),
      ),
    );
  }
}