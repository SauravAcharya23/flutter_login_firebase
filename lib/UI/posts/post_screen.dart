import 'package:fire_projects/UI/auth/login_screen.dart';
import 'package:fire_projects/UI/posts/add_posts.dart';
import 'package:fire_projects/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  final ref = FirebaseDatabase.instance.ref('Post');
  final searchController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Post'),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search..',
                border: OutlineInputBorder()
              ),
              onChanged: (String value) {
                setState(() {
                  
                });
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref, 
              defaultChild: const Text('Loading'),
              itemBuilder: (context, snapshot, animation, index) {

                final title = snapshot.child('title').value.toString();

                if(searchController.text.isEmpty){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              showMyDialog(title, snapshot.child('id').value.toString());
                            },
                            leading: const Icon(Icons.edit),
                            title: const Text('Edit'),
                          )
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              ref.child(snapshot.child('id').value.toString()).remove();
                            },
                            leading: const Icon(Icons.delete_outlined),
                            title: const Text('Delete'),
                          )
                        ),
                      ],
                    ),
                  );
                }else if(title.toLowerCase().contains(searchController.text.toLowerCase().toString())){
                  return ListTile(
                    title: Text(snapshot.child('title').value.toString()),
                    subtitle: Text(snapshot.child('id').value.toString()),
                  );
                }
                else{
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPostScreen(),));
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
              ref.child(id).update({
                'title':editController.text.toString()
              }).then((value){
                Utils().toastMessage('Post Updated');
              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
              });
            }, child: const Text('Update')),
          ],
        );
      },
    );
  }
}

/**
 * Expanded(
            child: StreamBuilder(
              stream: ref.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if(!snapshot.hasData){
                  return const CircularProgressIndicator();
                }
                else{
                  Map<dynamic, dynamic> map = snapshot.data!.snapshot.value as dynamic;
                  List<dynamic> list = [];
                  list.clear();
                  list = map.values.toList();

                  return ListView.builder(
                    itemCount: snapshot.data!.snapshot.children.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(list[index]['title']),
                        subtitle: Text(list[index]['id']),
                      );
                    },
                  );
                }
              },
            )
          ),
 */