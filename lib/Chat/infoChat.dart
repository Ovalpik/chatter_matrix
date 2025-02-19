import 'package:chatter/Chat/personal_chat.dart';
import 'package:chatter/castomization.dart';
import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';

class InfoChat extends StatefulWidget {
  final Room room;
  final int i;
  const InfoChat({super.key, required this.room, required this.i});

  @override
  State<InfoChat> createState() => _InfoChatState();
}

class _InfoChatState extends State<InfoChat> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final client = Provider.of<Client>(context, listen: false);
    return MaterialApp(
      theme: themes[themeProvider.themeIndex],
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PersonalChat(
                                room: widget.room,
                                i: widget.i,
                              )));
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: themeProvider.themeIndex == 0
                      ? Colors.black
                      : Colors.white,
                )),
          ),
          body: ListView.builder(itemBuilder: (context, i) {
            Column(
              children: [
                Row(
                  children: [
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage: NetworkImage(client.rooms[i].avatar!
                    //       .getThumbnail(
                    //         client,
                    //         width: 56,
                    //         height: 56,
                    //       )
                    //       .toString()),
                    // ),
                    Text('Emil'),
                  ],
                )
              ],
            );
            return null;
          })),
    );
  }
}
