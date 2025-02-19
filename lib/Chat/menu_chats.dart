import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/Chat/add.dart';
import 'package:chatter/Chat/search.dart';
import 'package:chatter/Chat/personal_chat.dart';
import 'package:chatter/castomization.dart';
import 'package:chatter/settings/settings_menu.dart';
import 'package:matrix/matrix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Menuchats extends StatefulWidget {
  const Menuchats({super.key});

  @override
  State<Menuchats> createState() => _MenuchatsState();
}

class _MenuchatsState extends State<Menuchats> {
  void _join(Room room, int i) async {
    if (room.membership != Membership.join) {
      await room.join();
    }
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => PersonalChat(
          room: room,
          i: i,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final client = Provider.of<Client>(context, listen: false);

    return MaterialApp(
      theme: themes[themeProvider.themeIndex],
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chatter',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 33,
                color: themeProvider.themeIndex == 0
                    ? Colors.black
                    : Colors.white),
          ),
          leading: Container(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                themeProvider.themeIndex == 0
                    ? ('assets/CW.png')
                    : ('assets/Chatter.png'),
              ),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: const Search()));
                },
                icon: const Icon(
                  Icons.search,
                  color: Color(0xFF848484),
                )),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SettingsMenu()));
                },
                icon: const Icon(
                  Icons.settings,
                  color: Color(0xFF848484),
                ))
          ],
        ),
        body: StreamBuilder(
          stream: client.onSync.stream,
          builder: (context, _) => ListView.builder(
            itemCount: client.rooms.length,
            itemBuilder: (context, i) => ListTile(
              leading: CircleAvatar(
                radius: 23,
                foregroundImage: client.rooms[i].avatar == null
                    ? null
                    : NetworkImage(client.rooms[i].avatar!
                        .getThumbnail(
                          client,
                          width: 80,
                          height: 80,
                        )
                        .toString()),
              ),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    client.rooms[i].displayname,
                    style: TextStyle(
                        color: themeProvider.themeIndex == 0
                            ? Colors.black
                            : Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w400),
                  )),
                  // if (client.rooms[i].notificationCount > 0)
                  //   CircleAvatar(
                  //     backgroundColor: const Color(0xFF585858),
                  //     radius: 12,
                  //     child: Text(
                  //       client.rooms[i].notificationCount.toString(),
                  //       style: const TextStyle(color: Colors.white),
                  //     ),
                  //   ),
                ],
              ),
              subtitle: Text(
                client.rooms[i].lastEvent?.body ?? 'No messages',
                maxLines: 1,
                style: const TextStyle(color: Color(0xFF585858)),
              ),
              onTap: () => _join(client.rooms[i], i),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, CupertinoPageRoute(builder: (context) => const Add()));
          },
          child: Icon(
            Icons.edit,
            color: themeProvider.themeIndex == 0 ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
