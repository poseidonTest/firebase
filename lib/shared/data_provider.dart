import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_karaoke/constants/db_constant.dart';
import 'package:my_karaoke/models/my_song_data_fb_model.dart';

class DataList extends ChangeNotifier {
  List<MySongDataFirebase> details = [];
  DataList._internal();
  static final DataList _singleton = DataList._internal();
  factory DataList() {
    return _singleton;
  }

  Future<void> addData(MySongDataFirebase newNote) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference docRef = await db
          .collection("songs")
          .doc(newNote.songOwnerId)
          .collection('songDatas')
          .add(newNote.toMap());
      final newEventDetail = MySongDataFirebase(
          newNote.id = docRef.id,
          newNote.songOwnerId,
          newNote.songName,
          newNote.songGYNumber,
          newNote.songTJNumber,
          newNote.songJanre,
          newNote.songETC,
          newNote.songUtubeAddress,
          newNote.createTime,
          newNote.songFavorite);
      this.details.add(newEventDetail);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<QuerySnapshot>> searchNotes(
    String userId,
    String searchTerm,
  ) async {
    try {
      final snapshotOne = notesRef
          .doc(userId)
          .collection('songDatas')
          .where('songName', isGreaterThanOrEqualTo: searchTerm)
          .where('songName', isLessThanOrEqualTo: searchTerm + 'z');

      final snapshotTwo = notesRef
          .doc(userId)
          .collection('songDatas')
          .where('songJanre', isGreaterThanOrEqualTo: searchTerm)
          .where('songJanre', isLessThanOrEqualTo: searchTerm + 'z');

      final userNotesSnapshot =
          await Future.wait([snapshotOne.get(), snapshotTwo.get()]);

      return userNotesSnapshot;
    } catch (e) {
      rethrow;
    }
  }

  Future updateData(
      String uid, String dataId, MySongDataFirebase updateData) async {
    // print(uid);
    // print(dataId);
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db
          .collection('songs')
          .doc(uid)
          .collection("songDatas")
          .doc(dataId)
          .update(updateData.toMap());
      await getDetailsList(uid);
    } catch (e) {
      rethrow;
    }
  }

  Future deleteData(String uid, String delId, int index) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('songs')
        .doc(uid)
        .collection("songDatas")
        .doc(delId)
        .delete();
    details.removeAt(index);
    notifyListeners();
  }

  Future getDetailsList(String uid) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      var data =
          await db.collection('songs').doc(uid).collection("songDatas").get();
      details = data.docs
          .map((document) => MySongDataFirebase.fromMap(document))
          .toList();
      int i = 0;
      details.forEach((detail) {
        // print(detail.id);
        // print("data : ${data.docs[i].id}");
        detail.id = data.docs[i].id;
        // print("after : ${detail.id}");
        i++;
      });
      notifyListeners();
    } catch (e) {}
  }
}
