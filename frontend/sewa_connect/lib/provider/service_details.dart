import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String photo;
  final String docId;
  final String providerName;
  final String heroTag;
  const ServiceDetailsPage({
    super.key,
    required this.photo,
    required this.docId,
    required this.providerName,
    required this.heroTag,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  bool _accepting = false;

  Future<void> _handleAccept() async {
    if (_accepting) return;
    setState(() => _accepting = true);

    try {
      final providerId = FirebaseAuth.instance.currentUser?.uid;
      if (providerId == null) return;

      final cancelledTasks = await FirebaseFirestore.instance
          .collection("Accepted Services")
          .where("cancelledBy", isEqualTo: providerId)
          .where("taskStatus", isEqualTo: "cancelled")
          .get();

      DateTime? latestCancelledAt;
      for (final doc in cancelledTasks.docs) {
        final data = doc.data();
        final cancelledAt = data["cancelledAt"];
        if (cancelledAt is Timestamp) {
          final dt = cancelledAt.toDate();
          if (latestCancelledAt == null || dt.isAfter(latestCancelledAt)) {
            latestCancelledAt = dt;
          }
        }
      }

      if (latestCancelledAt != null) {
        final cooldownEnd = latestCancelledAt.add(const Duration(hours: 24));
        final now = DateTime.now();
        if (now.isBefore(cooldownEnd)) {
          final left = cooldownEnd.difference(now);
          final hours = left.inHours;
          final minutes = left.inMinutes.remainder(60);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Cannot accept new task for $hours h $minutes m after cancellation.",
              ),
            ),
          );
          return;
        }
      }

      final myTask = await FirebaseFirestore.instance
          .collection("Accepted Services")
          .where("acceptedBy", isEqualTo: providerId)
          .where("taskStatus", isEqualTo: "running")
          .get();

      if (myTask.docs.isNotEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Finish your running Task !")),
        );
        return;
      }

      final taskRef = FirebaseFirestore.instance
          .collection("Accepted Services")
          .doc(widget.docId);

      final accepted = await FirebaseFirestore.instance.runTransaction<bool>((
        transaction,
      ) async {
        final taskSnap = await transaction.get(taskRef);
        if (!taskSnap.exists) {
          return false;
        }
        final data = taskSnap.data() as Map<String, dynamic>;
        if (data["isTaken"] == true) {
          return false;
        }
        transaction.update(taskRef, {
          "acceptedBy": providerId,
          "isTaken": true,
          "taskStatus": "running",
          "cancelledBy": null,
          "cancelledAt": null,
        });
        return true;
      });

      if (!mounted) return;
      if (!accepted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Already accepted !")));
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Task accepted")));
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => _accepting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Details"),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
            .collection("Accepted Services")
            .doc(widget.docId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Service details not found"));
          }

          final data = snapshot.data!.data()!;
          final customerName = data["name"]?.toString() ?? "Unknown";
          final phone = data["phone"]?.toString() ?? "-";
          final service = data["service"]?.toString() ?? "-";
          final address = data["address"]?.toString() ?? "-";

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Hero(
                  tag: widget.heroTag,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: CachedNetworkImage(
                      imageUrl: widget.photo,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorWidget: (context, url, error) => Container(
                        color: theme.primary.withAlpha(20),
                        child: const Icon(Icons.broken_image, size: 48),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: theme.primary.withAlpha(70)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.primary,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerName,
                              style: TextStyle(
                                color: theme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              service,
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        _infoRow(
                          Icons.badge_outlined,
                          "Provider",
                          widget.providerName,
                        ),
                        const Divider(height: 20),
                        _infoRow(Icons.phone_outlined, "Phone", phone),
                        const Divider(height: 20),
                        _infoRow(
                          Icons.location_on_outlined,
                          "Address",
                          address,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton.icon(
                  onPressed: _accepting ? null : _handleAccept,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: _accepting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_accepting ? "Accepting..." : "Accept Task"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
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
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
