import 'package:easynema/view/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/Widgets.dart';

class RestorePassword extends StatefulWidget {
  const RestorePassword({Key? key}) : super(key: key);

  @override
  State<RestorePassword> createState() => _RestorePasswordState();
}

class _RestorePasswordState extends State<RestorePassword> {
  final _formKey = GlobalKey<FormState>();

  final emailEditingController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
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
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
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

    final restoreButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.amber,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          //me ayuda a definir el tamaño estandar de los botones
          minWidth: MediaQuery.of(context).size.width,
          //evento de que cuando se precione
          //inicio de sesion
          onPressed: () {
            sendRestoreEmail(emailEditingController.text);
          },
          //personalizacion del texto
          child: const TextBrand(
              text: 'Restaurar Contraseña', fontWeight: FontWeight.bold)),
    );

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff21242C),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context)
                .pop(); //pop para regresar a la pantalla anterior
          },
        ),
      ),

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
                    "Restaurar contraseña",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ), //fin del segundo conteiner
            //tercer container para formulario

            SizedBox(
              //el pading se dio al formulario
              //el pading se añadio despues y da espacios a los lados de los 3 eventos, correo, clave y boton de incio de sesión
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(height: 15),
                      emailField,
                      const SizedBox(height: 15),
                      restoreButton,
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Ya tienes cuenta?",
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
                                  builder: (context) => Loginpagina(),
                                ),
                              );
                            },
                            child: Text(
                              " Iniciar session",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),*/
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

  void sendRestoreEmail(String email) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((user) => {
                Fluttertoast.showToast(
                    msg:
                        "Se ha enviado un correo para restablecer la contraseña",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0),
                Navigator.pushAndRemoveUntil(
                    (context),
                    MaterialPageRoute(builder: (context) => Loginpagina()),
                    (route) => false),
              })
          .catchError((e) {
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    }
  }
}
