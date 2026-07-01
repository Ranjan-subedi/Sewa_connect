import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sewa_connect/services/database_services.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';

class RateServicePage extends StatefulWidget {
  final String orderId;

  const RateServicePage({super.key, required this.orderId});

  @override
  State<RateServicePage> createState() => _RateServicePageState();
}

class _RateServicePageState extends State<RateServicePage> {
  int _rating = 0;
  final _reviewController = TextEditingController();
  bool _submitting = false;
  Map<String, dynamic>? _orderData;

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _loadOrder() async {
    final snap = await FirebaseFirestore.instance
        .collection("Orders")
        .doc(widget.orderId)
        .get();

    if (!mounted) return;

    if (!snap.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Order not found")),
      );
      Navigator.pop(context);
      return;
    }

    final data = snap.data()!;
    if (data["isReviewed"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already rated this service")),
      );
      Navigator.pop(context);
      return;
    }

    setState(() => _orderData = data);
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a star rating")),
      );
      return;
    }

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null || _orderData == null) return;

    setState(() => _submitting = true);

    try {
      final email = await SharedPreferencesHelper().getEmail() ?? "";
      await DatabaseServices().submitReview(
        orderId: widget.orderId,
        userId: userId,
        email: email,
        providerRef: _orderData!["providerRef"]?.toString() ?? "",
        providerName:
            _orderData!["acceptedByName"]?.toString() ??
            _orderData!["name"]?.toString() ??
            "Provider",
        service: _orderData!["service"]?.toString() ?? "",
        rating: _rating,
        review: _reviewController.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Thank you for your feedback!")),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    if (_orderData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Rate Service"),
          backgroundColor: theme.primary,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final providerName =
        _orderData!["acceptedByName"]?.toString() ??
        _orderData!["name"]?.toString() ??
        "Provider";
    final serviceName = _orderData!["service"]?.toString() ?? "Service";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Service"),
        centerTitle: true,
        backgroundColor: theme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primary.withAlpha(22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.primary.withAlpha(70)),
              ),
              child: Column(
                children: [
                  Icon(Icons.star_rate_rounded, size: 48, color: theme.primary),
                  const SizedBox(height: 8),
                  Text(
                    "How was your experience?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$providerName · $serviceName",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Your rating",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final star = index + 1;
                return IconButton(
                  iconSize: 40,
                  onPressed: () => setState(() => _rating = star),
                  icon: Icon(
                    star <= _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Text(
              "Write a review (optional)",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reviewController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: "Share your experience with this provider...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitting ? null : _submitReview,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Submit Review",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
