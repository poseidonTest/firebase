import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_karaoke/models/my_song_data_fb_model.dart';
import 'package:my_karaoke/screens/add_edit_screen.dart';
import 'package:my_karaoke/screens/event_list.dart';
import 'package:my_karaoke/screens/search_page.dart';
import 'package:my_karaoke/shared/data_provider.dart';
import 'login_screen.dart';
import '../shared/authentication.dart';

enum Janre { Pop, ballade, trots, classic, favority }

class EventScreen extends StatelessWidget {
  final String uid;

  const EventScreen({Key? key, required this.uid}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Authentication auth = new Authentication();
    return WillPopScope(
      onWillPop: () {
        return Future(() => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('애창곡 FB'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) {
                        return SearchPage(
                          userId: uid,
                        );
                      },
                      fullscreenDialog: true),
                );
              },
            ),
            // PopupMenuButton<Janre>(
            //   onSelected: (value) {
            //     print(value); //Janre.pop 등으로 나타남.
            //     // 선택 장르만 조회해 출력.
            //     DataList().details = [];
            //     getSearchData(value.toString()).then((value) {});
            //   },
            //   itemBuilder: (BuildContext context) => <PopupMenuEntry<Janre>>[
            //     const PopupMenuItem<Janre>(
            //       value: Janre.Pop,
            //       child: Text('Pop'),
            //     ),
            //     const PopupMenuItem<Janre>(
            //       value: Janre.trots,
            //       child: Text('가요'),
            //     ),
            //     const PopupMenuItem<Janre>(
            //       value: Janre.classic,
            //       child: Text('클래식'),
            //     ),
            //     const PopupMenuItem<Janre>(
            //       value: Janre.ballade,
            //       child: Text('발라드'),
            //     ),
            //     const PopupMenuItem<Janre>(
            //       value: Janre.favority,
            //       child: Text('즐겨찾기'),
            //     ),
            //   ],
            // ),
            IconButton(
              onPressed: () => _showPopupMenu(context),
              icon: Icon(Icons.menu),
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                auth.signOut().then((result) {
                  DataList().details = [];
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                });
              },
            ),
          ],
        ),
        body: EventList(
          uid: uid,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => AddEditPage(
                        uid: uid,
                        isNew: true,
                      )),
            );
            ;
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void selectedMenu(BuildContext context, String selectedMenu) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Selected'),
          content: Text('$selectedMenu selected'),
          actions: [],
        );
      },
    );
  }

  Future getSearchData(String searchTerm) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var data = await db
          .collection('songs')
          .doc(uid)
          .collection("songDatas")
          .where("songJanre", isEqualTo: searchTerm)
          .get();
      DataList().details = data.docs
          .map((document) => MySongDataFirebase.fromMap(document))
          .toList();
      int i = 0;
      DataList().details.forEach((detail) {
        detail.id = data.docs[i].id;
        i++;
      });
    } catch (e) {}
  }

  void _showPopupMenu(BuildContext context) async {
    String? selected = await showMenu<String>(
        context: context,
        position: RelativeRect.fromLTRB(MediaQuery.of(context).size.width / 10,
            MediaQuery.of(context).size.height / 5, 100, 100),
        items: <PopupMenuEntry<String>>[
          PopupMenuItem(
            value: '발라드',
            child: ListTile(
              leading: Icon(Icons.note_add),
              title: Text('발라드'),
            ),
          ),
          PopupMenuDivider(),
          PopupMenuItem(
            value: 'Pop',
            child: ListTile(
              leading: Icon(Icons.notification_important),
              title: Text('Pop'),
            ),
          ),
          PopupMenuItem(
            value: 'trots',
            child: ListTile(
              leading: Icon(Icons.pages),
              title: Text('trots'),
            ),
          ),
          PopupMenuItem(
            value: 'favorite',
            child: ListTile(
              leading: Icon(Icons.favorite),
              title: Text('즐겨찾기'),
            ),
          )
        ]);
    if (selected == null) {
      return;
    }
    selectedMenu(context, selected);
  }
}


