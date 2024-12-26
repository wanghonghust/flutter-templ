import 'package:flutter/material.dart';
import 'package:kms/widget/custom_tab/index.dart';
import 'package:kms/widget/tab_bar/inde.dart';
import 'package:kms/widget/tab_container/index.dart';

class ApiKeyPage extends StatefulWidget {
  const ApiKeyPage({super.key, required this.title});
  final String title;

  @override
  State<ApiKeyPage> createState() => _ApiKeyPageState();
}

class _ApiKeyPageState extends State<ApiKeyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: TabContainer(
              color: Colors.white,
              tabMinLength: 10,
              tabs: [
                Text('Button 1'),
                Text('Button 1'),
                Text('Button 1'),
                Text('Button 1'),
                Text('Button 1'),
              ],
              children: [
                Text('Button 1'),
                Text('Button 2'),
                Text('Button 3'),
                Text('Button 4'),
                Text('Button 5'),
              ],
            ),
          ),
          SimpleContainer(
              width: 400,
              height: 200,
              alignment: Alignment.center,
              backgroundColor: const Color.fromARGB(255, 243, 234, 234),
              hoverColor: const Color.fromARGB(255, 149, 190, 243),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: CustomButtonContainer(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 2'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Button 3'),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text('Button 4'),
                  // ),
                  // ElevatedButton(
                  //   onPressed: () {},
                  //   child: Text('Button 5'),
                  // )
                ],
              )),
          ElevatedButton(
            onPressed: () {},
            child: Text('Button 4'),
          ),
        ],
      ),
      // body: const MarkdownEditorPage(),
    );
  }
}
