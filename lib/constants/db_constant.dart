import 'package:cloud_firestore/cloud_firestore.dart';

final notesRef = FirebaseFirestore.instance.collection('songs');
final usersRef = FirebaseFirestore.instance.collection('users'); 