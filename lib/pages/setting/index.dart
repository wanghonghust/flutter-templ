import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kms/preferences.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;

    return Scaffold(
      appBar: !isDesktop  ? AppBar(title: const Text("设置")):null,
      body: Center(
          child: ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
        children: [
          Card(
            color: Theme.of(context).cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    title: const Text('主题设置'),
                    subtitle: Row(children: [
                      Container(
                        width: 300,
                        child: SegmentedButton<ThemeMode>(
                          selected: {themeNotifier.themeMode},
                          segments: const <ButtonSegment<ThemeMode>>[
                            ButtonSegment<ThemeMode>(
                                value: ThemeMode.system,
                                label: Text('System'),
                                icon: Icon(Icons.contrast),
                                tooltip: "主题跟随系统"),
                            ButtonSegment<ThemeMode>(
                                value: ThemeMode.light,
                                label: Text('Light'),
                                icon: Icon(Icons.light_mode)),
                            ButtonSegment<ThemeMode>(
                                value: ThemeMode.dark,
                                label: Text('Dark'),
                                icon: Icon(Icons.dark_mode)),
                          ],
                          multiSelectionEnabled: false,
                          onSelectionChanged: (Set<ThemeMode> selected) {
                            themeNotifier.setTheme(selected.first);
                            // Get.snackbar("Hi", "I'm modern snackbar");
                          },
                        ),
                      ),
                      Expanded(child: Container())
                    ]))
              ],
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  title: Text('The Enchanted Nightingale'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.album),
                  title: Text('The Enchanted Nightingale'),
                  subtitle:
                      Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('BUY TICKETS'),
                      onPressed: () => {},
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('LISTEN'),
                      onPressed: () {
                        
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
          Card(
            color: Theme.of(context).cardColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const ListTile(
                  leading: Icon(Icons.album),
                  title: Text('The Enchanted Nightingale'),
                  subtitle:
                      Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('BUY TICKETS'),
                      onPressed: () => {},
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('LISTEN'),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
