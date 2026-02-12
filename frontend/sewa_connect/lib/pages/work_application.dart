import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sewa_connect/services/sharedpreferences.dart';

class WorkApplicationPage extends StatefulWidget {
  const WorkApplicationPage({super.key});

  @override
  State<WorkApplicationPage> createState() => _WorkApplicationPageState();
}

class _WorkApplicationPageState extends State<WorkApplicationPage> {
  File? image;
  bool isUploading = false;

  getSharedImage()async{
    final imagePath = await SharedPreferencesHelper().getimage();
    if(imagePath != null){
      image = File(imagePath);
      setState(() {

      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharedImage();
  }

  final imagepicker = ImagePicker();

  Future<void> getImage()async{
    setState(() {
      isUploading = true;
    });

    try{
      final pickedImage = await imagepicker.pickImage(source: ImageSource.camera);

      if(pickedImage != null){
        image = File(pickedImage.path);
        await SharedPreferencesHelper().saveimage(imagePath: image!.path);
      }
    }catch(e){
      print(e);
    }finally{
      setState(() {
        isUploading = false;
      });
    }
  }

  List<String> selectjob  = ["plumber", "Electrician",];
  String? currentjobselected;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              
            }, icon: Icon(Icons.file_upload))
          ],
        title: Text("Work Application"),
          backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(12),
          decoration: BoxDecoration(
          ),
          child: Column(
            children: [
              DottedBorder(
                options: RoundedRectDottedBorderOptions(
                  radius: Radius.circular(8),
                  dashPattern: [6,8 ],
                  gradient: LinearGradient(
                      begin: AlignmentGeometry.bottomCenter,
                      colors: [
                    Colors.red,
                    Colors.blue,
                    Colors.orange,
                    Colors.green,
                    Colors.red
                  ]),

                  color: Theme.of(context).colorScheme.primary,
                  strokeWidth: 2,
                ),
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white38,
                  ),
                  child:isUploading ? Center(
                    child: Lottie.asset("assets/lottie/LoadingElephant.json", fit: BoxFit.cover),
                  ) : image==null ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: () {
                        getImage() ;
                      }, icon: Icon(Icons.upload,size: 70, color: Theme.of(context).colorScheme.primary,)),
                      SizedBox(height: 10,),
                      Text("Upload Image here", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20),)
                    ],
                  ) : Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          left: 0,
                          child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: Image.file(image!, fit: BoxFit.cover,)),
                        ),
                        Align(
                            alignment: Alignment.topRight,
                            child: IconButton(onPressed: () => getImage(), icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary,))),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Text('Calling Name'),
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Tyre Kanxa",
                  labelText: "Enter your famous name",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.white38,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20,),

              Text('Phone Number'),
              TextField(
                decoration: InputDecoration(
                  hintText: "9800000000",
                  labelText: "Your working number",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: Colors.white38,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20,),
              
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "select you prefer Job",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),

                  ),
                  filled: true,
                  fillColor: Colors.white38,
                ),
                  value: currentjobselected,
                  items: selectjob.map((e) {
                    return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e));
                  },).toList(),

                  onChanged: (value) {
                    setState(() {
                      currentjobselected = value;
                    });
                  },),
              
              SizedBox(height: 20,),

              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                    color: Colors.white38
                ),
                child: Stack(
                  children: [
                    Text(' Citizenship Card(front)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Lottie.asset('assets/lottie/loadingHand.json', fit: BoxFit.cover, height: 320)),
                  ],
                ),
              ),
        
              SizedBox(height: 20,),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white38
                ),
                child: Stack(
                  children: [
              Text(' Citizenship Card(back)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Lottie.asset('assets/lottie/loadingHand.json', fit: BoxFit.cover, height: 320)),
                  ],
                ),
              ),
        
        
              SizedBox(height: 20,),
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white38
                ),
                child: Stack(
                  children: [
              Text(' Citizenship Card(front)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Lottie.asset('assets/lottie/loadingHand.json', fit: BoxFit.cover, height: 320)),
                  ],
                ),
              ),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}
