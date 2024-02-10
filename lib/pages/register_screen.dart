import 'package:daily_challenge/pages/encrypt_data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';



class RegisterScreen extends StatefulWidget {
  final Uri deepLink;
  const RegisterScreen({Key? key, required this.deepLink}):super(key: key);

  @override
State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final FocusNode myFocusNode1 = FocusNode();
  final FocusNode myFocusNode2 = FocusNode();    
  String decodedEmail = '';
  String decodedToken = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _tokenController = TextEditingController(); 
  
  int ind =0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _showAnimation = true;
  
  @override
  void initState() {
    parseDeepLink();
    _emailController.text = decodedEmail;
    _tokenController.text = decodedToken;

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

  @override
  void dispose() {
    myFocusNode1.dispose();
    myFocusNode2.dispose();
    super.dispose();
  }

  void parseDeepLink( ){
    Uri parsedUri = Uri.parse('${widget.deepLink}');
    String parsedData = parsedUri.queryParameters['id'].toString();
    String pattern = "?token=";
    int startIndex = parsedData.indexOf(pattern);
    
    if (startIndex != -1) {
      String parsedId = parsedData.substring(0, startIndex);
      String parsedToken = parsedData.substring(startIndex + pattern.length);
      final String encEmail = parsedId.replaceAll(' ', '+');
      final String encToken = parsedToken.replaceAll(' ', '+');

      final password1 = "1121S2131A131617";
      decodedEmail =  EncryptData.decryptAES(encEmail,password1);
      decodedToken =  EncryptData.decryptAES(encToken, password1);
      print(decodedEmail);
      print(decodedToken);
    } else {
      print("Desen bulunamadi.");
    }  
  }
  
 @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                      focusNode: myFocusNode1,
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: _tokenController,                   
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Token",
                      ),
                      validator: (value){
                        if(value== null || value.isEmpty){
                          return "Please Enter Your Token";
                        }
                        return null;
                      },
                      focusNode: myFocusNode2,
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                          },
                          child: Text("Register"),
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