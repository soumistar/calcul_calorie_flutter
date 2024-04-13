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
  late int calorieBase;
  late int calorieAvecActivite;
  double? poids;
  bool genre = false;
  double age = 0.0;
  double taille = 170.0;
  Map mapActipe = {
    0: "Faible",
    1: "Modere",
    2: "Forte",
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
                              min: 0.0),
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
                          textAvecStyle("Quelle est votre activité sportive:",
                              color: setColor()),
                          padding(),
                          rowRadio(),
                          padding(),
                        ],
                      )),
                  padding(),
                  ElevatedButton(
                      onPressed: calculerNomvreDeCalorie,
                      style:
                          ElevatedButton.styleFrom(backgroundColor: setColor()),
                      child: textAvecStyle("Calculer", color: Colors.white)),
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

  Row rowRadio() {
    List<Widget> l = [];
    mapActipe.forEach((key, value) {
      Column colonne = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelectionne,
              onChanged: (dynamic i) {
                setState(() {
                  radioSelectionne = i;
                });
              }),
          textAvecStyle(value, color: setColor()),
        ],
      );
      l.add(colonne);
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,
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

  void calculerNomvreDeCalorie() {
    if (age != 0 && poids != 0 && radioSelectionne != 0) {
      if (genre) {
        calorieBase =
            (66.4730 + (13.7516 * poids!) + (5.0033 * taille) - (6.7550 * age))
                .toInt();
      } else {
        calorieBase =
            (655.0955 + (9.5634 * poids!) + (1.8496 * taille) - (4.6756 * age))
                .toInt();
      }
      switch (radioSelectionne) {
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }

      setState(() {
        dialogue();
      });
    } else {
      alerte();
    }
  }

  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return SimpleDialog(
            title:
                textAvecStyle("Votre bessoin en calories", color: setColor()),
            contentPadding: EdgeInsets.all(15),
            children: <Widget>[
              padding(),
              textAvecStyle("Votre bessoin en base est de : $calorieBase"),
              padding(),
              textAvecStyle(
                  "Votre bessoin en activité sportive est de : $calorieAvecActivite"),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(buildContext).pop();
                },
                child: textAvecStyle("OK", color: Colors.white),
                style: ElevatedButton.styleFrom(backgroundColor: setColor()),
              )
            ],
          );
        });
  }

  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: textAvecStyle("Error"),
            content: textAvecStyle("Tous les champs ne sont pas remplies"),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(buildContext).pop();
                  },
                  child: textAvecStyle("OK", color: Colors.red))
            ],
          );
        });
  }
}
