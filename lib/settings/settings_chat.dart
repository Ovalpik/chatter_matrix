import 'package:flutter/material.dart';
import 'package:chatter/castomization.dart';
import 'package:chatter/settings/settings_menu.dart';
import 'package:provider/provider.dart';

const List<String> listTheme = <String>[
  'Светлая',
  'Тёмно-синяя',
  'Тёмно-серая'
];
const List<String> listView = <String>['Классический', 'Традиционный'];

class SettingsChat extends StatefulWidget {
  const SettingsChat({super.key});

  @override
  State<SettingsChat> createState() => _SettingsChatState();
}

class _SettingsChatState extends State<SettingsChat> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final SizeTextProvider sizeTextProvider =
        Provider.of(context, listen: true);
    final ChatViewProvider chatViewProvider =
        Provider.of(context, listen: true);
    return MaterialApp(
      theme: themes[themeProvider.themeIndex],
      home: Scaffold(
          backgroundColor: themes[themeProvider.themeIndex].primaryColor,
          appBar: AppBar(
            backgroundColor: themes[themeProvider.themeIndex].primaryColor,
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SettingsMenu()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: themeProvider.themeIndex == 0
                          ? Colors.black
                          : Colors.white,
                    )),
                Text(
                  'Настройка чатов',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: themeProvider.themeIndex == 0
                          ? Colors.black
                          : Colors.white),
                )
              ],
            ),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.2,
              ),
              decoration: BoxDecoration(
                color: themes[themeProvider.themeIndex].scaffoldBackgroundColor,
              ),
              child: chatViewProvider.isClassicView
                  ? const EmulatorClassicViewChat()
                  : const EmulatorTraditionViewChat(),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Размер сообщений в чатах: ${sizeTextProvider.sizeTextTheme.round()}',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: themeProvider.themeIndex == 0
                        ? Colors.black
                        : Colors.white),
              ),
            ),
            Slider(
                value: sizeTextProvider.sizeTextTheme,
                max: 30,
                min: 15,
                activeColor:
                    themes[themeProvider.themeIndex].scaffoldBackgroundColor,
                label: sizeTextProvider.sizeTextTheme.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    sizeTextProvider.changeTextTheme(value);
                  });
                }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text(
                    'Вид чата',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: themeProvider.themeIndex == 0
                            ? Colors.black
                            : Colors.white),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: DropDownMenuView(),
                )
              ],
            ),
          ])),
    );
  }
}

class DropDownMenuView extends StatefulWidget {
  const DropDownMenuView({super.key});

  @override
  State<DropDownMenuView> createState() => _DropDownMenuViewState();
}

class _DropDownMenuViewState extends State<DropDownMenuView> {
  @override
  Widget build(BuildContext context) {
    final ChatViewProvider chatViewProvider =
        Provider.of(context, listen: true);
    final ViewTextProvider viewTextProvider =
        Provider.of(context, listen: true);
    return SizedBox(
      width: 180,
      height: 50,
      child: DropdownMenu<String>(
        initialSelection: viewTextProvider.viewTextTheme,
        onSelected: (String? value) {
          setState(() {
            chatViewProvider.changeView();
            viewTextProvider.changeTextTheme(chatViewProvider.isClassicView
                ? 'Классический'
                : 'Традиционный');
          });
        },
        dropdownMenuEntries:
            listView.map<DropdownMenuEntry<String>>((String value) {
          return DropdownMenuEntry<String>(value: value, label: value);
        }).toList(),
      ),
    );
  }
}

class EmulatorClassicViewChat extends StatefulWidget {
  const EmulatorClassicViewChat({super.key});

  @override
  State<EmulatorClassicViewChat> createState() => _EmulatorState();
}

class _EmulatorState extends State<EmulatorClassicViewChat> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final SizeTextProvider sizeTextProvider =
        Provider.of(context, listen: true);
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: themes[themeProvider.themeIndex].primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(18))),
                child: Text(
                  'Ты знаешь что за Chatter?',
                  style: TextStyle(
                      fontSize: sizeTextProvider.sizeTextTheme,
                      color: themeProvider.themeIndex == 0
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: themes[themeProvider.themeIndex].primaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(18))),
                child: Text(
                  'Chatter - это будущее мессенджеров!',
                  style: TextStyle(
                      fontSize: sizeTextProvider.sizeTextTheme,
                      color: themeProvider.themeIndex == 0
                          ? Colors.black
                          : Colors.white),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class EmulatorTraditionViewChat extends StatefulWidget {
  const EmulatorTraditionViewChat({super.key});

  @override
  State<EmulatorTraditionViewChat> createState() =>
      _EmulatorTraditionViewChatState();
}

class _EmulatorTraditionViewChatState extends State<EmulatorTraditionViewChat> {
  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    final SizeTextProvider sizeTextProvider =
        Provider.of(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 25.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 1.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(''),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plushka',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeIndex == 0
                                ? Colors.black
                                : Colors.white),
                      ),
                      Text(
                        '16:50',
                        style: TextStyle(
                            color: themeProvider.themeIndex == 0
                                ? Colors.black
                                : Colors.white),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      'Ты знаешь что за Chatter?',
                      style: TextStyle(
                          fontSize: sizeTextProvider.sizeTextTheme,
                          color: themeProvider.themeIndex == 0
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(''),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ovalp1k',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.themeIndex == 0
                                ? Colors.black
                                : Colors.white),
                      ),
                      Text(
                        '16:51',
                        style: TextStyle(
                            color: themeProvider.themeIndex == 0
                                ? Colors.black
                                : Colors.white),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 50),
                  Expanded(
                    child: Text(
                      'Chatter - это будущее мессенджеров!',
                      style: TextStyle(
                          fontSize: sizeTextProvider.sizeTextTheme,
                          color: themeProvider.themeIndex == 0
                              ? Colors.black
                              : Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
