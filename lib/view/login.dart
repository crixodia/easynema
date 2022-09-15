import 'package:easynema/view/home_screen.dart';
import 'package:easynema/view/registration.dart';
import 'package:easynema/view/restore_password.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/Widgets.dart';

class Loginpagina extends StatefulWidget {
  const Loginpagina({Key? key}) : super(key: key);

  @override
  State<Loginpagina> createState() => _LoginpaginaState();
}

class _LoginpaginaState extends State<Loginpagina> {
//clave del formulario para incicio de sesion

  final _formkey = GlobalKey<FormState>();

//controlador de edicion, controlador de correo electronico y de clave

  final TextEditingController emailController =
      TextEditingController(); //correo

  final TextEditingController passwordController =
      TextEditingController(); //clave

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    const Text(
      "Inicio de sesion",
      textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: 220,
        color: Colors.white,
      ),
    );

    //campo del correo electronico
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress, //entrada de tipo email
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingrese su correo electronico';
        }
        if (!RegExp(
                r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Por favor ingrese un correo electronico valido';
        }
        return null;
      },
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      // Style
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.amber,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Correo electrónico",
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: "micorreo@ejemplo.com",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.mail,
          color: Colors.amber,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

    //campo de la contraseña
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      //el texto se oculte para la clave
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingrese su contraseña';
        }
        if (!RegExp(
                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[$@$!%*?&])[A-Za-z\d$@$!%*?&]{8,}")
            .hasMatch(value)) {
          return 'Por favor ingrese una contraseña valida'; //TODO: agregar mensaje de error
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },

      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.amber,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Contraseña",
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: "********",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.vpn_key,
          color: Colors.amber,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.amber),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

// Boton de inicio

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.amber,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          height: 50,
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: const TextBrand(
              text: 'Iniciar Sesión', fontWeight: FontWeight.bold)),
    );

    // Google button with icon and google color
    final gbutton = FloatingActionButton.extended(
      heroTag: "g",
      elevation: 5,
      onPressed: () {
        //signInWithGoogle();
      },
      label: const Text("Iniciar Sesión con Google",
          style: TextStyle(fontSize: 15, color: Colors.black)),
      icon: Image.asset('lib/img/google.png', height: 32, width: 32),
      backgroundColor: Colors.white,
    );

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      //color de fondo
      backgroundColor: const Color(0xff21242C),
      //elmentos en forma de columna
      body: SingleChildScrollView(
        //con single childe scrol view se arregla el pading, los problemas del letrero amarillo con negro al lanzar el teclado
        child: Column(
          children: [
            //contenedor para la imagen
            Container(
              width: w,
              height: h * 0.4,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("lib/img/cinemalogin.jpg"),
                      //extender la imagen a los lados
                      fit: BoxFit.cover)),
            ),
            //segundo contenedor para texto
            Container(
              //dando un tamaño de espacio desde la izquierda y la derecha para que no este tan pegado
              margin: const EdgeInsets.only(left: 30, right: 20),
              //apegar a la izquierda
              width: w,
              child: Column(
                //alineacion de eje cruzado
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(height: 20),
                  Text(
                    "Inicio de sesión",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "Ingresa tus datos",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ), //fin del segundo conteiner
            //tercer container para formulario

            SizedBox(
              //el pading se dio al formulario
              //el pading se añadio despues y da espacios a los lados de los 3 eventos, correo, clave y boton de incio de sesión
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //seccion del logo
                      //SizedBox(
                      //  height: 200,
                      //),
                      //separacion de correo clave e inicio de sesion
                      const SizedBox(height: 15),

                      emailField,
                      //separacion de correo clave e inicio de sesion
                      const SizedBox(height: 30),

                      passwordField,
                      //separacion de correo clave e inicio de sesion
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "¿Olvidaste tú contraseña? ",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          //opcion registrarse con negrita
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RestorePassword()));
                            },
                            child: const Text(
                              "Recuperar",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),

                      loginButton,
                      //separacion de correo clave e inicio de sesion
                      const SizedBox(height: 10),

                      //Botones de google y facebook
                      //fbbutton,
                      //SizedBox(height: 10),

                      //gbutton,
                      //const SizedBox(height: 10),

                      //Texto de no tienes cuenta ?, registrate
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "¿No tienes cuenta? ",
                            //opcion registrarse con negrita
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Registration()));
                            },
                            child: const Text(
                              "Registrarse",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Funcion de inicio de sesion
  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      // Login only if the user has verified their email durging sign-up.

      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => {
                if (_auth.currentUser!.emailVerified)
                  {
                    Fluttertoast.showToast(
                        msg: "Bienvenid@",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0),
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const HomeScreen()))
                  }
                else
                  {
                    Fluttertoast.showToast(
                        msg:
                            "Verifica tu correo electrónico para iniciar sesión",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0),
                  }
              })
          .catchError((e) {
        Fluttertoast.showToast(
            msg: "Error al iniciar sesión",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }
}
