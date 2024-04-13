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
  int radioSelectionne = 0;
  double? poids;
  bool genre = false;
  double age = 0.0;
  double taille = 170.0;
  Map mapActipe = {
    "Faible": 0,
    "Modere": 1,
    "Forte": 2,
  };
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: setColor(),
              title: Text(widget.title),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  padding(),
                  textAvecStyle(
                      "Remplissez tous les champs pour obtenir votre besoin journalier en calorie"),
                      padding(),
                  Card(
                      elevation: 10,
                      child: Column(
                        children: <Widget>[
                          padding(),
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
                          padding(),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: setColor()),
                              onPressed: (() => montrerPicker()),
                              child: textAvecStyle(
                                  (age == 0.0)
                                      ? "Appuyer pour entrer votre age"
                                      : "Votre age est de: ${age.toInt()}",
                                  color: Colors.white)),
                          padding(),
                          textAvecStyle(
                              "Votre taille est de : ${taille.toInt()}",
                              color: setColor()),
                          padding(),
                          Slider(
                              value: taille,
                              activeColor: setColor(),
                              onChanged: (double d) {
                                setState(() {
                                  taille = d;
                                });
                              },
                              max: 215.0,
                              min: 100.0),
                          padding(),
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
                          padding(),
                          textAvecStyle("Quelle est votre activité sportive:", color: setColor()),
                          padding(),
                          rowRadio(),
                          padding(),
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

  Padding padding() {
    return const Padding(padding: EdgeInsets.only(top: 20));
  }

  Row rowRadio(){
    List<Widget> l = [];
    mapActipe.forEach((key, value) {
      Column colonne = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
            activeColor: setColor(),
            value: value, 
          groupValue: radioSelectionne, 
          onChanged:  (dynamic i){
            setState(() {
              radioSelectionne = i;
            });
          } ),
          textAvecStyle(key, color: setColor()),

        ],
      );
      l.add(colonne);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children : l, 
    );
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
