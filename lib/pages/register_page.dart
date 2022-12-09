import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:foto_gram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  double? _deviceHeight, _deviceWidth;
  FirebaseService? _firebaseService;
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  String? _name, _email, _password;
  bool? _isHidden;
  File? _image;
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
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.05),
          color: Colors.indigo,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              //crossAxisAlignment: CrossAxisAlignment.center,
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
                _registrationForm(),
                _registerButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return MaterialButton(
      onPressed: () => _registerUser(),
      minWidth: _deviceWidth! * 0.70,
      height: _deviceHeight! * 0.06,
      color: Colors.red[400],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Text(
        "REGISTRE",
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _registerUser() async {
    if (_registrationFormKey.currentState!.validate() && _image != null) {
      _registrationFormKey.currentState!.save();
      print(
          "${_registrationFormKey.currentState}, name = $_name, email=$_email, pass=$_password, img=$_image");
      bool _resolt = await _firebaseService!.registerUser(
          name: _name!, email: _email!, password: _password!, image: _image!);
      print(_resolt);
      if (_resolt) Navigator.popAndPushNamed(context, 'home');
    }
  }

  Widget _registrationForm() {
    return Container(
      // height: _deviceHeight! * 0.30,
      child: Form(
        key: _registrationFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImageWidget(),
            _nameTextField(),
            SizedBox(height: 10.0),
            _emailTextFild(),
            SizedBox(height: 10.0),
            _passwordTextFild(),
          ],
        ),
      ),
    );
  }

  Widget _profileImageWidget() {
    var imageProvider = _image != null
        ? FileImage(_image!)
        : NetworkImage(
            "https://cdn1.iconfinder.com/data/icons/rounded-black-basic-ui/139/Photo_Add-RoundedBlack-512.png");
    // "https://images.theconversation.com/files/90015/original/image-20150729-30889-ri221u.jpg?ixlib=rb-1.1.0&q=45&auto=format&w=1200&h=1200.0&fit=crop");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((result) {
          setState(() {
            _image = File(result!.files.first.path!);
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 30.0),
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider as ImageProvider,
          ),
          shape: BoxShape.circle,
          border: Border.all(width: 5, color: Colors.red),
        ),
      ),
    );
  }

  Widget _nameTextField() {
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: "Name...",
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: Icon(
          Icons.person_rounded,
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
      validator: (value) => value!.length > 0 ? null : "Please enter your name",
      onSaved: (value) {
        setState(() {
          _name = value;
        });
      },
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
      onSaved: (value) {
        setState(() {
          _email = value;
        });
      },
      validator: (value) {
        bool result = value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : "Please enter a valid email";
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
      onSaved: (value) {
        setState(() {
          _password = value;
        });
      },
      validator: (value) => value!.length > 6
          ? null
          : "Please enter a password greater than 6 characters.",
    );
  }
}
