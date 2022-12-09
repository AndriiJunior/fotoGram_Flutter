import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foto_gram/services/firebase_service.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      padding: EdgeInsets.symmetric(
          horizontal: _deviceHeight! * 0.05, vertical: _deviceHeight! * 0.05),
      // height: _deviceHeight,
      // width: _deviceWidth,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _profileImage(),
          Divider(
            height: 40,
            thickness: 10,
            color: Colors.red,
          ),
          _postGridView(),
        ],
      ),
    );
  }

  Widget _profileImage() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: _deviceHeight! * 0.02),
        height: _deviceHeight! * 0.15,
        width: _deviceWidth! * 0.5,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(_firebaseService!.currentUser!['image']),
            fit: BoxFit.contain,
          ),
          shape: BoxShape.circle,
          border: Border.all(width: 5, color: Colors.red),
        ),
      ),
    );
  }

  Widget _postGridView() {
    return Expanded(
        child: StreamBuilder<QuerySnapshot>(
      stream: _firebaseService!.getPostsForUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List _posts = snapshot.data!.docs.map((e) => e.data()).toList();
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 15,
              ),
              itemCount: _posts.length,
              itemBuilder: ((context, index) {
                Map _post = _posts[index];
                return Container(
                  //margin: EdgeInsets.only(right: 10, bottom: 15),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_post['image']),
                    ),
                    border: Border.all(width: 3, color: Colors.yellow),
                  ),
                );
              }));
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    ));
  }
}
