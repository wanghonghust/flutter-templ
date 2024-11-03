import 'dart:io';

import 'package:draggable_home/draggable_home.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String videoFile = '';

  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      // leading: const Icon(Icons.arrow_back_ios),
      title: const Text("Draggable Home"),
      actions: const [],
      curvedBodyRadius: 0,
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        listView(),
        FutureBuilder<String>(
            future: Future.value(videoFile),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (videoFile.isNotEmpty && snapshot.data != null) {
                return BetterPlayer.file(snapshot.data!);
              } else {
                return const SizedBox();
              }
            },
          ),
        Text(videoFile),
        ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                File file = File(result.files.single.path!);
                setState(() {
                  videoFile = file.path;
                });
                
              } else {
                // User canceled the picker
              }
            },
            child: const Text("test"))
      ],
      fullyStretchable: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBarColor: Theme.of(context).appBarTheme.backgroundColor,
    );
  }

  Row headerBottomBarWidget() {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.settings,
          color: Colors.white,
        ),
      ],
    );
  }

  Widget headerWidget(BuildContext context) {
    return Container(
        color: Theme.of(context).appBarTheme.backgroundColor,
        padding: const EdgeInsets.all(10),
        child: const Center(
          child: SearchBar(
            trailing: <Widget>[Icon(Icons.search)],
          ),
        ));
  }

  ListView listView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 20,
      shrinkWrap: true,
      itemBuilder: (context, index) => Card(
        color: Theme.of(context).cardColor,
        child: ListTile(
          leading: CircleAvatar(
            child: Text("$index"),
          ),
          title: const Text("Title"),
          subtitle: const Text("Subtitle"),
          trailing: const Icon(Icons.next_plan),
        ),
      ),
    );
  }
}
