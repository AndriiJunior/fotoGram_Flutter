import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foto_gram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  FirebaseService? _firebaseService;
  double? _deviceHeight, _deviceWidth;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight,
      width: _deviceWidth,
      child: _postListView(),
    );
  }

  Widget _postListView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseService!.getLatestPosts(),
        builder: (BuildContext _context, AsyncSnapshot _snapshot) {
          if (_snapshot.hasData) {
            List _posts = _snapshot.data!.docs.map((e) => e.data()).toList();
            print(_posts);
            return ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (BuildContext _context, int index) {
                Map _post = _posts[index];
                return Container(
                  height: _deviceHeight! * 0.30,
                  margin: EdgeInsets.symmetric(
                      vertical: _deviceWidth! * 0.02,
                      horizontal: _deviceHeight! * 0.02),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(
                        _post["image"],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
