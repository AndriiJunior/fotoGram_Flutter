import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foto_gram/pages/register_page.dart';
import 'package:foto_gram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? _deviceWidth, _deviceHeight;
  FirebaseService? _firebaseService;

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  String? _email, _password;
  bool? _isHidden;
  @override
  void initState() {
    super.initState();
    _isHidden = true;

    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.indigo,
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GradientText("FotoGram",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 55,
                    ),
                    colors: [
                      Colors.black,
                      Colors.blue,
                      Colors.redAccent,
                      Colors.yellow,
                      Colors.white
                    ]),
                _loginForm(),
                _loginButton(),
                _registerPageLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return MaterialButton(
      onPressed: _loginUser,
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.red[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Text(
        "LOG IN",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailTextFild() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "Email...",
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.email_rounded,
          size: 40,
          color: Colors.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.white),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.greenAccent,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      // onChanged: ((value) => setState(() {
      //       _email = value;
      //     })),
      validator: (_value) {
        bool _result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return _result ? null : "Please enter a valid email";
      },
    );
  }

  Widget _passwordTextFild() {
    return TextFormField(
      obscureText: _isHidden!,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "Password...",
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.lock_person_rounded,
          size: 40,
          color: Colors.white,
        ),
        suffixIcon: IconButton(
          icon:
              _isHidden! ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
          color: Colors.white,
          onPressed: () {
            setState(() {
              _isHidden! ? _isHidden = false : _isHidden = true;
            });
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3, color: Colors.white),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 3,
            color: Colors.greenAccent,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      // onChanged: ((value) => setState(() {
      //       _password = value;
      //     })),
      validator: (_value) => _value!.length > 6
          ? null
          : "Please enter a password greater than 6 characters.",
    );
  }

  Widget _loginForm() {
    return Container(
      height: _deviceHeight! * 0.20,
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _emailTextFild(),
            _passwordTextFild(),
          ],
        ),
      ),
    );
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _firebaseService!
          .loginUser(email: _email!, password: _password!);
      print(_email);
      print(_password);
      print("result= $_result");

      if (_result) Navigator.popAndPushNamed(context, 'home');
    }
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: (() => Navigator.pushNamed(context, 'register')),
      child: Text(
        "Don't have an account?",
        style: TextStyle(
          color: Color.fromARGB(255, 231, 93, 139),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
