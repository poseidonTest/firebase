import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_karaoke/screens/add_edit_screen.dart';
import 'package:my_karaoke/shared/data_provider.dart';
import 'package:provider/src/provider.dart';

class SearchPage extends StatefulWidget {
  final String? userId;
  const SearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  String? userId, searchTerm;
  Future<List<QuerySnapshot>>? _notes;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _notes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          style: TextStyle(color: Colors.white),
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
            filled: true,
            border: InputBorder.none,
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.search,
              size: 30.0,
              color: Colors.white,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: _clearSearch,
            ),
          ),
          onSubmitted: (val) {
            searchTerm = val;
            if (searchTerm!.isNotEmpty) {
              setState(() {
                _notes =
                    context.read<DataList>().searchNotes(userId!, searchTerm!);
              });
            }
          },
        ),
      ),
      body: _notes == null
          ? Center(
              child: Text(
                'Search for Notes',
                style: TextStyle(fontSize: 18.0),
              ),
            )
          : FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              print(snapshot.data.length);

              List<DataList> foundNotes = [];

              for (int i = 0; i < snapshot.data.length; i++) {
                for (int j = 0; j < snapshot.data[i].docs.length; j++) {
                  print(snapshot.data[i].docs[j]);
                  // foundNotes.add(
                  //     MySongDataFirebase.fromDoc(snapshot.data[i].docs[j]));
                }
              }

              foundNotes = [
                ...{...foundNotes}
              ];

              if (foundNotes.length == 0) {
                return Center(
                  child: Text(
                    'No note found, please try again',
                    style: TextStyle(fontSize: 18.0),
                  ),
                );
              }
              return ListView.builder(
                itemCount: foundNotes.length,
                itemBuilder: (BuildContext context, int index) {
                  final DataList note = foundNotes[index];

                  return Card(
                    child: ListTile(
                      onTap: () async {
                        final modified = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddEditPage(uid: userId, isNew: false);
                            },
                          ),
                        );
                        if (modified == true) {
                          setState(() {
                            _notes = context
                                .read<DataList>()
                                .searchNotes(userId!, searchTerm!);
                          });
                        }
                      },
                      title: Text("title"
                          // note.title,
                          // style: TextStyle(
                          //   fontSize: 16.0,
                          //   fontWeight: FontWeight.w600,
                          // ),
                          ),
                      subtitle: Text("dateformat"
                          // DateFormat('yyyy-MM-dd, hh:mm:ss')
                          //     .format(note.timestamp.toDate()),
                          ),
                    ),
                  );
                },
              );
            }),
    );
  }
}
