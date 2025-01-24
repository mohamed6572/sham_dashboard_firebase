import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sham/admin/add_post_screen.dart';
import 'package:sham/admin/widget/admin_layout.dart';
import 'package:sham/core/consttant/const.dart';
import 'package:sham/core/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
bool isloading = false;

  void _login() async{
    try{
     setState(() {
       isloading = true;
     });
      final responce = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      if (responce.user != null) {
      setState(() {
        isloading = false;
      });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminLayout()));
      }
    }catch(e){
     setState(() {
       isloading = false;
     });
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid email or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              CustomTextFormField(hintText: 'email', textInputType: TextInputType.emailAddress,controller: emailController,),
              const SizedBox(height: 20),
              CustomTextFormField(hintText: 'password', textInputType: TextInputType.visiblePassword,controller: passwordController,),
              const SizedBox(height: 20),
            isloading?CircularProgressIndicator():  ElevatedButton(
                style: ElevatedButton.styleFrom(

                 backgroundColor: primaryColor
                ),
                onPressed: _login,

                child: const Text('Login',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
