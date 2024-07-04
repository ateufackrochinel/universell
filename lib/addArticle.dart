import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'main.dart';
import 'recherche.dart';
import 'global.dart';

// TODO: regex, empêcher les champs de se clear aux erreurs, petit refactor

final nomRegEx = RegExp(r"^[a-zA-Z\d 'àâäéèêëîïôöùûüç]{2,50}$"); // lettres, chiffres, espace, apostrophes, 2 à 50
//final nomRegEx = RegExp(r"^[a-z\d\s']{2,50}$", caseSensitive: false);
final prixRegEx = RegExp(r'^\d+(\.\d+)?$'); // forme d'un int our double
final descRegEx = RegExp(r"^[a-zA-Z\d\s'.!,àâäéèêëîïôöùûüç]{0,300}$"); // littres, chiffres, apostrophes, points, virgules, espace, tab, saut de ligne

class AddArticlePage extends StatefulWidget {
  //AddArticlePage({required Key key}) : super(key: key);
  AddArticlePage({Key? key}) : super(key: key ?? UniqueKey());

  @override
  _AddArticlePage createState() => _AddArticlePage();
}

class _AddArticlePage extends State<AddArticlePage> {

  bool erreurEnvoi = false;
  bool envoiReussi = false;
  bool missingImg = false;
  bool formatInvalide = false;

  File? imageArticle;

  List<String> specialites = [];
  List<String> categories = [];

  // Controleur textfield
  final nomCont = TextEditingController();
  final descCont = TextEditingController();
  final categorieCont = TextEditingController();
  final specialiteCont = TextEditingController();
  final prixCont = TextEditingController();


  @override
  void initState() {
    super.initState();
    chargerSpecialite().then((_){
      setState(() {}); // actualise l'interface
    });
    chargerCategorie().then((_) {
      setState(() {}); //
    });
  }

  Future<void> chargerSpecialite() async {
    var urlRecherche = Uri(
        scheme: 'http',
        host: '10.0.2.2',
        port: 8080,
        path: '/liste_specialite',
    );

    final response = await http.get(
      urlRecherche,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);

      for (int i = 0; i < parsedJson.length; i++) {
        try {
          String uneSpecialite = parsedJson[i]['intitule_specialite'];
          specialites.add(uneSpecialite);
        } catch(e) {
          // TODO
        }
      }
    } else {
      // TODO
    }
  }

  Future<void> chargerCategorie() async {
    var urlRecherche = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 8080,
      path: '/liste_categorie',
    );

    final response = await http.get(urlRecherche);

    if (response.statusCode == 200) {
      final parsedJson = jsonDecode(response.body);

      for (int i = 0; i < parsedJson.length; i++) {
        try {
          String uneCategorie = parsedJson[i]['intitule_categorie'];
          categories.add(uneCategorie);
        } catch(e) {
          // TODO
        }
      }
    } else {
      // TODO
    }
  }



  Future<void> ajouterArticle( File file, String categorie, String specialite, String nom, String prix, String description ) async {
    /*var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiURL + '/ajouter_article'),
    );*/
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8080/ajouter_article'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
      ),
    );

    request.fields['nomarticle'] = nom;
    request.fields['description'] = description;
    request.fields['prix'] = prix;
    request.fields['intitulecategorie'] = categorie;
    request.fields['intitulespecialite'] = specialite;
    request.fields['tokensession'] = tokenSession;
    request.fields['nomsession'] = nomSession;

    var response = await request.send();

    // Check response status code
    if (response.statusCode == 201) {
      setState(() {
        envoiReussi = true;
        erreurEnvoi = false;
        missingImg = false;
        formatInvalide = false;
      });

      // petite attente pour montrer la réussite
      await Future.delayed(const Duration(seconds: 3));

      setCurrentPage(AddArticlePage(), context); // reload la page

    } else {
      setState(() {
        envoiReussi = false;
        erreurEnvoi = true;
        missingImg = false;
        formatInvalide = false;
      });
    }
  }

  Future<void> sendAjout( String categorie, String specialite, String nom, String prix, String description) async {
    try {
      if (imageArticle == null) {
        setState(() {
          envoiReussi = false;
          erreurEnvoi = false;
          missingImg = true;
          formatInvalide = false;
        });
      }

      if (!(nomRegEx.hasMatch(nom)) || !(prixRegEx.hasMatch(prix)) || !(descRegEx.hasMatch(description)) || (categorie == "") || (specialite == "")){
        print(nom);
        print(nomRegEx.hasMatch(nom));
        print(prix);
        print(prixRegEx.hasMatch(prix));
        print(description);
        print(descRegEx.hasMatch(description));
        print(categorie);
        print(specialite);
        setState(() {
          envoiReussi = false;
          erreurEnvoi = false;
          //missingImg = false;
          formatInvalide = true;
        });
      } else if (imageArticle != null) {
        ajouterArticle( imageArticle!, categorie, specialite, nom, prix, description);
      } /*else {

      }*/
    } catch(e) {
      setState(() {
        envoiReussi = false;
        erreurEnvoi = true;
        missingImg = false;
        formatInvalide = false;
      });
    }


  }


  @override
  Widget build(BuildContext context) {

    // Controleur textfield
    /*final nomCont = TextEditingController();
    final descCont = TextEditingController();
    final categorieCont = TextEditingController();
    final specialiteCont = TextEditingController();
    final prixCont = TextEditingController();*/



    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            //child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SelectionImgWidget(
                        onImgSelected: (file) { // metre l'image dans une variable pour pouvoir l'envoyer
                          imageArticle = file;
                        },
                      ),

                      missingImg ? const Text(
                        "Veuillez ajouter une image!",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      erreurEnvoi ? const Text(
                        "Une erreur s'est produite!",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      envoiReussi ? const Text(
                        "Article ajouté!",
                        style: TextStyle(
                            color: Colors.green
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      formatInvalide ? const Text(
                        "Veuillez entrer des valeurs d'un format valide svp!",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      MyTextField("Nom de l'article", nomCont, false),

                      MyTextField("Prix : 00.00", prixCont, false),

                      //MyCategoryDropDown(controllerB: categorieCont),

                      MyDropDown(itemVals: categories, controllerB: categorieCont, nomMenu: "Catégorie"),

                      MyDropDown(itemVals: specialites, controllerB: specialiteCont, nomMenu: "Specialité"),

                      MyTextArea("Description de l'article", descCont, false, 5),

                      MyStyleButton("Ajouter", () => {
                        sendAjout(categorieCont.text, specialiteCont.text, nomCont.text, prixCont.text, descCont.text),
                      }),

                      //MyStyleButton("Retour", () => { setCurrentPage(ConnexionPage(), context) })
                    ]
                )
            //)

          )
        ),

        bottomNavigationBar: BottomAppBar(
          child:
          Container(
            decoration: const BoxDecoration( border: Border(top: BorderSide( width: 1, color: Colors.black))),
            child: SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () => { setCurrentPage(RecherchePage(), context) }, icon: const Icon(Icons.search)),
                  IconButton(onPressed: () => {}, icon: const Icon(Icons.add)),
                  IconButton(onPressed: () => { setCurrentPage(DeconnectPage(), context) }, icon: const Icon(Icons.person)),
                ],
              ),
            ),
          )
        ),
    );
  }
}

class SelectionImgWidget extends StatefulWidget {
  final Function(File) onImgSelected;

  const SelectionImgWidget({Key? key, required this.onImgSelected}) : super(key: key);

  @override
  _SelectionImgWidgetState createState() => _SelectionImgWidgetState();

}

class _SelectionImgWidgetState extends State<SelectionImgWidget> {
  File? fichierImg;

  final selectionImg = ImagePicker();

  Future<void> _selectImage(ImageSource source) async { // selection d'une image
    final fichierChoisi = await selectionImg.pickImage(source: source); // path

    setState(() {

      if (fichierChoisi != null) {
        fichierImg = File(fichierChoisi.path);
      } else {
        fichierImg = null;
      }

    });

    if (fichierImg != null) {
      widget.onImgSelected(fichierImg!);
    }
  }

  File? getFile() {
    return fichierImg;
  }

  /*@override
  void initState() {
    super.initState();
    fichierImg = null;
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              width: 250,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.black,
                    width: 6,
                  ),
                ),
                child: fichierImg != null
                  ? Image.file(
                    fichierImg!,
                    fit: BoxFit.cover
                  )
                  : Image.asset(
                    'images/ajoutimg.png',
                    fit: BoxFit.cover
                  )
              ),
            ),


            MyStyleButton('Prendre depuis la Gallerie', () => { _selectImage(ImageSource.gallery) }), // source = gallerie
            MyStyleButton('Prendre une photo', ()=> { _selectImage(ImageSource.camera) }), // source = camera
            SizedBox(height: 25), // un peu d'espace pour respirer

          ],
        )
    );
  }
}


