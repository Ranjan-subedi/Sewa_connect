import 'package:flutter/material.dart';
import 'package:sewa_connect/services/database_services.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderServicesPage extends StatefulWidget {
  final String name;
  final String photo;

  const OrderServicesPage({
    super.key,
    required this.name,
    required this.photo,
  });

  @override
  State<OrderServicesPage> createState() => _OrderServicesState();
}

class _OrderServicesState extends State<OrderServicesPage> {

  Future<void> makePhoneCall(String phoneNumber)async{
    final Uri url = Uri(scheme: "tel" , path: phoneNumber);

    try{
      if(await canLaunchUrl(url)){
        await launchUrl(url);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot make phone call")),
        );
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error on launching phone call")),
      );
    }


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
                    errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, size: 70),
                  ),
                ),
              ),

              SizedBox(height: 20,),

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
                      Row(
                        children: [
                          // Display stars
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "5",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "${widget.name} is very professional and completes work on time. Highly recommended!",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        DatabaseServices().setOrder(data: {
                          "name": widget.name,
                          "phone": "9864388822",
                          "address": "Pokhara",
                          "email": "email@gmail.com",
                          "photo": widget.photo,
                          "timestamp": DateTime.now(),
                        });
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Book Service"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(12))
                      ),
                    ),
                  ),
                ],
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
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
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