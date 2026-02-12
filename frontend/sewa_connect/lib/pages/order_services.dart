import 'package:flutter/material.dart';

class OrderServicesPage extends StatefulWidget {
  const OrderServicesPage({super.key});

  @override
  State<OrderServicesPage> createState() => _OrderServicesPageState();
}

class _OrderServicesPageState extends State<OrderServicesPage> {
  List<String> service = ["Plumber","Electrician","Carpenter","Painter",];
  String? selectedService;
  
  @override
  Widget build(BuildContext context) {
    return
      // Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   centerTitle: true,
      //   title: Text('Order Services'),
      // ),
      // drawer: Drawer(),
      // body:
      Container(margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Select Your Order'),
            SizedBox(height: 20,),

            DropdownButtonFormField<String>(
              hint: Text('select Service type !'),
              value: selectedService,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              icon: Icon(Icons.arrow_drop_down),
              // decoration
              items: service.map((e) {
              return DropdownMenuItem<String>(
                  value: e,
                  child:Text(e),);
            },).toList(),
              onChanged:(value) {
              setState(() {
                selectedService = value ;
                print(selectedService);
              });
            }, )


            
          ],
        ),
      // ),
    );
  }
}
