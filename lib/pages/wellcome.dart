import 'package:daily_challenge/pages/encrypt_data.dart';
import 'package:daily_challenge/pages/google_auth_api.dart';
import 'package:daily_challenge/pages/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:random_string/random_string.dart';


class Welcome extends StatefulWidget {
  const Welcome({super.key});
  @override
  State<Welcome> createState() => _WelcomeState();
}
class _WelcomeState extends State<Welcome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> tokenList = [];
  String? registerToken;

  void _deleteAccount() async {
    try {
      await _auth.currentUser!.delete();
      _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Delete Account: $e"),
        ),
      );
    }
  }

  Future sendEmail() async{

    registerToken = randomAlphaNumeric(6);
    setState(() {
      tokenList.add(registerToken!);
    });
    int listLength = tokenList.length;
    print("tokenList uzunluğu: $listLength");
    final password2 = "1121S2131A131617";
    String encryptedEmail = EncryptData.encryptAES(_auth.currentUser!.email!, password2);
    String encryptedToken = EncryptData.encryptAES(registerToken!, password2);

    // GoogleAuthApi.signOut();
    // return;

    final user = await GoogleAuthApi.signIn();

    if(user==null) return;

    final email = user.email;
    final auth = await user.authentication;
    final token =auth.accessToken!;
    GoogleAuthApi.signOut();

    String baseUrl = 'https://berkertoker.000webhostapp.com/data/';
    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, 'Berker' )
      ..recipients= ['berkertoker2001@gmail.com'] 
      ..subject = 'Hello Berker'
      ..html = '''
          <p>This is a Text Email with a TokenListLength: $listLength  Id $encryptedEmail   Token $encryptedToken <a href="$baseUrl?id=$encryptedEmail?token=$encryptedToken">link</a>.</p>
      ''';
    
    
    try{
      await send(message, smtpServer);

      showSnackBar("Sent email succesfully");
    }on MailerException catch (e){
      print(e);
    }
  }
  
  void showSnackBar(String text){
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }


  @override
  Widget build(BuildContext context) {
    String _email = _auth.currentUser!.email!;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login In With:\n$_email",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed:(){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Log Out"),
                  ],
                ),           
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: sendEmail,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Sen an Email"),
                  ],
                ),           
              ),
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _deleteAccount,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete),
                    SizedBox(width: 8),
                    Text("Deletece Account"), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}