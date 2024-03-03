import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/Pages/homePage.dart';
import 'package:noteapp/Pages/signPage.dart';

class LoginPageSecond extends StatefulWidget {
  const LoginPageSecond({Key? key}) : super(key: key);

  @override
  State<LoginPageSecond> createState() => _LoginPageSecondState();
}

class _LoginPageSecondState extends State<LoginPageSecond> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = "";
  String password = "";
  final  _key = GlobalKey<FormState>();
  // Go to Home Page
  void log(){
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User is Login...")));
  }
  void logIn() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
      if (userCredential.user != null) {
       log();
      }
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: h,
                  width: w,
                  decoration: const BoxDecoration(
                      color: Colors.white
                    // red.shade200
                  ),
                ),
                Positioned(
                    top: h*0.4,
                    child: Container(
                      height: h,
                      width: w,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                          color: Colors.brown.shade500
                      ),
                    )
                ),

                Positioned(
                  bottom: h*0.4,
                  top: h*0.26,
                  left: w*0.1,
                  right: w*0.1,
                  child: SizedBox(
                    height: h*0.8,
                    width: w*0.8,
                    child: Card(
                        elevation: 10,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Form(
                            key: _key,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: h*0.03,right: w*0.02,left: w*0.02),
                                  child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        label: const Text("Enter Your Email"),
                                        // hintText: "Enter Your Name",
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                    validator: (value) {
                                      if(value!.isEmpty) {
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
                                  padding: EdgeInsets.only(top: h*0.02,right: w*0.02,left: w*0.02),
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: true,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                        label: const Text("Enter Your Password"),
                                        // hintText: "Enter Your Password",
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                                        )
                                    ),
                                    validator: (value) {
                                      if(value!.isEmpty) {
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
                                SizedBox(
                                  height: h*0.02,
                                ),
                                ElevatedButton(
                                    onPressed: (){
                                      // try{
                                      //   logIn();
                                      //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage(),), (route) => route.isCurrent);
                                      // }on FirebaseAuthException catch(e){
                                      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
                                      // }
                                      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User is Login...")));
                                      if(_key.currentState!.validate()){
                                          logIn();
                                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User is Login...")));
                                      }
                                    },
                                    child: const Text("Login")),

                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ),

                Positioned(
                    bottom: h*0.3,
                    right: w*0.24,
                    child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    const Text("Create an Account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignInPage(),));
                      },
                      child: const Text("Sign",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                )),

              ],
            )
          ],
        ),
      ),
    );
  }
}
