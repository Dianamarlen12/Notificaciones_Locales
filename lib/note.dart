import 'package:flutter/material.dart';
import 'package:notificacioness/note_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'DataTime.dart';

enum NoteMode {
  Editing,
  Adding
}

class Note extends StatefulWidget {

  final NoteMode noteMode;
  final Map<String, dynamic> note;

  Note(this.noteMode, this.note);

  @override
  NoteState createState() {
    return new NoteState();
  }
}

class NoteState extends State<Note> {

  final TextEditingController controllertitulo = TextEditingController();
  final TextEditingController controllerdescripcion = TextEditingController();
  int Num;
  int Hours;
  int Minutes;
  int Seconds;
  int Year;
  int Month;
  int Day;

  String _toTwoDigitString(int value) {
    return value.toString().padLeft(2, '0');
  }
  //List<Map<String, String>> get notes => NoteInheritedWidget.of(context).notes;

  //Declarar los plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  Future scheuleAtParticularTime(DateTime timee) async {
    var time = Time(timee.hour, timee.minute, timee.second);
    print(time.toString());

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'channel_description',
    );

    var IOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, IOSPlatformChannelSpecifics);
    var now = new DateTime.now();

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        widget.note['title'],
        widget.note['text'],
        time,
        platformChannelSpecifics, payload: 'Hola');

    //Ver la hora programada
    Fluttertoast.showToast(
      msg: "Scheduled at time ${time.hour} : ${time.minute} : ${time.second} ",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
    );
  }
  @override
  void initState() {
    super.initState();
    initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: _onSelectNotification);
  }

  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new SecondPage(payload: payload,)));
    print('Called On Select local Notification');
  }

  Future _onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SecondPage(payload: payload,)));
              },
            ),
          ],
        ));
    print('Called On did Receive local Notification');
  }

  @override
  void didChangeDependencies() {
    if (widget.noteMode == NoteMode.Editing) {
      controllertitulo.text = widget.note['title'];
      controllerdescripcion.text = widget.note['text'];
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.noteMode == NoteMode.Adding ? 'Añadir nota' : 'Editar nota'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllertitulo,
              decoration: InputDecoration(labelText: "Titulo de la nota"),
            ),
            new SizedBox(height: 10.0),
            TextFormField(
              controller: controllerdescripcion,
              decoration: InputDecoration(labelText: "Descripcion de la nota"),
            ),
            Container(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _NoteButton('Guardar', Colors.green, () {
                  final title = controllertitulo.text;
                  final text = controllerdescripcion.text;

                  if (widget?.noteMode == NoteMode.Adding) {
                    NoteProvider.insertNote({
                      'title': title,
                      'text': text,
                    });
                  } else if (widget?.noteMode == NoteMode.Editing) {
                    NoteProvider.updateNote({
                      'id': widget.note['id'],
                      'title': controllertitulo.text,
                      'text': controllerdescripcion.text,
                    });
                  }
                  Navigator.pop(context);
                }),
                Container(height: 16.0,),
                _NoteButton('Cancelar', Colors.green, () {
                  Navigator.pop(context);
                }),
                widget.noteMode == NoteMode.Editing ?
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _NoteButton('Eliminar', Colors.green, () async {
                    await NoteProvider.deleteNote(widget.note['id']);
                    Navigator.pop(context);
                  }),
                )
                    : Container()
              ],
            ),
            Container(height: 50.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                  size: 32.0,
                ),
                Text('Schedule notification', style: TextStyle(color: Colors.grey, fontSize: 25),)
              ],
            ),
            Text(""),
            Container(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                      print('change $date in time zone ' + date.timeZoneOffset.inHours.toString());
                      print('change $date in time zone ' + date.timeZoneOffset.inMinutes.toString());
                      print('change $date in time zone ' + date.timeZoneOffset.inSeconds.toString());
                    }, onConfirm: (date) {
                      setState(() {
                        Hours = date.hour;
                        Minutes = date.minute;
                        Seconds = date.second;
                        Year = date.year;
                        Month = date.month;
                        Day = date.day;
                      });
                      print('confirm $date');
                      scheuleAtParticularTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              date.millisecondsSinceEpoch)
                      );
                    }, currentTime: DateTime.now(), locale: LocaleType.es);},
                  child: Text('Click aquí!',
                    style: TextStyle(color: Colors.white),
                  ),
                  height: 50,
                  minWidth: 100,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class SecondPage extends StatelessWidget {

  final String payload;
  const SecondPage({Key key, this.payload}) : super(key:key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: new Text('$payload'),
        ),
        body: Column(
            children: <Widget>[
              MaterialButton(
                  child: Text('Go back...'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),

            ]
        ));
  }
}

class _NoteButton extends StatelessWidget {

  final String _text;
  final Color _color;
  final Function _onPressed;

  _NoteButton(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 100,
      color: _color,
    );
  }
}