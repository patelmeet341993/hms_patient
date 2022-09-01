import 'package:flutter/material.dart';

import '../../controllers/firestore_controller.dart';
import '../../utils/logger_service.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home Screen"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Login Body"),
              FlatButton(
                onPressed: () {
                  FirestoreController().firestore.collection("temp").add({"dfgh" : "drdfgh"}).then((value) {
                    Log().i("Document Created:${value.id}");
                  });
                },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
