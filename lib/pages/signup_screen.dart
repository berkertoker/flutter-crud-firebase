import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  final FocusNode myFocusNode1 = FocusNode();
  final FocusNode myFocusNode2 = FocusNode();
  String _email = "";
  String _password = "";
  bool _showSuccessMessage = false;
  bool _showErrorMessage = false;
  bool _showAnimation = true;
  String? _errorMessage;
  int ind=0;
  @override
  void initState() {
    super.initState();
    myFocusNode1.addListener(() {
      if (!myFocusNode1.hasFocus && ind !=1) {
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            _showAnimation = true;
          });
        });
      }else if (myFocusNode1.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            ind = 0;
            _showAnimation = false;
            _showSuccessMessage = false;
            _showErrorMessage = false;
          });
        });
      }
    });
    myFocusNode2.addListener(() {

      if (!myFocusNode2.hasFocus && ind !=1) {
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            _showAnimation = true;
          });
        });
      }else if (myFocusNode2.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          setState(() {
            ind = 0;
            _showAnimation = false;
            _showSuccessMessage = false;
            _showErrorMessage = false;
          });
        });
      }
    });
  }

  void _handleSignUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      ind = 1;
      setState(() {
        FocusScope.of(context).unfocus();
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {
          FocusScope.of(context).unfocus();
          _showAnimation = false;
          _showSuccessMessage = true;
        });
      });

      _emailController.clear();
      _passController.clear();
      print("User Registered: ${userCredential.user!.email}");
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
      ind = 1;
      setState(() {
        FocusScope.of(context).unfocus();
      });
      Future.delayed(const Duration(milliseconds: 150), () {
        setState(() {       
          _showAnimation = false;
          _showErrorMessage = true;
          
        });
      });
      print("Error During Registration: $e");
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
        title: Text("Sign Up"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    _showSuccessMessage
                      ? Column(
                        children: [
                          Lottie.asset(
                            'assets/animation_lmuhw2u7.json',                       
                            height: 180,
                            reverse: true,
                            repeat: false,
                            fit: BoxFit.cover,
                          ),
                          Text('Congratulations, your account has been successfully created.',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )                     
                      : SizedBox(),
                    _showErrorMessage
                      ? Column(
                        children: [
                          Lottie.asset(
                            'assets/animation_lmuhxg1y.json',                       
                            height: 110,
                            reverse: true,
                            repeat: false,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10,),
                          Text('Account Creation Failed',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,          
                          ),
                        ],
                      )                     
                      : SizedBox(),   
                    _showAnimation
                      ? Lottie.asset(
                        'assets/animation_lmuk19hl.json',                      
                        height: 200,
                        reverse: true,
                        repeat: false,
                        fit: BoxFit.cover,
                      )                     
                      : SizedBox(), 
                  ],
                ),                
                SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    errorText: _errorMessage,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Email";
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                      _errorMessage = null;
                    });
                  },
                  focusNode: myFocusNode1,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please Enter Your Password";
                    }
                    final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
                    final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
                    final hasDigits = RegExp(r'[0-9]').hasMatch(value);
                    final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
                    
                    if (!hasUppercase) {
                      return "Password must contain at least one uppercase letter.";
                    }
                    if (!hasLowercase) {
                      return "Password must contain at least one lowercase letter.";
                    }
                    if (!hasDigits) {
                      return "Password must contain at least one digit.";
                    }
                    if (!hasSpecialCharacters) {
                      return "Password must contain at least one special character.";
                    }
                    return null;
                  },
                  onChanged: (value) {
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
                          _handleSignUp();
                        }
                      },
                      child: Text("Sign Up"),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Do you have an account?"),
                        TextButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            Future.delayed(const Duration(milliseconds: 100), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginScreen()),
                              );                           
                            });
                          },
                          child: Text("Login"),
                        ),
                      ],
                    ),
                  ],
                ),        
              ],
            ),
          ),
        ),
      ),
    );
  }
}