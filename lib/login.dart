import 'package:flutter/material.dart';
import 'package:matrix/matrix.dart';
import 'package:chatter/Chat/menu_chats.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _homeserverTextField = TextEditingController(
    text: 'matrix.org',
  );
  final TextEditingController _usernameTextField = TextEditingController();
  final TextEditingController _passwordTextField = TextEditingController();

  bool _loading = false;

  final Uri toLaunch = Uri.parse('https://riot.im/app/#/register');

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  void _login() async {
    setState(() {
      _loading = true;
    });

    try {
      final client = Provider.of<Client>(context, listen: false);
      await client
          .checkHomeserver(Uri.https(_homeserverTextField.text.trim(), ''));
      await client.login(
        LoginType.mLoginPassword,
        password: _passwordTextField.text,
        identifier: AuthenticationUserIdentifier(user: _usernameTextField.text),
      );
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const Menuchats()),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            const Text(
              'Добро',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 44,
                  color: Colors.white),
            ),
            const Text(
              'пожаловать!',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 44,
                  color: Colors.white),
            ),
            const SizedBox(height: 40),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextField(
                controller: _homeserverTextField,
                autocorrect: false,
                readOnly: _loading,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixText: 'https://',
                  prefixStyle: TextStyle(color: Color(0xFF626262)),
                  labelText: 'Homeserver',
                  labelStyle: TextStyle(color: Color(0xFF686868)),
                  prefixIconColor: Color(0xFF686868),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextField(
                controller: _usernameTextField,
                autocorrect: false,
                readOnly: _loading,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color(0xFF686868)),
                  prefixIcon: Icon(Icons.person),
                  prefixIconColor: Color(0xFF686868),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: TextField(
                controller: _passwordTextField,
                autocorrect: false,
                readOnly: _loading,
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  labelStyle: TextStyle(color: Color(0xFF686868)),
                  prefixIcon: Icon(Icons.lock),
                  prefixIconColor: Color(0xFF686868),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF00C7BE),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    child: _loading
                        ? const ProgressIndicator()
                        : const Text(
                            'Войти',
                            style: TextStyle(
                                fontSize: 22, color: Color(0xFFF5F5F5)),
                          ),
                  ),
                )),
            const Divider(
              color: Color(0xFFFFFFFF),
              thickness: 0.3,
              height: 75,
            ),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: () => setState(() {}),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2B2B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Нет аккаунта?',
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text('Создать ',
                          style: TextStyle(color: Color(0xFF34C759))),
                      Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF34C759),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ProgressIndicator extends StatelessWidget {
  const ProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          LoadingAnimationWidget.discreteCircle(color: Colors.white, size: 20),
    );
  }
}
