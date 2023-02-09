// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class FirebaseDB extends StatefulWidget {
//   const FirebaseDB({super.key});

//   @override
//   State<FirebaseDB> createState() => _FirebaseDBState();
// }

// class _FirebaseDBState extends State<FirebaseDB> {

//   final emailController = TextEditingController();
//   final passwordController  = TextEditingController();

//   late DatabaseReference dbRef;
//   @override
//   void initState() {
//     super.initState();
//     dbRef = FirebaseDatabase.instance.ref().child('Users');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Add data to database')),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: emailController,
//             decoration: const InputDecoration( hintText: "email"),
//           ),
//            TextField(
//             controller: passwordController,
//             decoration: const InputDecoration( hintText: "password"),
//           ),
//           ElevatedButton(
//             onPressed: (){
//               Map<String, String> users = {
//                 'email':emailController.text,
//                 'password': passwordController.text
//               };
//               dbRef.push().set(users);
//             }, 
//             child: const Text('SignUp')
//           )
//         ],
//       ),
//     );
//   }
// }