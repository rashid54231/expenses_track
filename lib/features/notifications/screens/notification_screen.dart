import 'package:flutter/material.dart';
import '../../../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();
    notifications = getNotifications();
  }

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

  String formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  void deleteNotification(String id) {
    setState(() {
      notifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),

      body: notifications.isEmpty
          ? const Center(
        child: Text(
          "No notifications yet",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {

          final notification = notifications[index];

          return Dismissible(

            key: Key(notification.id),

            direction: DismissDirection.endToStart,

            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),

            onDismissed: (_) {
              deleteNotification(notification.id);
            },

            child: Card(

              elevation: 3,

              margin: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 8,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),

              child: ListTile(

                leading: const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                ),

                title: Text(
                  notification.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 4),

                    Text(notification.message),

                    const SizedBox(height: 6),

                    Text(
                      formatDate(notification.date),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                  ],
                ),

              ),

            ),

          );

        },
      ),

    );

  }

}