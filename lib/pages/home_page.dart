import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:foto_gram/pages/feed_page.dart';
import 'package:foto_gram/pages/profile_page.dart';
import 'package:foto_gram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseService? _firebaseService;
  int _currentPage = 0;
  List<Widget> _pages = [
    FeedPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: GradientText("FotoGram",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
              colors: [
                Colors.black,
                Colors.blue,
                Colors.redAccent,
                Colors.yellow,
                Colors.white
              ]),
        ),
        actions: [
          GestureDetector(
            onTap: _postImage,
            child: Icon(Icons.add_a_photo_rounded),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: (() async {
                await _firebaseService!.logout();
                Navigator.popAndPushNamed(context, 'login');
              }),
              child: Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _pages[_currentPage],
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
        selectedItemColor: Colors.red,
        backgroundColor: Colors.indigo,
        iconSize: 40,
        currentIndex: _currentPage,
        onTap: (_int) {
          setState(() {
            _currentPage = _int;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: "Feed",
            icon: Icon(
              Icons.feed_rounded,
            ),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(
              Icons.account_circle,
            ),
          ),
        ]);
  }

  void _postImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File _image = File(_result!.files.first.path!);
    await _firebaseService!.postImage(_image);
  }
}
