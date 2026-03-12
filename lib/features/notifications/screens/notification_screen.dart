import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';

class NotificationScreen extends StatelessWidget {

  const NotificationScreen({super.key});

  List<NotificationModel> getNotifications() {

    return [

      NotificationModel(
        id: "1",
        title: "Budget Alert",
        message: "You have reached 80% of your Food budget",
        date: DateTime.now(),
      ),

      NotificationModel(
        id: "2",
        title: "Expense Added",
        message: "New expense of \$50 added",
        date: DateTime.now(),
      ),

      NotificationModel(
        id: "3",
        title: "Reminder",
        message: "Don't forget to update today's expenses",
        date: DateTime.now(),
      ),

    ];

  }

  @override
  Widget build(BuildContext context) {

    final notifications = getNotifications();

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: ListView.builder(

        itemCount: notifications.length,

        itemBuilder: (context, index) {

          final notification = notifications[index];

          return Card(

            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),

            child: ListTile(

              leading: const Icon(
                Icons.notifications,
                color: Colors.blue,
              ),

              title: Text(notification.title),

              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(notification.message),

                  const SizedBox(height:4),

                  Text(
                    notification.date.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),

                ],
              ),

            ),

          );

        },

      ),

    );

  }

}