import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:my_karaoke/models/my_song_data_fb_model.dart';
import 'package:my_karaoke/screens/add_edit_screen.dart';
import 'package:my_karaoke/shared/data_provider.dart';
import 'package:provider/provider.dart';



class EventList extends StatefulWidget {
  final String uid;

  const EventList({Key? key, required this.uid}) : super(key: key);
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  var counter;

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {});
    });
  }

  Future getData() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var data = await db
          .collection('songs')
          .doc(widget.uid)
          .collection("songDatas")
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

  @override
  Widget build(BuildContext context) {
    counter = Provider.of<DataList>(context, listen: true);
    return ListView.builder(
      itemCount: counter.details.length,
      itemBuilder: (context, position) {
        // String sub = DateFormat('yyyy-MM-dd, hh:mm')
        String sub = DateFormat('yyyy-MM-dd')
            .format(counter.details[position].createTime.toDate());
        Color starColor =
            // (isUserFavorite(details[position].id)) ? Colors.amber : Colors.grey;
            ((counter.details[position].songFavorite))
                ? Colors.amber
                : Colors.grey;
        return Dismissible(
          key: Key(counter.details[position].id),
          onDismissed: (_) {
            // print("delete :  ${counter.details[position].id}");
            counter.deleteData(
                widget.uid, counter.details[position].id, position);
          },
          child: ListTile(
            title: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "곡명 : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                TextSpan(
                    text: "${counter.details[position].songName!}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontSize: 20)),
              ]),
            ),
            subtitle: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "쟝르: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                TextSpan(
                    text: " ${counter.details[position].songJanre!}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                TextSpan(
                    text: ", 작성 날짜 : ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                TextSpan(
                    text: sub,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
              ]),
            ),
            // subtitle: Text(
            //   "쟝르: ${counter.details[position].songJanre!}, 작성 날짜 : $sub",
            //   style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            // ),
            onTap: () {
              // print("Edit");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEditPage(
                        uid: widget.uid,
                        isNew: false,
                        ev: counter.details[position],
                      )));
            },
            trailing: IconButton(
              icon: Icon(
                Icons.star,
                color: starColor,
              ),
              onPressed: () async {
                setState(() {
                  counter.details[position].songFavorite =
                      !counter.details[position].songFavorite;
                });
                await counter.updateData(
                    widget.uid,
                    counter.details[position].id,
                    counter.details[position] as MySongDataFirebase);
              },
            ),
          ),
        );
      },
    );
  }
}