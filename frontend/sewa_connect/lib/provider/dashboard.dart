import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sewa_connect/provider/active_task.dart';
import 'package:sewa_connect/provider/service_details.dart';
import 'package:sewa_connect/services/geo_locator.dart';

class ProviderDashboardPage extends StatefulWidget {
  final String job;
  final String providerName;

  const ProviderDashboardPage({
    super.key,
    required this.job,
    required this.providerName,
  });

  @override
  State<ProviderDashboardPage> createState() => _ProviderState();
}

class _ProviderState extends State<ProviderDashboardPage> {
  double? myLat;
  double? myLng;

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchServices() async* {
    final activeTask = await FirebaseFirestore.instance
        .collection("Accepted Services")
        .where("acceptedBy", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("taskStatus", isEqualTo: "running")
        .get();

    if (activeTask.docs.isNotEmpty) {
      yield* FirebaseFirestore.instance
          .collection("Accepted Services")
          .where(
            "acceptedBy",
            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          .where("taskStatus", isEqualTo: "running")
          .snapshots();
    } else {
      yield* FirebaseFirestore.instance
          .collection("Accepted Services")
          .where("service", isEqualTo: widget.job)
          .where("isTaken", isEqualTo: false)
          .snapshots();
    }
  }

  Future<void> getMyLocation() async {
    final position = await GeoLocatorServices().getCurrentLocation();

    if (position != null) {
      setState(() {
        myLat = position.latitude;
        myLng = position.longitude;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyLocation();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Provider Dashboard"),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: fetchServices(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load services"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No Services to show !"));
          }
          if (myLat == null || myLng == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final availableServices = snapshot.data!.docs.toList();

          availableServices.sort((a, b) {
            final dataA = a.data();
            final dataB = b.data();

            final locA = dataA["Location"];
            final locB = dataB["Location"];
            if (locA is! Map || locB is! Map) return 0;

            double distA = Geolocator.distanceBetween(
              myLat!,
              myLng!,
              locA["latitude"],
              locA["longitude"],
            );

            double distB = Geolocator.distanceBetween(
              myLat!,
              myLng!,
              locB["latitude"],
              locB["longitude"],
            );

            return distA.compareTo(distB);
          });

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 14, 16, 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: theme.primary.withAlpha(22),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: theme.primary.withAlpha(70)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.primary,
                      child: const Icon(Icons.handyman, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, ${widget.providerName}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Available ${widget.job} jobs: ${availableServices.length}",
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: availableServices.length,
                  itemBuilder: (context, index) {
                    final docId = availableServices[index].id;
                    final data = availableServices[index].data();
                    final name = data["name"]?.toString() ?? "Unknown";
                    final phone = data["phone"]?.toString() ?? "-";
                    final photo = data["photo"]?.toString() ?? "";
                    final location = availableServices[index]
                        .data()["Location"];
                    if (location is! Map ||
                        location["latitude"] == null ||
                        location["longitude"] == null) {
                      return const SizedBox.shrink();
                    }
                    final double latitude = (location["latitude"] as num)
                        .toDouble();
                    final double longitude = (location["longitude"] as num)
                        .toDouble();
                    final dateTime = data["timestamp"];

                    double distance = Geolocator.distanceBetween(
                      myLat!,
                      myLng!,
                      latitude,
                      longitude,
                    );

                    double distanceInKm = distance / 1000;

                    return GestureDetector(
                      onTap: () async {
                        final providerId =
                            FirebaseAuth.instance.currentUser!.uid;

                        final activeTask = await FirebaseFirestore.instance
                            .collection("Accepted Services")
                            .where("acceptedBy", isEqualTo: providerId)
                            .where("taskStatus", isEqualTo: "running")
                            .get();

                        if (activeTask.docs.isNotEmpty) {
                          final runningDocId = activeTask.docs.first.id;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ActiveTaskPage(docId: runningDocId);
                              },
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ServiceDetailsPage(
                                providerName: widget.providerName,
                                docId: docId,
                                heroTag: docId,
                                photo: photo,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: theme.surface,
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
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Hero(
                                tag: docId,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: CachedNetworkImage(
                                    imageUrl: photo,
                                    fit: BoxFit.cover,
                                    height: 56,
                                    width: 56,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          height: 56,
                                          width: 56,
                                          color: theme.primary.withAlpha(30),
                                          child: const Icon(
                                            Icons.person_outline,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      phone,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.secondary.withAlpha(30),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "${distanceInKm.toStringAsFixed(2)} km away",
                                        style: TextStyle(
                                          color: theme.secondary,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Icon(Icons.schedule, size: 16),
                                  const SizedBox(height: 4),
                                  Text(
                                    dateTime is Timestamp
                                        ? _formatDateTime(dateTime)
                                        : "-",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                  const SizedBox(height: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: theme.primary,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDateTime(Timestamp ts) {
    final dt = ts.toDate().toLocal();
    final date =
        "${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
    final time =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    return "$date\n$time";
  }
}
