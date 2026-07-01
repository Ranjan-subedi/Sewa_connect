import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/widget/notification_services.dart';

class ActiveTaskPage extends StatelessWidget {
  final String docId;

  const ActiveTaskPage({super.key, required this.docId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Active Task"),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection("Orders")
            .doc(docId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Task not found"));
          }

          final data = snapshot.data!.data()!;
          final customerName = data["name"]?.toString() ?? "Unknown";
          final serviceName = data["service"]?.toString() ?? "Service";
          final phone = data["phone"]?.toString() ?? "-";
          final address = data["address"]?.toString() ?? "-";
          final scheduledAt = _formatSchedule(data["scheduleAt"]);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.primary.withAlpha(70)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.primary,
                        child: const Icon(
                          Icons.handyman_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Current Task",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              serviceName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _infoRow(
                          "Customer",
                          customerName,
                          Icons.person_outline,
                        ),
                        const Divider(height: 22),
                        _infoRow("Phone", phone, Icons.phone_outlined),
                        const Divider(height: 22),
                        _infoRow(
                          "Address",
                          address,
                          Icons.location_on_outlined,
                        ),
                        const Divider(height: 22),
                        _infoRow(
                          "Scheduled",
                          scheduledAt,
                          Icons.event_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final orderRef = FirebaseFirestore.instance
                        .collection("Orders")
                        .doc(docId);
                    final orderSnap = await orderRef.get();
                    final orderData = orderSnap.data();
                    final customerId = orderData?["userId"]?.toString();
                    final providerName =
                        orderData?["acceptedByName"]?.toString() ?? "Provider";
                    final serviceName =
                        orderData?["service"]?.toString() ?? "service";

                    await orderRef.update({
                      "taskStatus": "completed",
                      "status": "completed",
                      "isReviewed": false,
                    });

                    if (customerId != null && customerId.isNotEmpty) {
                      await NotificationServices().notifyWorkFinished(
                        userId: customerId,
                        byWhom: providerName,
                        serviceName: serviceName,
                        orderId: docId,
                      );
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text("Finish Task"),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade300),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final orderRef = FirebaseFirestore.instance
                        .collection("Orders")
                        .doc(docId);
                    final orderSnap = await orderRef.get();
                    final orderData = orderSnap.data();
                    final customerId = orderData?["userId"]?.toString();
                    final providerName =
                        orderData?["acceptedByName"]?.toString() ?? "Provider";
                    final serviceName =
                        orderData?["service"]?.toString() ?? "service";

                    await orderRef.update({
                      "taskStatus": "cancelled",
                      "status": "pending",
                      "isTaken": false,
                      "acceptedBy": null,
                      "acceptedByName": null,
                      "cancelledBy": FirebaseAuth.instance.currentUser?.uid,
                      "cancelledAt": FieldValue.serverTimestamp(),
                    });

                    if (customerId != null && customerId.isNotEmpty) {
                      await NotificationServices().notifyProviderCancelled(
                        userId: customerId,
                        byWhom: providerName,
                        serviceName: serviceName,
                        orderId: docId,
                      );
                    }

                    if (context.mounted) Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text("Cancel Task"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatSchedule(dynamic value) {
    DateTime? dt;
    if (value is Timestamp) {
      dt = value.toDate().toLocal();
    } else if (value is DateTime) {
      dt = value.toLocal();
    }
    if (dt == null) return "Not set";
    final date =
        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    return "$date at $time";
  }

  Widget _infoRow(String title, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
