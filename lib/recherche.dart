import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'main.dart';
import 'addArticle.dart';
import 'global.dart';

class RecherchePage extends StatefulWidget {
  RecherchePage({Key? key}) : super(key: key ?? UniqueKey());

  @override
  _RecherchePage createState() => _RecherchePage();
}

class _RecherchePage extends State<RecherchePage> {

  List<Widget> affResult = [Text("Les résultats s'afficheront ici"),
                          Image.asset('images/UniverSell_Logo_Small.png')];
  int numberBuild = 0;

  List<String> specialites = [];
  List<String> categories = [];

  // Les Controlleurs
  final termeCont = TextEditingController();
  final categorieCont = TextEditingController();
  final specialiteCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    chargerSpecialite().then((_){
      setState(() {}); // actualise l'interface
    });
    chargerCategorie().then((_) {
      setState(() {}); //
    });

    /*getRes(context, "", "", "").then((_) {
      setState(() {

      });
    });*/
  }

  Future<void> chargerSpecialite() async {
    var urlRecherche = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 8080,
      path: '/liste_specialite',
    );

    final response = await http.get(urlRecherche);

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



  Future<List<Widget>> rechercher( BuildContext context, String categorieR, String specialiteR, String termeRecherche) async {

    List<Widget> resultats = [];

    double width = MediaQuery.of(context).size.width;
    double spacingDivider = 0.01 * width;

    var urlRecherche = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 8080,
      path: '/rechercher_article',
      queryParameters: {
        'intitulecategorie': categorieR,
        'intitulespecialite': specialiteR,
        'motcle': termeRecherche,
        'nomsession': nomSession,
        'tokensession': tokenSession,
      }
    );

    final response = await http.get(urlRecherche);

    if (response.statusCode == 200) {

      final parsedJson = jsonDecode(response.body);

      //print(parsedJson.length);
      //print(parsedJson);

      for (int i = 0; i < parsedJson.length; i++) {
        //print("0");
        var article = parsedJson[i];
        String imageType = article['typeimage'];
        String nomArticle = article['nomarticle'];
        String descArticle = article['description'];
        double prixArt = article['prix'];
        String pseudoVendeur = "Test"; // doit changer et ajouter a l'api
        Uint8List imgBytes = base64Decode(article['tailleimage']);

        //print("1");

        Image imgArticle = Image.memory(imgBytes);

        Widget monRes = ResultatRecherche(imgArticle, nomArticle, pseudoVendeur, descArticle, prixArt, spacingDivider, width * 0.9);

        //print("z");

        resultats.add(monRes);

        //print("oooooooo");
        //print(resultats);

      }


    } else if (response.statusCode == 204) {
      resultats = [const Text("Aucun Résultat!"),
        Image.asset('images/UniverSell_Logo_Small.png')];
    } else {
      resultats = [const Text("Une erreur s'est produite!", style: TextStyle(color: Colors.red),),
        Image.asset('images/UniverSell_Logo_Small.png')];
    }

    //print("2");
    //print(resultats);
    return resultats;

  }

  Future<List<Widget>> faireRecherche( BuildContext context, String categorieR, String specialiteR, String termeRecherche ) async {

    try {
      //print("4");
      return rechercher(context, categorieR, specialiteR, termeRecherche);
    } catch(e) {
      List<Widget> pasResultats = [const Text("Une erreur s'est produite")];
      //print("5");
      return pasResultats;
    }

  }

  Future<void> getRes( BuildContext context, String categorieR, String specialiteR, String termeRecherche ) async {
    var monResultat = await faireRecherche(context, categorieR, specialiteR, termeRecherche);
    setState(() {
      affResult = monResultat;
      numberBuild++;
    });

  }

  Future<void> getBase( BuildContext context) async {
    affResult = await faireRecherche(context, '', '', '');
  }
  
  Future<void> preload(BuildContext context) async {
    getRes(context, "", "", "");
    await Future.delayed(const Duration(milliseconds: 350));
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double spacingDivider = 0.01 * width;

    //var loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vitae congue mauris rhoncus aenean. Scelerisque purus semper eget duis at tellus. Vehicula ipsum a arcu cursus vitae congue mauris. Fusce ut placerat orci nulla pellentesque dignissim enim sit. Neque convallis a cras semper auctor. Quis blandit turpis cursus in hac. Sit amet porttitor eget dolor morbi non arcu. Id faucibus nisl tincidunt eget nullam non nisi. Eget gravida cum sociis natoque penatibus et magnis dis. Urna nunc id cursus metus aliquam eleifend mi.";
    //var loremIpsum = "Lorem";

    //List<Widget> resultats = []

    /*for (int i = 0; i < 5; i++) {
      Widget monRes = ResultatRecherche('images/UniverSell_Logo_Small.png', 'Exemple', 'JamesBond', loremIpsum, spacingDivider, width * 0.9);
      resultats.add(monRes);
    }*/

    // getRes(context, '', '') ; //cause reload infini

    /*resultats = affResult;

    print(resultats);
    print(affResult);
    print(tokenSession);
    print(nomSession);*/


    // Controlleur
    /*final termeCont = TextEditingController();
    final categorieCont = TextEditingController();
    final specialiteCont = TextEditingController();*/

    // Appel recherche initiale
    if (numberBuild < 1){ // version delay du preload, bogue des fois (not sure why)
      //getRes(context, "", "", "");
      //await Future.delayed(const Duration(milliseconds: 150));
      preload(context);
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.15), // Adjust the percentage as needed
          child: Container(
            decoration: const BoxDecoration( border: Border(bottom: BorderSide( width: 1, color: Colors.black))),
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: MyTextField("Terme de recherche", termeCont, false),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            //child: Expanded (child: MyStyleButton("Rechercher", () => {  }))
                            child: MyStyleButton("Rechercher", () => { getRes(context, categorieCont.text, specialiteCont.text, termeCont.text) })
                        )
                      ],
                    )
                ),
                //MyCategoryDropDown(),
                const SizedBox(height: 10),
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          //child: Expanded(child: MyCategoryDropDown() ),
                          //child: MyCategoryDropDown(controllerB: categorieCont),
                          child: MyDropDown(itemVals: categories, controllerB: categorieCont, nomMenu: "Catégorie")
                        ),
                        //Expanded(child: MyCategoryDropDown() ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.42,
                          child: MyDropDown(itemVals: specialites, controllerB: specialiteCont, nomMenu: "Spécialités"),
                        ),
                      ],
                    )
                )
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyCategoryDropDown(),
                    MyStyleButton("Rechercher", () => {  })
                  ],
                )*/
              ],
            ),
          ),
        ),
      ),





      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          width: width,
          //child: Center(
          child: Column(
            /*children: <Widget>[
              MyStyleButton("retour", () => { setCurrentPage(ConnexionPage(), context) }),
            ],*/
            children: affResult,

          ),


        ),
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
                  IconButton(onPressed: () => {  }, icon: const Icon(Icons.search)),
                  IconButton(onPressed: () => { setCurrentPage(AddArticlePage(), context) }, icon: const Icon(Icons.add)),
                  IconButton(onPressed: () => { setCurrentPage(DeconnectPage(), context) }, icon: const Icon(Icons.person)),
                ],
              ),
            ),
          )
      ),

    );
  }
}

class ResultatRecherche extends Column {
  
  ResultatRecherche( Image imgRes, /*String imgR,*/ String nomArt, String vendeur, String description, double prixArt, double spacingDivider, double widthC ) : super (
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: widthC,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 0.35 * widthC,
              height: 0.35 * widthC,
              //child: Image.asset(imgR)
              child: imgRes,
            ), // TODO: changer pour bien prendre l'image reçue
            SizedBox(
              width: widthC * 0.55,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Utf8Decoder().convert(nomArt.codeUnits),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle( fontWeight: FontWeight.bold),
                  ),
                  Text("${prixArt}\$", style: const TextStyle(color: monBleu, fontWeight: FontWeight.bold),),
                  //Text('@$vendeur', style: const TextStyle(color: monBleu), overflow: TextOverflow.ellipsis),
                  Text(Utf8Decoder().convert(description.codeUnits), maxLines: 3, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      //MyDivider(spacingDivider),
      MyOrangeDivider(spacingDivider),
      const SizedBox(height: 10),
    ],
  );
  
}
