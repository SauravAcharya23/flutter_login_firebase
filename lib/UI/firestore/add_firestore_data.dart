import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_projects/utils/utils.dart';
import 'package:fire_projects/widgets/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddFirestoreDataScreen extends StatefulWidget {
  const AddFirestoreDataScreen({super.key});

  @override
  State<AddFirestoreDataScreen> createState() => _AddFirestoreDataScreenState();
}

class _AddFirestoreDataScreenState extends State<AddFirestoreDataScreen> {

  final postController = TextEditingController();
  bool loading = false;
  final fireStore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add firestoere data')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30,),

            TextFormField(
              maxLines: 4,
              controller: postController,
              decoration: const InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30,),

            RoundButton(
              title: 'Add',
              loading: loading, 
              onTap: (){
                setState(() {
                  loading = true;
                });

                String id = DateTime.now().millisecondsSinceEpoch.toString();

                fireStore.doc(id).set({
                  'title': postController.text.toString(),
                  'id': id
                }).then((value){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Post Added');
                }).onError((error, stackTrace){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              }
            )
          ],
        ),
      ),
    );
  }
}