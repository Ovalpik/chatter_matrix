import 'dart:async';

import 'package:chatter/logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/Chat/menu_chats.dart';
import 'package:chatter/login.dart';
import 'package:chatter/settings/settings_chat.dart';
import 'package:chatter/castomization.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class SettingsMenu extends StatefulWidget {
  const SettingsMenu({super.key});

  @override
  State<SettingsMenu> createState() => _SettingsMenuState();
}

class _SettingsMenuState extends State<SettingsMenu> {
  String? _avatarUrl;
  String? _displayName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final client = Provider.of<Client>(context, listen: false);
    final userId = client.userID;

    if (userId != null) {
      final avatarUrl = await client.getAvatarUrl(userId);
      final displayName = await client.getDisplayName(userId);

      setState(() {
        _avatarUrl = avatarUrl.toString();
        _displayName = displayName;
      });
    }
  }

  void _logout() async {
    final client = Provider.of<Client>(context, listen: false);
    client.logout();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final TextProvider textProvider = Provider.of(context, listen: true);

    void simpleDialogTheme(BuildContext context) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text('Выберите тему'),
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    themeProvider.changeTheme(0);
                    textProvider.changeTextTheme('Светлая');
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsMenu()));
                  },
                  child: const Text('Светлая'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    themeProvider.changeTheme(1);
                    textProvider.changeTextTheme('Тёмно-серая');
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsMenu()));
                  },
                  child: const Text('Тёмно-серая'),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    themeProvider.changeTheme(2);
                    textProvider.changeTextTheme('Тёмно-синяя');
                    Navigator.pop(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SettingsMenu()));
                  },
                  child: const Text('Тёмно-синяя'),
                ),
              ],
            );
          });
    }

    return MaterialApp(
      theme: themes[themeProvider.themeIndex],
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: themes[themeProvider.themeIndex].primaryColor,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Menuchats()));
                  },
                  icon: Icon(Icons.arrow_back,
                      color: themeProvider.themeIndex == 0
                          ? Colors.black
                          : Colors.white)),
            ],
          ),
          toolbarHeight: 50,
        ),
        body: Column(
          children: [
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: themes[themeProvider.themeIndex].primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(width: 25),
                      // Отображение аватара
                      CircleAvatar(
                        radius: 37,
                        backgroundImage: _avatarUrl != null
                            ? NetworkImage(_avatarUrl!)
                            : null,
                        child: _avatarUrl == null
                            ? const Icon(Icons.person, size: 37)
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _displayName ?? "Загрузка...",
                                style: TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w600,
                                    color: themeProvider.themeIndex == 0
                                        ? Colors.black
                                        : Colors.white),
                              ),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: const Icon(
                              //     Icons.edit,
                              //     size: 23,
                              //     color: Color(0xFF848484),
                              //   ),
                              // ),
                            ],
                          ),
                          Text(
                            clientInfo!.userID!,
                            style: const TextStyle(
                                fontSize: 15, color: Color(0xFF8A8A8A)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: themes[themeProvider.themeIndex].primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      SizedBox(width: 15),
                      SizedBox(height: 45),
                      Text(
                        'Настройки',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            color: Color(0xFF504E4E)),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const SettingsChat()),
                      );
                    },
                    child: SizedBox(
                      height: 50,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble,
                                      color: Color(0xFF666666),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Настройки чатов',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: themeProvider.themeIndex == 0
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 45),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SettingsChat(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 55),
                    child: Container(
                      height: 0.5,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      simpleDialogTheme(context);
                    },
                    child: SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.brightness_2,
                                  color: Color(0xFF666666),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  'Тема',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: themeProvider.themeIndex == 0
                                          ? Colors.black
                                          : Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: TextButton(
                              onPressed: () {
                                simpleDialogTheme(context);
                              },
                              child: Text(textProvider.textTheme),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    _logout();
                  },
                  child: Container(
                    alignment: const Alignment(0.0, 0.1),
                    height: 50,
                    decoration: BoxDecoration(
                      color: themes[themeProvider.themeIndex].primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Stack(
                      alignment: Alignment(1.0, 0.0),
                      children: [
                        Positioned(
                            left: 10,
                            child: Icon(
                              Icons.exit_to_app,
                              color: Color(0xFF962E2E),
                            )),
                        Positioned(
                            left: 50,
                            child: Text(
                              'Выйти',
                              style: TextStyle(
                                  color: Color(0xFF962E2E),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              'Версия 0.0.1.0',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
