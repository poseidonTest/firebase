import 'package:flutter/material.dart';
import 'package:my_karaoke/widgets/error_dialog.dart';
import '../shared/authentication.dart';
import 'event_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String? _userId;
  String? _message = "";
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  late Authentication auth;

  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Container(
          padding: EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              child: Column(
                children: <Widget>[
                  emailInput(),
                  passwordInput(),
                  mainButton(),
                  secondaryButton(),
                  validationMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 120),
        child: TextFormField(
          controller: txtEmail,
          keyboardType: TextInputType.emailAddress,
          decoration:
              InputDecoration(hintText: 'email', icon: Icon(Icons.mail)),
          validator: (text) => text!.isEmpty ? 'Email is required' : null,
        ));
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 50),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration: InputDecoration(
              hintText: 'password', icon: Icon(Icons.enhanced_encryption)),
          validator: (text) => text!.isEmpty ? 'Password is required' : null,
        ));
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
        padding: EdgeInsets.only(top: 80),
        child: Container(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 3),
              child: Text(buttonText),
              onPressed: submit,
            )));
  }

  Future submit() async {
    setState(() {
      _message = "";
    });
    try {
      if (_isLogin) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
        print('Login for user $_userId');
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPassword.text);
        print('Sign up for user $_userId');
      }
      if (_userId != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventScreen(
                      uid: _userId!,
                    )));
      }
    } catch (e) {
      print('Error: $e');
      errorDialog(context, (e as Exception));
      setState(() {
        // _message = e.message;
        _message = e.toString();
      });
    }
  }

  Widget secondaryButton() {
    String buttonText = !_isLogin ? 'Login' : 'Sign up';
    return TextButton(
      child: Text(buttonText),
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
    );
  }

  Widget validationMessage() {
    return Text(
      _message!,
      style: TextStyle(
          fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
    );
  }
}
