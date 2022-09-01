import 'package:flutter/material.dart';

import '../../controllers/firestore_controller.dart';
import '../../utils/logger_service.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
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
