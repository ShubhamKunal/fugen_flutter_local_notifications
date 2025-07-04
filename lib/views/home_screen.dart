import 'package:flutter/material.dart';
import 'package:fugen_fln/service/notifications_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Flutter Local Notifications'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Tap on the button to receive notification"),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
              ),
              onPressed: NotificationService.showNotificationWithActions,
              child: const Text("Show Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
