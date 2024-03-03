import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/Pages/homePage.dart';
import 'package:noteapp/Pages/loginPage.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController conformPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String email = "";
  String password = "";
  String name = "";
  String conformPassword = "";
  String uid = " ";
  void sign(){
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User is Created...")));
  }
  void sigIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      setState(() {
        uid = FirebaseAuth.instance.currentUser!.uid.toString();
      });
      if (userCredential.user != null) {
        FirebaseFirestore.instance.collection("User").doc(uid).collection("UserValue").doc(uid).set({
          "Name": nameController.text.trim(),
          "Email": emailController.text.trim(),
          "Password": passwordController.text.trim()
        });
        sign();
      }
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }
  final  _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Sign Page"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: h * 0.03, right: w * 0.02, left: w * 0.02),
                      child: TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: const Text("Enter Your Name"),
                            // hintText: "Enter Your Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Name...";
                          }
                          return null;
                        },
                        onSaved: (value){
                          setState(() {
                            name = value.toString();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: h * 0.03, right: w * 0.02, left: w * 0.02),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: const Text("Enter Your Email"),
                            // hintText: "Enter Your Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Email...";
                          }
                          return null;
                        },
                        onSaved: (value){
                          setState(() {
                            email = value!.trim().toString();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: h * 0.02, right: w * 0.02, left: w * 0.02),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                            label: const Text("Enter Your Password"),
                            // hintText: "Enter Your Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Password...";
                          }
                          return null;
                        },
                        onSaved: (value){
                          setState(() {
                            password = value!.trim().toString();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: h * 0.03, right: w * 0.02, left: w * 0.02),
                      child: TextFormField(
                        obscureText: true,
                        controller: conformPasswordController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            label: const Text("Enter Your Conform Password"),
                            // hintText: "Enter Your Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Conform Password...";
                          }
                          return null;
                        },
                        onSaved: (value){
                          setState(() {
                            conformPassword = value!.trim().toString();
                          });

                        },
                      ),
                    ),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    ElevatedButton(
                        onPressed: () {
                            sigIn();
                            // Navigator.popUntil(context, (route) => route.isFirst);
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
                            // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User is Created...")));
                        },
                        child: const Text("Sign")),
                    SizedBox(
                      height: h * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already Have an Account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPageSecond(),));
                            //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User is Created...")));
                          },
                          child: const Text("Login",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
