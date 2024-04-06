import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double? poids;
  bool genre = false;
  double age = 0.0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: setColor(),
              title: Text(widget.title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  textAvecStyle(
                      "Remplissez tous les champs pour obtenir votre besoin journalier en calorie"),
                  Card(
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const Text(
                                "Femme",
                                style: TextStyle(color: Colors.pink),
                              ),
                              Switch(
                                  value: genre,
                                  inactiveTrackColor: Colors.pink,
                                  activeTrackColor: Colors.blue,
                                  onChanged: (bool b) {
                                    setState(() {
                                      genre = b;
                                    });
                                  }),
                              const Text(
                                "Homme",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: setColor()),
                              onPressed: (() => montrerPicker()),
                              child: textAvecStyle(
                                  (age == 0.0)
                                      ? "Appuyer pour entrer votre age"
                                      : "Votre age est de: ${age.toInt()}",
                                  color: Colors.white)),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (String string) {
                              setState(() {
                                poids = double.tryParse(string);
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: "Entrez votre poids en kilos",
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            )));
  }

  Color setColor() {
    if (genre == true) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }

  Future<DateTime?> montrerPicker() async {
  DateTime? choix = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year);
  if (choix != null) {
    var difference = DateTime.now().difference(choix);
    var jour = difference.inDays;
    var ans = (jour / 365);
    setState(() {
      age = ans;
    });
  }
  return choix; // Ajoutez cette ligne pour renvoyer la valeur obtenue
}

  Text textAvecStyle(String data,
      {color = Colors.black, double fontSize = 15}) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: fontSize),
    );
  }
}
