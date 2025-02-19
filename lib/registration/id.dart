import 'package:flutter/material.dart';
import 'package:chatter/Chat/menu_chats.dart';

class Id extends StatefulWidget {
  const Id({super.key});

  @override
  State<Id> createState() => _IdState();
}

class _IdState extends State<Id> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF202020),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 170),
              const Column(
                children: [
                  Text.rich(TextSpan(
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(text: 'Придумайте '),
                        TextSpan(
                            text: 'ID ',
                            style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFFF6FF00),
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                '(с помощью него Вас смогут добавить в друзья)',
                            style: TextStyle(fontSize: 15))
                      ])),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                  width: 330,
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E2E2E),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Введите ID',
                      suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Menuchats()));
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Color(0xFF34C759),
                          )),
                      labelStyle: const TextStyle(color: Color(0xFF686868)),
                      prefixIconColor: const Color(0xFF686868),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(10.0),
                    ),
                  ))
            ],
          ),
        ));
  }
}
