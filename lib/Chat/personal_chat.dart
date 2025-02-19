import 'package:chatter/Chat/menu_chats.dart';
import 'package:flutter/material.dart';
import 'package:chatter/castomization.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:chatter/logic.dart';

class PersonalChat extends StatefulWidget {
  final Room room;
  final int i;
  const PersonalChat({super.key, required this.room, required this.i});

  @override
  PersonalChatState createState() => PersonalChatState();
}

class PersonalChatState extends State<PersonalChat> {
  final TextEditingController _sendController = TextEditingController();

  void _send() {
    widget.room.sendTextEvent(_sendController.text.trim());
    _sendController.clear();
  }

  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final ChatViewProvider chatViewProvider =
        Provider.of(context, listen: true);
    return MaterialApp(
      theme: themes[themeProvider.themeIndex],
      home: Scaffold(
        //backgroundColor: themeProvider.themeIndex.,
        appBar: AppBar(
            scrolledUnderElevation: 0.0,
            backgroundColor:
                themes[themeProvider.themeIndex].appBarTheme.backgroundColor,
            title: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Menuchats()));
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: themeProvider.themeIndex == 0
                        ? Colors.black
                        : Colors.white,
                  )),
              const SizedBox(width: 10),
              CircleAvatar(
                foregroundImage: clientInfo!.rooms[widget.i].avatar == null
                    ? null
                    : NetworkImage(clientInfo!.rooms[widget.i].avatar!
                        .getThumbnail(
                          clientInfo!,
                          width: 56,
                          height: 56,
                        )
                        .toString()),
              ),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  widget.room.displayname,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeIndex == 0
                          ? Colors.black
                          : Colors.white),
                ),
              ])
            ])),
        body: Column(
          children: [
            Expanded(
              child: chatViewProvider.isClassicView
                  ? ClassicViewChat(room: widget.room)
                  : TraditionViewChat(room: widget.room),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                          color: themeProvider.themeIndex == 0
                              ? Colors.black
                              : Colors.white),
                      controller: _sendController,
                      minLines: 1,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Введите сообщение",
                          fillColor:
                              themes[themeProvider.themeIndex].primaryColor,
                          hintStyle: const TextStyle(color: Color(0xFF979797)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          )),
                    ),
                  ),
                  const SizedBox(width: 5),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward, color: Colors.white),
                      onPressed: _send,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TraditionViewChat extends StatefulWidget {
  final Room room;
  const TraditionViewChat({super.key, required this.room});

  @override
  State<TraditionViewChat> createState() => _TraditionViewChatState();
}

class _TraditionViewChatState extends State<TraditionViewChat> {
  late final Future<Timeline> _timelineFuture;
  int _count = 0;

  @override
  void initState() {
    _timelineFuture = widget.room.getTimeline(onChange: (i) {
      print('on change! $i');
      setState(() {});
    }, onInsert: (i) {
      print('on insert! $i');
      _count++;
    }, onRemove: (i) {
      print('On remove $i');
      _count--;
    }, onUpdate: () {
      print('On update');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final SizeTextProvider sizeTextProvider =
        Provider.of(context, listen: true);
    return FutureBuilder<Timeline>(
      future: _timelineFuture,
      builder: (context, snapshot) {
        final timeline = snapshot.data;
        if (timeline == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        _count = timeline.events.length;
        return Column(
          children: [
            // Center(
            //   child: TextButton(
            //     onPressed: timeline.requestHistory,
            //     child: const Text('Load more...'),
            //   ),
            // ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: timeline.events.length,
                itemBuilder: (context, i) {
                  if (timeline.events[i].relationshipEventId != null) {
                    return Container();
                  }
                  return Opacity(
                    opacity: timeline.events[i].status.isSent ? 1 : 0.5,
                    child: ListTile(
                      leading: CircleAvatar(
                        foregroundImage: timeline.events[i].sender.avatarUrl ==
                                null
                            ? null
                            : NetworkImage(timeline.events[i].sender.avatarUrl!
                                .getThumbnail(
                                  widget.room.client,
                                  width: 56,
                                  height: 56,
                                )
                                .toString()),
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              timeline.events[i].sender.calcDisplayname(),
                              style: TextStyle(
                                  color: themeProvider.themeIndex == 0
                                      ? Colors.black
                                      : Colors.white),
                            ),
                          ),
                          //           Text(
                          //             timeline.events[i].originServerTs.toIso8601String(),
                          //             style: TextStyle(fontSize: 10, color: themeProvider.themeIndex == 0
                          // ? Colors.black
                          // : Colors.white),
                          //           ),
                        ],
                      ),
                      subtitle: Text(
                        timeline.events[i].getDisplayEvent(timeline).body,
                        style: TextStyle(
                            fontSize: sizeTextProvider.sizeTextTheme,
                            color: themeProvider.themeIndex == 0
                                ? Colors.black
                                : Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class ClassicViewChat extends StatefulWidget {
  final Room room;
  const ClassicViewChat({super.key, required this.room});

  @override
  State<ClassicViewChat> createState() => _ClassicViewChatState();
}

class _ClassicViewChatState extends State<ClassicViewChat> {
  late final Future<Timeline> _timelineFuture;
  final _scrollController = ScrollController();
  int _count = 0;

  @override
  void initState() {
    _timelineFuture = widget.room.getTimeline(onChange: (i) {
      print('on change! $i');
      setState(() {});
    }, onInsert: (i) {
      setState(() {
        _count++;
      });
    }, onRemove: (i) {
      print('On remove $i');
      _count--;
    }, onUpdate: () {
      print('On update');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SizeTextProvider sizeTextProvider =
        Provider.of(context, listen: true);
    final ThemeProvider themeProvider = Provider.of(context, listen: true);

    Color myMes = const Color(0xFFB7B7B7);
    Color friendMes = const Color(0xFFD9D9D9);

    void _myColorMes() {
      if (themeProvider.themeIndex == 0) {
        myMes = const Color(0xFFB7B7B7);
      } else if (themeProvider.themeIndex == 1) {
        myMes = const Color(0xFF151515);
      } else {
        myMes = const Color(0xFF14141C);
      }
    }

    void _friendColorMes() {
      if (themeProvider.themeIndex == 0) {
        friendMes = const Color(0xFFD9D9D9);
      } else if (themeProvider.themeIndex == 1) {
        friendMes = const Color(0xFF2F2F2F);
      } else {
        friendMes = const Color(0xFF18182F);
      }
    }

    _myColorMes();
    _friendColorMes();

    return FutureBuilder<Timeline>(
      future: _timelineFuture,
      builder: (context, snapshot) {
        final timeline = snapshot.data;
        if (timeline == null) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        _count = timeline.events.length;

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                reverse: true,
                itemCount: timeline.events.length,
                itemBuilder: (context, i) {
                  if (timeline.events[i].relationshipEventId != null) {
                    return Container();
                  }

                  bool isMyMessage(String messageSenderId, String myUserId) =>
                      messageSenderId != myUserId;

                  String messageSenderId = timeline.events[i].senderId;
                  String myUserId = clientInfo!.userID!;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    child: Align(
                        alignment: isMyMessage(messageSenderId, myUserId)
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: GestureDetector(
                          onLongPress: () {
                            /////////////////////////////
                          },
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.8,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isMyMessage(messageSenderId, myUserId)
                                  ? friendMes
                                  : myMes,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  isMyMessage(messageSenderId, myUserId)
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   timeline.events[i].sender.calcDisplayname(),
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                // const SizedBox(height: 1),
                                Text(
                                  timeline.events[i]
                                      .getDisplayEvent(timeline)
                                      .body,
                                  style: TextStyle(
                                    color: themeProvider.themeIndex == 0
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: sizeTextProvider.sizeTextTheme,
                                  ),
                                ),
                                //const SizedBox(height: 5),
                                // Text(
                                //   timeline.events[i].originServerTs.toIso8601String(),
                                //   style: TextStyle(
                                //     fontSize: 10,
                                //     color: Colors.white70,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        )),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
