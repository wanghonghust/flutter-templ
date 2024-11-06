import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isSmallScreen = false;
  @override
  Widget build(BuildContext context) {
    isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: !isSmallScreen
          ? AppBar(
              title: const Text('Login Page'),
            )
          : null,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const Text('Login Page'),
            ElevatedButton(onPressed: () {}, child: const Text('Login'))
          ],
        ),
      ),
    );
  }
}
