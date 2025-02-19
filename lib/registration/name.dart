import 'package:flutter/material.dart';
import 'package:chatter/registration/id.dart';

class Name extends StatefulWidget {
  const Name({super.key});

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
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
                        TextSpan(text: 'Отлично! Теперь давайте '),
                        TextSpan(text: 'придумаем Вам '),
                        TextSpan(
                            text: 'ник',
                            style: TextStyle(
                                fontSize: 30,
                                color: Color(0xFF00C7BE),
                                fontWeight: FontWeight.bold))
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
                      labelText: 'Введите ник',
                      suffixIcon: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Id()));
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
