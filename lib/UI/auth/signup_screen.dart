import 'package:fire_projects/UI/auth/login_screen.dart';
import 'package:fire_projects/utils/utils.dart';
import 'package:fire_projects/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      //helperText: 'enter email e.g. jon@gmail.com',
                      prefixIcon: Icon(Icons.alternate_email)
                    ),
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Enter Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      //helperText: 'enter email e.g. jon@gmail.com',
                      prefixIcon: Icon(Icons.password)
                    ),
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 50,),
                ],
              )
            ),
            
            RoundButton(title: 'Sign Up', loading: loading, onTap: (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  loading = true;
                });
                _auth.createUserWithEmailAndPassword(
                  email: emailController.text.toString(), 
                  password: passwordController.text.toString()
                ).then((value){
                  setState(() {
                    loading = false;
                  });
                }).onError((error, stackTrace){
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              }
            },),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),));
                }, child: const Text('Sign In'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}