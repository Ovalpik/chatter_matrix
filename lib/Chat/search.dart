import 'package:chatter/logic.dart';
import 'package:flutter/material.dart';
import 'package:chatter/Chat/menu_chats.dart';
import 'package:chatter/castomization.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _search = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchPeople(String peopleToFind) async {
    if (peopleToFind.isEmpty) return;

    setState(() {
      _isLoading = true
    });

    try {
      final response = await clientInfo!.searchUserDirectory(peopleToFind);
      setState(() {
        _searchResults =
            response.results; 
      });
    } catch (e) {
      print('Ошибка при поиске: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of(context, listen: true);
    return MaterialApp(
      theme: themes[themeProvider.themeIndex],
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _search,
                  style: TextStyle(
                    color: themeProvider.themeIndex == 0
                        ? Colors.black
                        : Colors.white,
                  ),
                  decoration: InputDecoration(
                    hintText: ' Поиск...',
                    hintStyle: const TextStyle(color: Color(0xFF848484)),
                    prefixIcon: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.fade,
                            child: const Menuchats(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: themeProvider.themeIndex == 0
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                    // suffixIcon: IconButton(
                    //   onPressed: () {
                    //     _searchPeople(_search.text);
                    //   },
                    //   icon: Icon(
                    //     Icons.search,
                    //     color: themeProvider.themeIndex == 0
                    //         ? Colors.black
                    //         : Colors.white,
                    //   ),
                    // ),
                    fillColor: themes[themeProvider.themeIndex].primaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        // body: _isLoading
        //     ? const Center(
        //         child: CircularProgressIndicator()) // Индикатор загрузки
        //     : ListView.builder(
        //         itemCount: _searchResults.length,
        //         itemBuilder: (context, index) {
        //           final user = _searchResults[index];
        //           return ListTile(
        //             leading: CircleAvatar(
        //               radius: 23,
        //               foregroundImage: user.imageUrl != null
        //                   ? NetworkImage(user.imageUrl!)
        //                   : null,
        //               child:
        //                   user.avatar == null ? const Icon(Icons.person) : null,
        //             ),
        //             title: Text(user.name ?? 'No Name'),
        //             subtitle: Text(user.id ?? 'No ID'),
        //             onTap: () {
        //               // Действие при нажатии на пользователя
        //               print('User ID: ${user.id}');
        //             },
        //           );
        //         },
        //       ),
        body: Center(
          child: Text(
            'К сожалению эта функция пока не доступна',
            style: TextStyle(
                color: themeProvider.themeIndex == 0
                    ? Colors.black
                    : Colors.white),
          ),
        ),
      ),
    );
  }
}
