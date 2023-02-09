import 'package:fire_projects/UI/auth/signup_screen.dart';
import 'package:fire_projects/UI/forgot_password.dart';
import 'package:fire_projects/UI/posts/post_screen.dart';
import 'package:fire_projects/utils/utils.dart';
import 'package:fire_projects/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void login(){
    setState(() {
      loading = true;
    });
    _auth.signInWithEmailAndPassword(
      email: emailController.text.toString(), 
      password: passwordController.text.toString()
    ).then((value){
      Utils().toastMessage(value.user!.email.toString());
      Navigator.push(context, MaterialPageRoute(builder: (context) => const PostScreen(),));
      setState(() {
        loading = false;
      });
    }).
    onError((error, stackTrace){
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Login'), automaticallyImplyLeading: false,),
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
              
              RoundButton(title: 'Login',loading: loading, onTap: (){
                if(_formKey.currentState!.validate()){
                  login();
                }
              },),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen(),));
                }, child: const Text('Forget Password?')),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupScreen(),));
                  }, child: const Text('Sign Up'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}