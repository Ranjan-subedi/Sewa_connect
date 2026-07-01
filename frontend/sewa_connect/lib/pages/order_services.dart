import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/pages/pick_map.dart';
import 'package:sewa_connect/services/database_services.dart';
import 'package:sewa_connect/services/geo_locator.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServicesPage extends StatefulWidget {
  final String name;
  final String photo;
  final String service;
  final String providerRef;

  const OrderServicesPage({
    super.key,
    required this.name,
    required this.service,
    required this.photo,
    required this.providerRef,
  });

  @override
  State<OrderServicesPage> createState() => _OrderServicesState();
}

class _OrderServicesState extends State<OrderServicesPage> {
  String? email;
  DateTime? selectedSchedule;

  getSharedPrefs() async {
    email = await SharedPreferencesHelper().getEmail();
    setState(() {
      print(email);
    });
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: "tel", path: phoneNumber);

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Cannot make phone call")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error on launching phone call")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedPrefs();
  }

  Future<void> _pickSchedule() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (pickedDate == null) return;

    if (!mounted) return;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    final merged = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (merged.isBefore(now)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a future time")),
      );
      return;
    }

    setState(() {
      selectedSchedule = merged;
    });
  }

  String _formatSchedule(DateTime dateTime) {
    final d =
        "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    final t =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
    return "$d $t";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    widget.photo,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.person, size: 70),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [



                      Text(
                        "Reviews",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("Services")
                            .doc(widget.service)
                            .collection("providers")
                            .doc(widget.providerRef)
                            .snapshots(),
                        builder: (context, providerSnap) {
                          final avg =
                              (providerSnap.data?.data()?["averageRating"]
                                      as num?)
                                  ?.toDouble() ??
                              0;
                          final count =
                              (providerSnap.data?.data()?["reviewCount"]
                                      as num?)
                                  ?.toInt() ??
                              0;

                          return Row(
                            children: [
                              ...List.generate(5, (index) {
                                return Icon(
                                  index < avg.round()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                avg > 0 ? avg.toStringAsFixed(1) : "No ratings",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (count > 0) ...[
                                const SizedBox(width: 6),
                                Text(
                                  "($count)",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: DatabaseServices().providerReviews(
                          providerRef: widget.providerRef,
                          service: widget.service,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: LinearProgressIndicator(),
                            );
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Text(
                              "No reviews yet. Be the first to book and rate!",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700],
                              ),
                            );
                          }

                          final reviews = snapshot.data!.docs.take(3).toList();
                          return Column(
                            children: reviews.map((doc) {
                              final data = doc.data();
                              final rating =
                                  (data["rating"] as num?)?.toInt() ?? 0;
                              final text = data["review"]?.toString() ?? "";

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: List.generate(5, (index) {
                                        return Icon(
                                          index < rating
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                    ),
                                    if (text.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        text,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.grey[700]),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                widget.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "5+ Years Experience",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 24),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: const [
                      _InfoTile(
                        icon: Icons.person,
                        title: "Name",
                        value: "Ranjan Subedi",
                      ),
                      Divider(),
                      _InfoTile(
                        icon: Icons.location_on,
                        title: "Address",
                        value: "Pokhara",
                      ),
                      Divider(),
                      _InfoTile(
                        icon: Icons.phone,
                        title: "Phone",
                        value: "9812345678",
                      ),
                      Divider(),
                      _InfoTile(
                        icon: Icons.email,
                        title: "Email",
                        value: "email@gmail.com",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        makePhoneCall("9864388822");
                      },
                      icon: const Icon(Icons.call),
                      label: const Text("Call"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        if (selectedSchedule == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please choose a schedule first"),
                            ),
                          );
                          return;
                        }

                        final isFree = await DatabaseServices()
                            .isProviderFreeAtSlot(
                              providerRef: widget.providerRef,
                              scheduleAt: selectedSchedule!,
                            );

                        if (!isFree) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Provider is not free at this time. Please choose another slot.",
                              ),
                            ),
                          );
                          return;
                        }

                        final position = await GeoLocatorServices()
                            .getCurrentLocation();
                        final double lat = position!.latitude;
                        final double lon = position.longitude;

                        final selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return PickMapPage(lat: lat, long: lon);
                            },
                          ),
                        );

                        if (selectedLocation == null) {
                          return;
                        }

                        final userId =
                            await FirebaseAuth.instance.currentUser!.uid;

                        await DatabaseServices().setOrder(
                          data: {
                            "userId": userId,
                            "providerRef": widget.providerRef,
                            "name": widget.name,
                            "service": widget.service,
                            "phone": "9864388822",
                            "address": "Pokhara",
                            "email": email,
                            "photo": widget.photo,
                            "Location": {
                              "latitude": selectedLocation!.latitude,
                              "longitude": selectedLocation!.longitude,
                            },
                            "status": "pending",
                            "isTaken": false,
                            "acceptedBy": null,
                            "taskStatus": "pending",
                            "isReviewed": false,
                            "scheduleAt": selectedSchedule,
                            "timestamp": DateTime.now(),
                          },
                        );
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Book Service"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _pickSchedule,
                icon: const Icon(Icons.schedule),
                label: Text(
                  selectedSchedule == null
                      ? "Choose Schedule"
                      : "Scheduled: ${_formatSchedule(selectedSchedule!)}",
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
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
