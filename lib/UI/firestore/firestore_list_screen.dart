import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_projects/UI/firestore/add_firestore_data.dart';
import 'package:flutter/material.dart';
import 'package:fire_projects/UI/auth/login_screen.dart';
import 'package:fire_projects/UI/posts/add_posts.dart';
import 'package:fire_projects/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final auth = FirebaseAuth.instance;
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();

  CollectionReference ref = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Firestore'),
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
      body: Column(
        children: [
          const SizedBox(height: 10,),
          StreamBuilder<QuerySnapshot>(
            stream: fireStore,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const CircularProgressIndicator();
              }
              if(snapshot.hasError){
                return const Text('Some Error');
              }
              
              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        ref.doc(snapshot.data!.docs[index]['id'].toString()).update({
                          'title':'Bye'
                        }).then((value){
                          Utils().toastMessage('Updated');
                        }).onError((error, stackTrace){
                          Utils().toastMessage(error.toString());
                        });
                      },
                      title: Text(snapshot.data!.docs[index]['title'].toString()),
                      subtitle: Text(snapshot.data!.docs[index]['id'].toString()),
                    );
                  },
                )
              );
            },
          ),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFirestoreDataScreen(),));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  
  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: const Text('Update'),
          content: Container(
            child: TextField(
              controller: editController,
              decoration: const InputDecoration(
                hintText: 'Edit'
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            }, child: const Text('Cancel')),

            TextButton(onPressed: (){
              Navigator.pop(context);
              
            }, child: const Text('Update')),
          ],
        );
      },
    );
  }
}