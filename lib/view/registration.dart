import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easynema/view/login.dart';
import 'package:easynema/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widgets/Widgets.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

  final firstNameEditingController = TextEditingController();
  final secondNameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmPasswordEditingController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final firstNameField = TextFormField(
      autofocus: false,
      controller: firstNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingresa tu nuombre';
        }
        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
          return 'Por favor ingresa solo letras';
        }
        return null;
      },
      onSaved: (value) {
        firstNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      // Style
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.amber,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Nombre",
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: "Jhon",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.person,
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

    final secondNameField = TextFormField(
      autofocus: false,
      controller: secondNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingresa tu apellido';
        }
        if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
          return 'Por favor ingresa solo letras';
        }
        return null;
      },
      onSaved: (value) {
        secondNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      // Style
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.amber,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        labelText: "Apellido",
        labelStyle: const TextStyle(color: Colors.amber),
        hintText: "Doe",
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(
          Icons.person,
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

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
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
        passwordEditingController.text = value!;
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

    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Por favor ingrese su contraseña otra vez';
        }
        if (passwordEditingController.text != value) {
          return 'Por favor ingrese la misma contraseña';
        }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
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

    final signUp = Material(
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
          signUpF(emailEditingController.text, passwordEditingController.text);
        },
        //personalizacion del texto
        child:
            const TextBrand(text: 'Registrarse', fontWeight: FontWeight.bold),
      ),
    );

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      //color de fondo
      backgroundColor: const Color(0xff21242C),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
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
            //segundo contenedor para texto
            Container(
              //dando un tamaño de espacio desde la izquierda y la derecha para que no este tan pegado
              margin: const EdgeInsets.only(left: 30, right: 20),
              //apegar a la izquierda
              width: w,
              child: Column(
                //alineacion de eje cruzado
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Registro",
                    style: TextStyle(
                        fontSize: 60,
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

            Container(
              //el pading se dio al formulario
              //el pading se añadio despues y da espacios a los lados de los 3 eventos, correo, clave y boton de incio de sesión
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //seccion del logo
                      //SizedBox(
                      //  height: 200,
                      //),
                      //separacion de correo clave e inicio de sesion
                      SizedBox(height: 15),
                      firstNameField,

                      SizedBox(height: 15),
                      secondNameField,
                      //separacion de correo clave e inicio de sesion
                      SizedBox(height: 15),
                      emailField,

                      SizedBox(height: 15),
                      passwordField,

                      SizedBox(height: 15),
                      confirmPasswordField,
                      //separacion de correo clave e inicio de sesion
                      SizedBox(height: 15),

                      signUp,
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "¿Ya tienes cuenta? ",
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
                              "Iniciar sesión",
                              style: TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 30),
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

  void signUpF(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // If the form is valid, display a Snackbar.
      //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));F
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) => {postDetailsToFirestore()})
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

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    userModel.uid = user!.uid;
    userModel.firstName = firstNameEditingController.text;
    userModel.secondName = secondNameEditingController.text;
    userModel.email = user.email;

    // Send email confirmation link
    user.sendEmailVerification().then((_) {
      Fluttertoast.showToast(
          msg: "Se ha enviado un correo de verificación",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((e) {
      Fluttertoast.showToast(
          msg:
              "El correo con el que se registró ya está verificado o es inválido",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toJson())
        .then((value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Loginpagina(),
                ),
              ),
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

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => Loginpagina()),
        (route) => false);
  }
}
