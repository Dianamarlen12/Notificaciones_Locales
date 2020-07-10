import 'package:flutter/material.dart';
import 'note_provider.dart';
import 'note.dart';

class NoteList extends StatefulWidget {
  @override
  NoteListState createState() {
    return new NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: NoteProvider.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final notes = snapshot.data;
            return GridView.builder(
              itemBuilder: (context, index) {
                var accents = Colors.accents;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Note(NoteMode.Editing, notes[index])));
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, bottom: 0, left: 10.0, right: 10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(children: <Widget>[
                              new Expanded(
                                  child: new Container(
                                    height: 170,
                                    decoration: new BoxDecoration(
                                        borderRadius:
                                        new BorderRadius.circular(10.0),
                                        color: Colors.green[300]),
                                    child: new Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        _NoteTitle(notes[index]['title']),
                                        Container(
                                          height: 7,
                                        ),
                                        _NoteText(notes[index]['text']),
                                      ],
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 1.0,
                                    right: 1.0
                                ),
                              ),
                            ])
                          ]),
                    ),
                  ),
                );
              },
              itemCount: notes.length, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2,),
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Note(NoteMode.Adding, null)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;

  _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: TextStyle(fontSize: 25, color: Colors.blue[500]),
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;

  _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(fontSize: 18, color: Colors.black),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}