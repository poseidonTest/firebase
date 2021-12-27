import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_karaoke/models/favorite.dart';
import 'package:my_karaoke/models/my_song_data_fb_model.dart';
import 'package:my_karaoke/shared/data_provider.dart';
import 'package:provider/provider.dart';

class AddEditPage extends StatefulWidget {
  final Favorite? favorite;
  final String? uid;
  final bool isNew;
  final MySongDataFirebase? ev;
  AddEditPage(
      {Key? key,
      this.favorite,
      required this.uid,
      required this.isNew,
      this.ev})
      : super(key: key);

  @override
  _AddEditPageState createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? _songName, _songGYNumber, _songTJNumber, _songUtubeAddress, _songETC;
  String _songJanre = "";
  Timestamp? _createTime;
  bool _songFavorite = false;
  var counter;
  String _selJanre = "가요";

  @override
  Widget build(BuildContext context) {
    counter = Provider.of<DataList>(context, listen: true);
    String sub = DateFormat('yyyy-MM-dd, hh:mm:ss').format((DateTime.now()));

    return Scaffold(
      appBar: AppBar(
        title: widget.isNew == true ? Text('새 노래 추가') : Text('곡 수정'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  30.0,
                  20.0,
                  30.0,
                  10.0,
                ),
                child: TextFormField(
                  initialValue:
                      widget.isNew == false ? widget.ev!.songName : null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: '곡명',
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? '곡명은 필수 입니다.' : null,
                  onSaved: (val) => _songName = val,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: TextFormField(
                  initialValue:
                      widget.isNew == true ? null : widget.ev!.songGYNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: '금영노래방 번호',
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? '금영노래방 번호는 필수입니다' : null,
                  onSaved: (val) => _songGYNumber = val,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: TextFormField(
                  initialValue:
                      widget.isNew == true ? null : widget.ev!.songTJNumber,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: '태진노래방 번호',
                  ),
                  onSaved: (val) => _songTJNumber = val ?? "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: Row(
                  children: [
                    Text(
                      widget.isNew
                          ? "노래 쟝르를 선택하세요!"
                          : "현재 장르 :  ${widget.ev!.songJanre}",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                      items: ["pop", "가요", "발라드", "클래식", "트롯"]
                          .map((e) => DropdownMenuItem(
                                child: Text(e),
                                value: e,
                              ))
                          .toList(),
                      value: _selJanre,
                      hint: Text("쟝르 선택"),
                      // value: widget.isNew ? _selJanre : widget.ev!.songJanre,
                      onChanged: (String? value) {
                        setState(() {
                          _selJanre = value!;
                          _songJanre = _selJanre;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: TextFormField(
                  initialValue:
                      widget.isNew == true ? null : widget.ev!.songUtubeAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: '관련 유튜브 주소',
                  ),
                  onSaved: (val) => _songUtubeAddress = val ?? "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: TextFormField(
                  initialValue:
                      widget.isNew == true ? null : widget.ev!.songJanre,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: '특기사항',
                  ),
                  onSaved: (val) => _songETC = val ?? "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 5.0,
                ),
                child: TextFormField(
                  initialValue: widget.isNew == true
                      ? sub
                      : DateFormat('yyyy-MM-dd, hh:mm:ss')
                          .format(widget.ev!.createTime.toDate()),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    labelText: '날짜',
                  ),
                  // readOnly: true,
                  enabled: false,
                  onSaved: (val) => _createTime = Timestamp.now(),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => submit(widget.isNew == true ? "add" : "edit"),
                child: Text(
                  widget.isNew == true ? 'Add Song' : 'Edit Song',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit(String mode) async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    try {
      final writerOwnerId = widget.uid;
      if (mode == "add") {
        final newEventDetail = MySongDataFirebase(
            null,
            writerOwnerId!,
            _songName!,
            _songGYNumber!,
            _songTJNumber!,
            _songJanre,
            _songUtubeAddress!,
            _songETC!,
            _createTime!,
            _songFavorite);
        await counter.addData(newEventDetail);
        Navigator.of(context).pop();
      } else {
        final newEventDetail = MySongDataFirebase(
            null,
            writerOwnerId!,
            _songName!,
            _songGYNumber!,
            _songTJNumber!,
            _songJanre,
            _songUtubeAddress!,
            _songETC!,
            // _createTime!
            Timestamp.fromDate(
              DateTime.now(),
            ),
            _songFavorite);
        await counter.updateData(widget.uid, widget.ev!.id, newEventDetail);
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e);
    }
  }
}
