import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Metodo para la notificacion
  //Declaracion del plugin
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  var initializationSettingAndroid;
  var initializationSettingIOS;
  var initializationSetting;

  void _showNotification() async {
    await _simpleScheduleNotification();
  }

  Future<void> _simpleScheduleNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channerl_id',
      'channel_name',
      'channel_description',
      importance: Importance.Max,
      priority: Priority.Max,
      ticker: 'Test Ticker',
    );
    var IOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, IOSPlatformChannelSpecifics);

    //Obtencion de la fecha del sistema
    var now = new DateTime.now();
    //Notificacion a los 3 minutos
    var reprogram = now.add(Duration(hours: 00, minutes: 00, seconds: 5));
    await flutterLocalNotificationsPlugin.schedule(
      //id aleatorio
        0,
        'This is my Notification',
        'Hello from my first Notification',
        reprogram,
        platformChannelSpecifics,
        payload: 'Hello form my data :)');

    //Ver la hora programada
    Fluttertoast.showToast(
        msg: "Scheduled at time $reprogram",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0);
  }

  @override
  void initState() {
    super.initState();
    initializationSettingAndroid =
    new AndroidInitializationSettings('app_icon');
    initializationSettingIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
    initializationSetting = new InitializationSettings(
        initializationSettingAndroid, initializationSettingIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onSelectNotification: _onSelectNotification);
  }

  //Creacion de los metodos que se ocupan en la parte de arriba
  Future _onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('Notification payload: $payload');
    }
    await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new SecondPage(
              payload: payload,
            )));
    print('Called Ondid Receive local Notification');
  }

  Future _onDidReceiveLocalNotification(int id, String title, String body,
      String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => SecondPage
                              (payload: payload,
                            )));
                  },
                ),
              ],
            ));
    print('Called Ondid Receive local Notification');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("This is a my main page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              child: Icon(Icons.notification_important),
              onPressed: _showNotification,
              color: Colors.red,
            ),
            SizedBox(width: 20, height: 20,),
            MaterialButton(
              color: Colors.blue,
              child: Text("Cancel notification"),
              onPressed: () async {
                await flutterLocalNotificationsPlugin.cancel(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget{

  final String payload;
  const SecondPage({Key key, this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: new Text('$payload'),
        ),
        body: Column(
          children: <Widget> [
            MaterialButton(
                child: Text('Go back...'),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ],
        )
    );
  }
}