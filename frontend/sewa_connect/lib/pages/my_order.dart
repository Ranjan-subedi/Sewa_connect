import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/pages/map.dart';
import 'package:sewa_connect/services/database_services.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';

class MyOrderPage extends StatefulWidget {
  const MyOrderPage({super.key});

  @override
  State<MyOrderPage> createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? fetchMyAllOrder;
  String? email;

  Future<void> getSharedPreferences() async {
    email = await SharedPreferencesHelper().getEmail();
    setState(() {});
  }

  Future<void> getOnTheLoad() async {
    await getSharedPreferences();
    if (email == null || email!.isEmpty) return;
    fetchMyAllOrder = DatabaseServices().myOrder(email: email!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnTheLoad();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      color: theme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.primary.withAlpha(22),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.primary.withAlpha(70)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: theme.primary,
                  child: const Icon(Icons.receipt_long, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Orders",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Track your booked services",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: email == null || email!.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        "Sign in and set your email to view orders.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: getOnTheLoad,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: fetchMyAllOrder,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              "Could not load orders",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.inbox_outlined,
                                        size: 64,
                                        color: theme.primary.withAlpha(120),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        "No orders yet",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: theme.primary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Book a service from the home page",
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        final orders = snapshot.data!.docs;

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final data = orders[index].data();
                            final name = data["name"]?.toString() ?? "Service";
                            final service = data["service"]?.toString() ?? "";
                            final address = data["address"]?.toString() ?? "-";
                            final status =
                                data["status"]?.toString() ?? "pending";
                            final location = data["Location"];
                            final scheduled = _formatSchedule(
                              data["scheduleAt"],
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            name,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        _StatusChip(status: status),
                                      ],
                                    ),
                                    if (service.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        service,
                                        style: TextStyle(
                                          color: theme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 14),
                                    _DetailRow(
                                      icon: Icons.event_outlined,
                                      label: "Scheduled",
                                      value: scheduled,
                                    ),
                                    const SizedBox(height: 10),
                                    _DetailRow(
                                      icon: Icons.location_on_outlined,
                                      label: "Address",
                                      value: address,
                                    ),
                                    if (location is Map &&
                                        location["latitude"] != null &&
                                        location["longitude"] != null) ...[
                                      const SizedBox(height: 14),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => MapPage(
                                                  lat:
                                                      (location["latitude"]
                                                              as num)
                                                          .toDouble(),
                                                  long:
                                                      (location["longitude"]
                                                              as num)
                                                          .toDouble(),
                                                ),
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.map_outlined,
                                            size: 18,
                                            color: theme.primary,
                                          ),
                                          label: Text(
                                            "View on map",
                                            style: TextStyle(
                                              color: theme.primary,
                                            ),
                                          ),
                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            side: BorderSide(
                                              color: theme.primary.withAlpha(
                                                100,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
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
    if (dt == null) return "Not scheduled";
    final date =
        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    return "$date at $time";
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    Color bg;
    Color fg;
    String label;

    switch (normalized) {
      case "accepted":
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
        label = "Accepted";
        break;
      case "completed":
        bg = Colors.blue.shade100;
        fg = Colors.blue.shade800;
        label = "Completed";
        break;
      case "rejected":
        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
        label = "Rejected";
        break;
      default:
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade900;
        label = "Pending";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
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
