import 'package:cloud_firestore/cloud_firestore.dart';

class MySongDataFirebase {
  String? id;
  String songOwnerId;
  String songName;
  String songGYNumber;
  String songTJNumber;
  String songJanre;
  String songUtubeAddress;
  String songETC;
  Timestamp createTime;
  bool songFavorite;

  MySongDataFirebase(
      this.id,
      this.songOwnerId,
      this.songName,
      this.songGYNumber,
      this.songTJNumber,
      this.songJanre,
      this.songUtubeAddress,
      this.songETC,
      this.createTime,
      this.songFavorite
      );

  MySongDataFirebase.fromMap(QueryDocumentSnapshot snapshot)
      : id = snapshot.id,
        songOwnerId = snapshot["songOwnerId"],
        songName = snapshot["songName"],
        songGYNumber = snapshot["songGYNumber"],
        songTJNumber = snapshot["songTJNumber"],
        songJanre = snapshot["songJanre"],
        songUtubeAddress = snapshot["songUtubeAddress"],
        songETC = snapshot["songETC"],
        createTime = snapshot["createTime"],
        songFavorite = snapshot["songFavorite"];

  Map<String, dynamic> toMap() {
    return {
      if (id != null) "id": id,
      "songOwnerId": songOwnerId,
      "songName": songName,
      "songGYNumber": songGYNumber,
      "songTJNumber": songTJNumber,
      "songJanre": songJanre,
      "songUtubeAddress": songUtubeAddress,
      "songETC": songETC,
      "createTime": createTime,
      "songFavorite": songFavorite,
    };
  }
}
