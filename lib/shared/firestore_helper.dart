import 'package:my_karaoke/models/my_song_data_fb_model.dart';
import '../models/favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static Future addFavorite(MySongDataFirebase eventDetail, String? uid) {
    Favorite fav = Favorite(null, eventDetail.id, uid);
    var result = db
        .collection('favorites')
        .add(fav.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future deleteFavorite(String? favId) async {
    await db.collection('favorites').doc(favId).delete();
  }

  static Future<List<Favorite>?> getUserFavorites(String? uid) async {
    List<Favorite>? favs;
    QuerySnapshot docs =
        await db.collection('favorites').where('userId', isEqualTo: uid).get();
    favs = docs.docs.map((data) => Favorite.map(data)).toList();
    return favs;
  }
}
