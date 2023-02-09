import 'dart:io';

import 'package:fire_projects/utils/utils.dart';
import 'package:fire_projects/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'auth/login_screen.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {

  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  final auth = FirebaseAuth.instance;

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

  Future getImagegallary() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, );

    setState(() {
      if(pickedFile != null){
        _image = File(pickedFile.path);
      }else{
        print('No Image Picked');
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Upload Image'),
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: const Icon(Icons.logout_rounded)),
          const SizedBox(width: 10,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: (){
                  getImagegallary();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: _image != null ? Image.file(_image!.absolute) : const Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(height: 30,),
            RoundButton(title: 'Upload',loading: loading, onTap: () async{
              setState(() {
                loading = true;
              });
              firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/image/'+DateTime.now().millisecondsSinceEpoch.toString());

              firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

              Future.value(uploadTask).then((value)async{
                var newUrl = await ref.getDownloadURL();

                databaseRef.child('1').set({
                  'id':'121212',
                  'title': newUrl.toString()
                }).then((value){

                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Uploaded');
                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              }).onError((error, stackTrace){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(error.toString());
              });
              

              

            })
          ],
        ),
      ),
    );
  }
}