import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/painting.dart';
import 'notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
// TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.grey
      ),
      home: Login(),
    );
  }
}

class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Text("OPERACIONES",
                style: TextStyle(
                    fontFamily: 'Carter', fontSize: 30, color: Colors.white)),
            decoration: BoxDecoration(color: Colors.black),
          ),
          ListTile(
            title: Text("RECORDATORIOS",
              style: TextStyle(fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black),),
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new NoteList()
                  ));
            },),
      ]),);
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  //Almacenar los datos
  final _controllerUsuario = TextEditingController();
  final _controllerContrasena = TextEditingController();
  final _controllerCorreo = TextEditingController();

  String _usuario;
  String _contrasena;
  String _email;

  String nombre = '';
  String contrasena = '';
  String correo = '';


  String nombreGuardado = '';
  String correoGuardado = '';

  @override
  Widget build(BuildContext context) {
    setState(() {
      obtenerPreferencias();
    });

    return Scaffold(
      //backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('CREA TU CUENTA',
          style: TextStyle(color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                child: Image.network(
                    'https://www.iaipanama.org/images/img-demo/usuario-registrados.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Text("Datos Personales", textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: Form(
              //Mandar a traer la key que se encuentra en la parte de arriba
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 25),
                    Padding(padding: const EdgeInsets.all(6.0),
                      child: Row(children: <Widget>[
                        IconButton(icon: Icon(
                            Icons.mail, size: 35, color: Colors.white),
                            onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 25.0, left: 25.0),
                            child: TextFormField(controller: _controllerCorreo,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: (valor) => _email = valor,
                              decoration: InputDecoration(labelText: 'Email'),
                              validator: (val) => !val.contains('@') ? 'Correo incorrecto' : null,
                            ),
                          ),
                        )
                      ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(padding: const EdgeInsets.all(6.0),
                      child: Row(children: <Widget>[
                        IconButton(icon: Icon(
                            Icons.person, size: 35, color: Colors.white),
                            onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 25.0, left: 25.0),
                            child: TextFormField(controller: _controllerUsuario,
                              onSaved: (valor) => _usuario = valor,
                              decoration: InputDecoration(labelText: 'Usuario'),
                              validator: (val) => val.length == 0 ? 'Inténtelo de nuevo' : null,
                            ),
                          ),
                        )
                      ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Padding(padding: const EdgeInsets.all(6.0),
                      child: Row(children: <Widget>[
                        IconButton(icon: Icon(
                            Icons.lock, size: 35, color: Colors.white),
                            onPressed: null),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 25.0, left: 25.0),
                            child: TextFormField(
                              controller: _controllerContrasena,
                              onSaved: (valor) => _contrasena = valor,
                              decoration: InputDecoration(
                                  labelText: 'Contraseña'),
                            ),
                          ),
                        )
                      ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    Padding(padding: const EdgeInsets.all(35.0),
                      child: ClipRRect(borderRadius: BorderRadius.circular(25),
                        child: Container(
                          height: 60,
                          width: 200,
                          child: RaisedButton(onPressed: () {
                            //Para ver si funciona el boton y comprobar en la consola
                            //print("Hola Mundo");
                            //Mande a traer la funcion de arriba
                            final form = formKey.currentState;
                            if (form.validate()) {
                              setState(() {
                                nombre = _controllerUsuario.text;
                                correo = _controllerCorreo.text;
                                guardarPreferencias();
                              });
                              pushPage();
                            }
                          },
                            color: Colors.black,
                            child: Text(
                              'Registrarme',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  //Iniciar sesion
  @override
  void initState() {
    super.initState();
    _Iniciar();
  }

  Future _Iniciar() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool('_registro')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return new Scaffold(
          //backgroundColor: Colors.green[100],
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'Recordatorios',
              style: TextStyle(color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,),
            ),
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25),
                child: Center(
                  child: Container(
                    width: 350,
                    height: 350,
                    child: Image.network(
                        'https://www.flaticon.es/premium-icon/icons/svg/2043/2043686.svg'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Text("RECORDATORIOS", textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 100.0),
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: ClipRRect(borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 60,
                    width: 60,
                    child: MaterialButton(
                      onPressed: () {
                        cerrarSesion();
                      },
                      color: Colors.black,
                      child: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ),
            ],),
          endDrawer: MenuLateral(),
        );
      }));
    }
  }

  //Nos manda a otra pagina en donde se guardaran los datos
  void pushPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('_registro', true);

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new Scaffold(
        //backgroundColor: Colors.green[100],
        appBar: AppBar(
          //backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'RECORDATORIOS',
            style: TextStyle(color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,),
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25),
              child: Center(
                child: Container(
                  width: 350,
                  height: 350,
                  child: Image.network(
                      'https://www.flaticon.es/premium-icon/icons/svg/2043/2043686.svg'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Text("RECORDATORIOS", textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 100.0),
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(25),
                child: Container(
                  height: 60,
                  width: 60,
                  child: MaterialButton(
                    onPressed: () {
                      cerrarSesion();
                    },
                    color: Colors.black,
                    child: Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
          ],),
        endDrawer: MenuLateral(),
      );
    }));
  }


  Future<void> guardarPreferencias() async {
    SharedPreferences datos = await SharedPreferences.getInstance();
    datos.setString('nombre', _controllerUsuario.text);
    datos.setString('correo', _controllerCorreo.text);
  }

  Future<void> obtenerPreferencias() async {
    SharedPreferences datos = await SharedPreferences.getInstance();
    setState(() {
      nombreGuardado = datos.get('nombre') ?? nombre;
      correoGuardado = datos.get('correo') ?? correo;
    });
  }

  Future<void> cerrarSesion() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('_registro', false);
    setState(() {
      nombreGuardado = '';
      correoGuardado = '';
    });
    Navigator.pop(context);
  }
}