// Наш девис всего три слова - чтоб работала корова
//
// apt moo
//
//               (__)
//               (oo)
//         /------\/
//        / |    ||
//       *  /\---/\
//          ~~   ~~
//..."Have you mooed today?"...

import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:chatter/Chat/menu_chats.dart';
import 'package:chatter/castomization.dart';
import 'package:chatter/logic.dart';
import 'package:chatter/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = getClient('Chatter');
  await client.init();

  clientInfo = client;

  //debugPaintSizeEnabled = true;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(create: (context) => TextProvider()),
      ChangeNotifierProvider(create: (context) => SizeTextProvider()),
      ChangeNotifierProvider(create: (context) => ChatViewProvider()),
      ChangeNotifierProvider(create: (context) => ViewTextProvider()),
    ],
    child: Main(client: client),
  ));
}

class Main extends StatelessWidget {
  final Client client;

  const Main({required this.client, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter',
      builder: (context, child) => Provider<Client>(
        create: (context) => client,
        child: child,
      ),
      home: client.isLogged() ? const Menuchats() : const Login(),
    );
  }
}
