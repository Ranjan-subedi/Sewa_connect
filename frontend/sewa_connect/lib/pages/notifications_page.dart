import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/widget/notification_services.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  IconData _iconForType(String? type) {
    switch (type) {
      case 'accepted':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'completed':
        return Icons.task_alt;
      case 'cancelled':
        return Icons.event_busy_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String? type, ColorScheme theme) {
    switch (type) {
      case 'accepted':
        return Colors.green.shade600;
      case 'rejected':
        return Colors.red.shade600;
      case 'completed':
        return theme.primary;
      case 'cancelled':
        return Colors.orange.shade700;
      default:
        return theme.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (userId != null)
            TextButton(
              onPressed: () =>
                  NotificationServices().markAllAsRead(userId),
              child: const Text(
                'Read all',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: userId == null
          ? const Center(child: Text('Please sign in to view notifications'))
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: NotificationServices().userNotifications(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.notifications_none,
                          size: 64,
                          color: theme.primary.withAlpha(120),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data();
                    final title = data['title']?.toString() ?? 'Update';
                    final body = data['body']?.toString() ?? '';
                    final byWhom = data['byWhom']?.toString();
                    final type = data['type']?.toString();
                    final isRead = data['isRead'] == true;
                    final ts = data['timestamp'];

                    return Dismissible(
                      key: ValueKey(doc.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) =>
                          NotificationServices().markAsRead(doc.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.green.shade400,
                        child: const Icon(Icons.done, color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () =>
                            NotificationServices().markAsRead(doc.id),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isRead
                                ? Colors.white
                                : theme.primary.withAlpha(18),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isRead
                                  ? Colors.grey.shade200
                                  : theme.primary.withAlpha(60),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    _colorForType(type, theme).withAlpha(30),
                                child: Icon(
                                  _iconForType(type),
                                  color: _colorForType(type, theme),
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: theme.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(body),
                                    if (byWhom != null &&
                                        byWhom.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        'By: $byWhom',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade700,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                    if (ts is Timestamp) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        ts.toDate().toLocal().toString(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
