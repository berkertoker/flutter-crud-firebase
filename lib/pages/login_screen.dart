import 'package:daily_challenge/pages/admin_screen.dart';
import 'package:daily_challenge/pages/signup_screen.dart';
import 'package:daily_challenge/pages/wellcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode myFocusNode1 = FocusNode();
  final FocusNode myFocusNode2 = FocusNode();
  
  int ind =0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  
  String _email = "";
  String _password ="";
  bool _showAnimation = true;
  @override
  void initState() {
    super.initState();
    myFocusNode1.addListener(() {
      if (!myFocusNode1.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _showAnimation = true;
          });
        });
      }else if (myFocusNode1.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _showAnimation = false;
          });
        });
      }
    });
    myFocusNode2.addListener(() {
      if (!myFocusNode2.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _showAnimation = true;
          });
        });
      }else if (myFocusNode2.hasFocus) {
        Future.delayed(const Duration(milliseconds: 100), () {
          setState(() {
            _showAnimation = false;
          });
        });
      }
    });
  }
  void _handleLogin() async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: _email,
      password: _password,
    );
    print("User Logged In: ${userCredential.user!.email}");
    if(_email=='admin@gmail.com' || _email=='superadmin@gmail.com' ){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Admin(),
        ),
      );    
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Welcome(),
        ),
      );  
    }    
  } catch (e) {   
    String errorMessage = "Invalid email or password.";
    print("Error During Logged In: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
      ),
    );
  }
}
  @override
  void dispose() {
    myFocusNode1.dispose();
    myFocusNode2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
          child: Padding(
            padding:EdgeInsets.all(16),
            child: Form(
              key:_formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [  
                    SizedBox(height: 50),      
                    _showAnimation
                      ? Lottie.asset(
                        'assets/loginLottie.json',
                        
                        height: 240,
                        reverse: true,
                        repeat: false,
                        fit: BoxFit.cover,
                      )                     
                      : SizedBox(),  
                    SizedBox(height:30),                            
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                      validator: (value){
                        if(value== null || value.isEmpty){
                          return "Please Enter Your Email";
                        }
                        return null;
                      },
                      onChanged: (value){
                        setState(() {
                          _email = value;
                        });
                      },
                      focusNode: myFocusNode1,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Password",
                      ),
                      validator: (value){
                        if(value== null || value.isEmpty){
                          return "Please Enter Your Password";
                        }
                        return null;
                      },
                      onChanged: (value){
                        setState(() {
                          _password = value;
                        });
                      },
                      focusNode: myFocusNode2,
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _handleLogin();
                            }
                          },
                          child: Text("Login"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                
                                FocusScope.of(context).unfocus();
                                Future.delayed(const Duration(milliseconds: 100), () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                                  );                           
                                });                                                            
                              },
                              child: Text("Sign up"),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
              ),
            ),        
          ),
      ),    
    );
  }
}