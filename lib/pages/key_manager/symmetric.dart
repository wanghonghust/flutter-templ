import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Symmetric extends StatelessWidget {
  const Symmetric({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: IconButton(
              onPressed: () => {
                Get.snackbar( 'Error', 'Not implemented yet',duration: const Duration(seconds: 1))
              },
              icon: const Icon(Icons.add_circle_outline_rounded))),
    );
  }
}
