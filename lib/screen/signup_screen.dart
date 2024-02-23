import 'dart:io';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  File? image;
  final picker = ImagePicker();

  Future selImage(op) async {
    XFile? pickedFile;

    if (op == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      }
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final conName = TextEditingController();
    final conEmail = TextEditingController();
    final conPwd = TextEditingController();

    final profileImage = CircleAvatar(
      radius: 50,
      backgroundImage: image != null ? FileImage(image!) : null,
      child: IconButton(
        icon: const Icon(Icons.camera_alt),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(20), // Añade un padding si lo deseas
                width: MediaQuery.of(context)
                    .size
                    .width, // Establece el ancho al máximo
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Evita que el BottomSheet sea más grande que el contenido
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[900],
                        fixedSize: const Size(200, 0),
                      ),
                      onPressed: () {
                        selImage(2);
                      },
                      label: const Text(
                        "Seleccionar imagen",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      "O",
                      style: TextStyle(fontSize: 20),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[900],
                        fixedSize: const Size(200, 0),
                      ),
                      onPressed: () {
                        selImage(1);
                      },
                      label: const Text(
                        "Tomar foto",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );

    final txtName = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu nombre.';
        }
        return null;
      },
      keyboardType: TextInputType.name,
      controller: conName,
      decoration: InputDecoration(
        hintText: "Name",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue, // Color del borde
            width: 2.0, // Ancho del borde
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blueAccent, // Color del borde enfocado
            width: 2.0, // Ancho del borde enfocado
          ),
          borderRadius: BorderRadius.circular(10), // Radio del borde enfocado
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red, // Color del borde de error
            width: 2.0, // Ancho del borde de error
          ),
          borderRadius: BorderRadius.circular(10), // Radio del borde de error
        ),
      ),
    );

    final txtEmail = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa tu email.';
        }
        if (!EmailValidator.validate(value)) {
          return 'Ingrese un email válido';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      controller: conEmail,
      decoration: InputDecoration(
        hintText: "Email",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue, // Color del borde
            width: 2.0, // Ancho del borde
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blueAccent, // Color del borde enfocado
            width: 2.0, // Ancho del borde enfocado
          ),
          borderRadius: BorderRadius.circular(10), // Radio del borde enfocado
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red, // Color del borde de error
            width: 2.0, // Ancho del borde de error
          ),
          borderRadius: BorderRadius.circular(10), // Radio del borde de error
        ),
      ),
    );

    final pwdUser = TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingresa una contraseña.';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      controller: conPwd,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue, // Color del borde
            width: 2.0, // Ancho del borde
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blueAccent, // Color del borde enfocado
            width: 2.0, // Ancho del borde enfocado
          ),
          borderRadius: BorderRadius.circular(10), // Radio del borde enfocado
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red, // Color del borde de error
            width: 2.0, // Ancho del borde de error
          ),
          borderRadius: BorderRadius.circular(10), // Radio del borde de error
        ),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.topRight,
              colors: [
                Colors.orange[900]!,
                const Color.fromARGB(255, 232, 104, 0),
              ],
            ),
          ),
        ),
        title: const Text("Sign Up"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange[900]!,
              Colors.orange[800]!,
              Colors.orange[400]!,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Crear una cuenta",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: <Widget>[
                              Positioned(
                                top:
                                    0, // Ajusta este valor según tus necesidades
                                left:
                                    0, // Ajusta este valor según tus necesidades
                                child: profileImage,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                        BorderSide(color: Colors.grey[200]!),
                                  ),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    txtName,
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    txtEmail,
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    pwdUser
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.orange[900], // Color de fondo del botón
                            padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30), // Espaciado interno del botón
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Borde del botón
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('¡Formulario válido!'),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white, // Color del texto del botón
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
