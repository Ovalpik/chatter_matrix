import 'package:chatter/Chat/personal_chat.dart';
import 'package:chatter/Chat/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatter/Chat/menu_chats.dart';
import 'package:chatter/castomization.dart';
import 'package:matrix/matrix.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Add extends StatelessWidget {
  const Add({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final client = Provider.of<Client>(context, listen: false);

    void join(Room room, int i) async {
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

    return MaterialApp(
        theme: themes[themeProvider.themeIndex],
        home: Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Menuchats()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: themeProvider.themeIndex == 0
                            ? Colors.black
                            : Colors.white,
                      )),
                  Text(
                    'Добавить',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: themeProvider.themeIndex == 0
                            ? Colors.black
                            : Colors.white),
                  )
                ],
              ),
            ),
            body: ListView.builder(
                itemCount: client.rooms.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const Search()));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFF2F2F2F)),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.person_add,
                                      color: themeProvider.themeIndex == 0
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                    Text('Добавить друга',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: themeProvider.themeIndex == 0
                                                ? Colors.black
                                                : Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // GestureDetector(
                            //   onTap: () {
                            //     ///////////////////////////
                            //   },
                            //   child: Container(
                            //     padding: const EdgeInsets.all(16.0),
                            //     decoration: BoxDecoration(
                            //       border: Border.all(
                            //           color: const Color(0xFF2F2F2F)),
                            //       borderRadius: BorderRadius.circular(8.0),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Icon(
                            //           Icons.group_add,
                            //           color: themeProvider.themeIndex == 0
                            //               ? Colors.black
                            //               : Colors.white,
                            //         ),
                            //         Text('Создать группу',
                            //             style: TextStyle(
                            //                 fontSize: 16,
                            //                 color: themeProvider.themeIndex == 0
                            //                     ? Colors.black
                            //                     : Colors.white)),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 20),
                            const Divider(
                              height: 5,
                              color: Color(0xFF2F2F2F),
                            )
                          ]),
                    );
                  }
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 18,
                      foregroundImage: client.rooms[index - 1].avatar == null
                          ? null
                          : NetworkImage(client.rooms[index - 1].avatar!
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
                          client.rooms[index - 1].displayname,
                          style: TextStyle(
                              color: themeProvider.themeIndex == 0
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w400),
                        )),
                        if (client.rooms[index - 1].notificationCount > 0)
                          CircleAvatar(
                            backgroundColor: const Color(0xFF585858),
                            radius: 12,
                            child: Text(
                              client.rooms[index - 1].notificationCount
                                  .toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    //onTap: () => join(client.rooms[index - 1], index),
                  );
                })));
  }
}
