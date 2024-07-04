// @dart=2.9
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'addArticle.dart';
import 'recherche.dart';
import 'global.dart';

void main() => runApp(MyApp());


///////////////////////////////////////////////////////
// Global Variables and Const

// Couleurs
const monBleu = Color(0xFF3190FF);
const monFillBleu = Color(0x1A3190FF);

// Session
String nomSession = ""; // nom de Session Actuel
String tokenSession = ""; // token de session Actuel

// Lien de l'API
const String apiURL = "10.0.2.2:8080";

// RegEx
// adresse email @courrier.uqam.ca et @ens.uqam.ca seulement
final emailRegEx = RegExp(r'^[\w-\.]+@(courrier|ens)\.uqam\.ca$');
// password: 5 char min, au moins 1 lettre, au moins 1 chiffre (charactères spéciaux interdits)
final passRegEx = RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{5,}$');
// Code Permanent: 4 majuscules suivies de 6 à 10 chiffres
final codePermRegEx = RegExp(r'^[A-Z]{4}\d{6,10}$');
// Pseudo: taille 2 minimum, taille 25 max, lettres et chiffres seulement
final pseudoRegex = RegExp(r'^[a-zA-Z0-9]{2,25}$');
// Code de verif: entre 5 et 7 de taille, seulement lettres et chiffres
final codeVerifRegEx = RegExp(r'^[a-zA-Z0-9]{5,7}$');

// preload email au besoin (pour la confirmation)
String preloadMail = null;
// pour le changement de mdp si oublié
String preloadMailFMDP = null;

Widget currentPage = ConnexionPage();
//////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////
// App Creation and Navigation
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: currentPage,
      ),
      routes: <String, WidgetBuilder> {
        '/connexion' : (BuildContext context) => ConnexionPage(),
        '/deconnexion' : (BuildContext context) => DeconnectPage(),
        '/inscription' : (BuildContext context) => InscriptionPage(),
        '/confirmIns' : (BuildContext context) => ConfirmInscPage(),
        //'/confirmInsPreload' : (BuildContext context) => ConfirmInscPage.preloadEmail(preloadMail),
        '/forgotPass' : (BuildContext context) => ForgottenPassPage(),
        '/changePassWCode' : (BuildContext context) => ChangerPassPage(),
        '/addArticle' : (BuildContext context) => AddArticlePage(),
        '/recherche' :(BuildContext context) => RecherchePage(),
      },
    );
  }
}

// changer de page
void setCurrentPage(Widget pageSet, BuildContext context) {
  currentPage = pageSet;
  String nomRoute = "/connexion";
  if (pageSet is DeconnectPage) nomRoute = "/deconnexion";
  if (pageSet is InscriptionPage) nomRoute = "/inscription";
  if (pageSet is ConfirmInscPage) nomRoute = "/confirmIns";
  if (pageSet is ForgottenPassPage) nomRoute = "/forgotPass";
  if (pageSet is ChangerPassPage) nomRoute = "/changePassWCode";
  if (pageSet is AddArticlePage) nomRoute = "/addArticle";
  if (pageSet is RecherchePage) nomRoute = "/recherche";
  Navigator.pop(context);
  Navigator.pushNamed(context, nomRoute);
  print(Navigator);
}
////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////
// Fonctions

// authentifier
Future<bool> authentif(email, pass) async {
  print(email);
  print(pass);
  // TODO
  var url = Uri.http(apiURL, '/login');

  var response = await http.post(url, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({ 'email' : email, 'password': pass}));
  if (response.statusCode == 200) {
    print("Connexion réussi");
    print(response.statusCode);
    print(response.body);
    final parsedJson = jsonDecode(response.body);
    nomSession = parsedJson['sessionName'];
    tokenSession = parsedJson['sessionToken'];

    return true;

  } else {
    print('Il y a anguille sous roche!');
    print(response.statusCode);
    print(response.body);
    return false;
  }
  //return true;
  //return false;
}

bool isValidConnect(String email, String pass) {
  // adresse email @courrier.uqam.ca et @ens.uqam.ca seulement
  final emailRegEx = RegExp(r'^[\w-\.]+@(courrier|ens)\.uqam\.ca$');
  // password: 5 char min, au moins 1 lettre, au moins 1 chiffre (charactères spéciaux interdits)
  final passRegEx = RegExp(r'^(?=.*?[A-Za-z])(?=.*?[0-9]).{5,}$');

  return emailRegEx.hasMatch(email) && passRegEx.hasMatch(pass);
}

// gestion de du login
/*void login(email, pass, StatelessWidget pageSet, BuildContext context) async {
  if (await authentif(email, pass)) {
    setCurrentPage(pageSet, context);
  } else {
    // TODO
  }
}*/

////////////////////////////////////////////////////////////////////
// Pages
class ConnexionPage extends StatefulWidget {
  ConnexionPage({Key key}) : super(key: key);

  @override
  _ConnexionPage createState() => _ConnexionPage();
}

class _ConnexionPage extends State<ConnexionPage> {

  bool connectFailure = false; // si la connexion échoue
  bool notValidConnect = false; // si la connexion n'est pas valide

  // gestion de du login
  void login(email, pass, Widget pageSet, BuildContext context) async {

    if (!isValidConnect(email, pass)) {
      setState(() {
        notValidConnect = true;
      });
    } else if (await authentif(email, pass)) {
      setCurrentPage(pageSet, context);
      connectFailure = false;
    } else {
      setState(() {
        connectFailure = true;
        notValidConnect = false;
      });
    }
    print(notValidConnect);
    print(connectFailure);

    //setCurrentPage(AddArticlePage(), context);

  }


  @override
  Widget build(BuildContext context) {
    //connectFailure = false;
    //print(connectFailure);
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

    // spacing
    double spacingDivider = 0.01 * width;

    // Style Border textfield
    BorderRadius radiusTextField = BorderRadius.circular(8);
    BorderSide bordureTailleCouleur = BorderSide(width: 12, color: Colors.black);
    OutlineInputBorder bordureText = OutlineInputBorder(borderRadius: radiusTextField, borderSide: bordureTailleCouleur);

    // Controleur textfield
    final email = TextEditingController();
    final password = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/UniverSell_Logo_Small.png'),

              Divider(
                color: monBleu,// Colors.black, //color of divider
                height: 10, //height spacing of divider
                thickness: 2, //thickness of divier line
                indent: spacingDivider, //spacing at the start of divider
                endIndent: spacingDivider, //spacing at the end of divider
              ),

              notValidConnect ? Center(
                child: Text(
                  "Format de l'Adresse Courriel ou du Mot de passe invalide",
                  style: TextStyle(
                      color: Colors.red
                  ),
                  textAlign: TextAlign.center,
                ),) : SizedBox(),

              connectFailure ? Text(
                'Adresse Courriel ou Mot de passe invalide',
                style: TextStyle(
                    color: Colors.red
                ),
                textAlign: TextAlign.center,
              ) : SizedBox(),

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: monFillBleu,
                  border: bordureText,
                  hintText: 'Adresse Courriel',
                ),
                controller: email,
              ),

              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: monFillBleu,
                  border: bordureText,
                  hintText: 'Mot de passe',
                ),
                controller: password,
                obscureText: true,
              ),

              TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                ),
                onPressed: () { setCurrentPage( ForgottenPassPage(), context); },
                child: Text('Mot de passe oublié...'),
              ),

              OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 2.0) )),
                  backgroundColor: MaterialStateProperty.all<Color>(monBleu),

                ),
                onPressed: () { login(email.text, password.text, RecherchePage(), context); },
                child: Text(
                  'Connexion',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),

              Divider(
                color: monBleu, //color of divider
                height: 5, //height spacing of divider
                thickness: 2, //thickness of divier line
                indent: spacingDivider, //spacing at the start of divider
                endIndent: spacingDivider,// 5, //spacing at the end of divider
              ),

              OutlinedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 2.0) )),
                  backgroundColor: MaterialStateProperty.all<Color>(monBleu),

                ),
                onPressed: () { setCurrentPage( InscriptionPage(), context); },
                child: Text(
                    'Inscription',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              )


            ],
          ),
        ),
      )
    );
  }
}

class DeconnectPage extends StatelessWidget {

  Future<void> deconnection(BuildContext context) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:8080/ajouter_article'),
    );

    request.fields['nomsession'] = nomSession;
    request.fields['tokensession'] = tokenSession;

    var response = await request.send(); // requete pour supprimer la session

    // TODO: Gestion selon le code

    setCurrentPage( ConnexionPage(), context); // Naviguer vers la page de connexion

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  //onPressed: () { setCurrentPage( ConnexionPage(), context); },
                  onPressed: () { deconnection(context); },
                  child: Text('Déconnexion'),
                )
              ]
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
                  IconButton(onPressed: () => { setCurrentPage(AddArticlePage(), context) }, icon: const Icon(Icons.add)),
                  IconButton(onPressed: () => {  }, icon: const Icon(Icons.person)),
                ],
              ),
            ),
          )
      ),
    );
  }
}

class InscriptionPage extends StatefulWidget {
  InscriptionPage({Key key}) : super(key: key);

  @override
  _InscriptionPage createState() => _InscriptionPage();
}

class _InscriptionPage extends State<InscriptionPage> {

  // Text controllers
  final email = TextEditingController();
  final codeP = TextEditingController();
  final pseud = TextEditingController();
  final motPasse = TextEditingController();
  final motPasseConf = TextEditingController();

  // boolean pour affichage
  bool formatInvalide = false;
  bool notSamePass = false;
  bool conflictMail = false;
  bool erreurInterne = false;

  Future<void> sendInscription(BuildContext context, String AEmail, String codePerm, String pseudo, String mdp, String mdpConf ) async {
    // 1. REGEX et meme mot de passe 2 fois: Done
    if (mdp != mdpConf) {
      setState(() {
        notSamePass = true;
      });
    } else {
      setState(() {
        notSamePass = false;
      });
      if (emailRegEx.hasMatch(AEmail) && passRegEx.hasMatch(mdp) && codePermRegEx.hasMatch(codePerm) && pseudoRegex.hasMatch(pseudo)) {
        setState(() {
          formatInvalide = false;
        });
        // 2. Requête à l'API: DONE et gestion d'erreur: TODO
        var url = Uri.http(apiURL, '/createuser');

        var response = await http.post(url, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({ 'email' : AEmail, 'password': mdp, 'pseudo': pseudo, 'CodePerm': codePerm}));
        if (response.statusCode == 201) {
          print("Demande d'inscription réussi");
          formatInvalide = false;
          notSamePass = false;
          conflictMail = false;
          erreurInterne = false;

          // 3. navigation vers la page de confirmation et preload email
          print(AEmail);
          preloadMail = AEmail;
          print(preloadMail);
          Navigator.pop(context);
          Navigator.pushNamed(context, '/confirmIns');
          //preloadMail = null;
          print(Navigator);


        } else if (response.statusCode == 409){
          print('Il y a anguille sous roche!');
          print(response.statusCode);
          print(response.body);

          setState(() {
            formatInvalide = false;
            notSamePass = false;
            conflictMail = true;
            erreurInterne = false;
          });

        } else {
          print('Il y a anguille sous roche!');
          print(response.statusCode);
          print(response.body);

          setState(() {
            formatInvalide = false;
            notSamePass = false;
            conflictMail = false;
            erreurInterne = true;
          });
        }



      } else {
        setState(() {
          formatInvalide = true;
        });

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    /*double height = MediaQuery
        .of(context)
        .size
        .height;*/

    // spacing
    double spacingDivider = 0.01 * width;

    // Style Border textfield
    BorderRadius radiusTextField = BorderRadius.circular(8);
    BorderSide bordureTailleCouleur = BorderSide(
        width: 12, color: Colors.black);
    OutlineInputBorder bordureText = OutlineInputBorder(
        borderRadius: radiusTextField, borderSide: bordureTailleCouleur);

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/UniverSell_Logo_Small.png'),

                  Container(
                    //margin: EdgeInsets.only(bottom: 10.0),
                    child: MyDivider(spacingDivider),
                  ),
                  //MyDivider(spacingDivider),

                  formatInvalide ? Text(
                    "Le format d'un ou de plusieurs champs est invalide",
                    style: TextStyle(
                        color: Colors.red
                    ),
                    textAlign: TextAlign.center,
                  ) : SizedBox(),

                  conflictMail ? Text(
                    "Adresse Courriel déjà utilisée",
                    style: TextStyle(
                        color: Colors.red
                    ),
                    textAlign: TextAlign.center,
                  ) : SizedBox(),

                  erreurInterne ? Text(
                    "Une erreur s'est produite...",
                    style: TextStyle(
                        color: Colors.red
                    ),
                    textAlign: TextAlign.center,
                  ) : SizedBox(),

                  MyTextField('Adresse Courriel', this.email, false),

                  MyTextField('Code Permanent', codeP, false),

                  MyTextField('Pseudo', pseud, false),

                  MyTextField('Mot de Passe', motPasse, true),

                  notSamePass ? Text(
                    'Veuillez rentrer le même mot de passe...',
                    style: TextStyle(
                        color: Colors.red
                    ),
                    textAlign: TextAlign.center,
                  ) : SizedBox(),

                  Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: MyTextField('Confirmez le Mot de Passe', motPasseConf, true),
                  ),

                  //MyTextField('Confirmez le Mot de Passe', motPasseConf, true),

                  /*TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                    ),
                    onPressed: () { setCurrentPage( ConfirmInscPage(), context); },
                    child: Text('Confirmer mon inscription...'),
                  ),*/ // confirmer directement, bouton fonctionnel, enlevé pour le moment

                  MyStyleButton("S'inscrire", () => sendInscription(context, this.email.text, codeP.text, pseud.text, motPasse.text, motPasseConf.text) ),

                  MyDivider(spacingDivider),

                  MyStyleButton("Connexion", () => setCurrentPage(ConnexionPage(), context)),

                ]
            )
        )
      )
    );
  }
}


// Page de confirmation d'identité
class ConfirmInscPage extends StatefulWidget {
  ConfirmInscPage({Key key}) : super(key: key);

  @override
  _ConfirmInscPage createState() => _ConfirmInscPage();
}
class _ConfirmInscPage extends State<ConfirmInscPage> {

  // Txt controllers pour les textfields
  final email = TextEditingController();
  final code = TextEditingController();

  // bool pour le format et erreur
  bool invalidFormat = false;
  bool inconnu = false;
  bool mauvaisCode = false;
  bool erreurInterne = false;

  // bool fonctionne
  bool inscrit = false;

  Future<void> confirmerInscription( String aEmail, String aCode) async {
    // 1. Verif Regex
    if (emailRegEx.hasMatch(aEmail) && codeVerifRegEx.hasMatch(aCode)) {
      setState(() {
        invalidFormat = false;
      });
      // 2. requête à l'API: Done et gestion erreur: TODO
      var url = Uri.http(apiURL, '/verificationmail');
      var response = await http.post(url, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({ 'email' : aEmail, 'codeverif': aCode}));
      if (response.statusCode == 201) {
        print("Inscription réussie");
        print(response.statusCode);
        print(response.body);

        setState(() {
          invalidFormat = false;
          inconnu = false;
          mauvaisCode = false;
          erreurInterne = false;

          inscrit = true;
        });

        await Future.delayed(Duration(seconds: 2)); // attendre 1 sec pour voir le message

        setCurrentPage(ConnexionPage(), context); // seulement si succès

      } else if (response.statusCode == 404) {
        print("!!!!!");

        setState(() {
          invalidFormat = false;
          inconnu = true;
          mauvaisCode = false;
          erreurInterne = false;

          inscrit = false;
        });

      } else if (response.statusCode == 401) {
        print("Mauvais Code");

        setState(() {
          invalidFormat = false;
          inconnu = false;
          mauvaisCode = true;
          erreurInterne = false;

          inscrit = false;
        });

      } else {
        print('Il y a anguille sous roche!');
        print(response.statusCode);
        print(response.body);

        setState(() {
          invalidFormat = false;
          inconnu = false;
          mauvaisCode = false;
          erreurInterne = true;

          inscrit = false;
        });
      }

    } else {
      setState(() {
        invalidFormat = true;
        inconnu = false;
        mauvaisCode = false;
        erreurInterne = false;

        inscrit = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    //this.email.text = loadedInscMail;
    this.email.text = preloadMail;
    preloadMail = null;

    double width = MediaQuery
        .of(context)
        .size
        .width;

    // spacing
    double spacingDivider = 0.01 * width;

    return Scaffold(
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset('images/UniverSell_Logo_Small.png'),

                    MyDivider(spacingDivider),

                    const Text(
                      "Confirmez votre inscription (Regardez votre boite de réception)",
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),

                    MyDivider(spacingDivider),

                    invalidFormat ? const Text(
                      "Le format d'un ou de plusieurs champs est invalide",
                      style: TextStyle(
                          color: Colors.red
                      ),
                      textAlign: TextAlign.center,
                    ) : SizedBox(),

                    mauvaisCode ? const Text(
                      "Veuillez entrer le bon code",
                      style: TextStyle(
                          color: Colors.red
                      ),
                      textAlign: TextAlign.center,
                    ) : SizedBox(),

                    inconnu ? const Text(
                      "Veuillez remplir le formulaire d'inscription avant...",
                      style: TextStyle(
                          color: Colors.red
                      ),
                      textAlign: TextAlign.center,
                    ) : SizedBox(),

                    erreurInterne ? const Text(
                      "Une erreur s'est produite",
                      style: TextStyle(
                          color: Colors.red
                      ),
                      textAlign: TextAlign.center,
                    ) : SizedBox(),

                    inscrit ? const Text(
                      "Vous avez été inscrit!",
                      style: TextStyle(
                          color: Colors.green
                      ),
                      textAlign: TextAlign.center,
                    ) : SizedBox(),

                    MyTextField( 'Adresse Courriel', email, false),

                    MyTextField( 'Code De Confirmation (envoyé par email)', code, true),

                    MyStyleButton( 'Confirmer', () => confirmerInscription(this.email.text, this.code.text)),

                    MyDivider(0.01 * width),

                    MyStyleButton( 'Retour à la Connexion', () => setCurrentPage(ConnexionPage(), context))
                  ]
              )
          )
      )
    );
  }
}

class ForgottenPassPage extends StatefulWidget {
  ForgottenPassPage({Key key}) : super(key: key);

  @override
  _ForgottenPassPage createState() => _ForgottenPassPage();
}

class _ForgottenPassPage extends State<ForgottenPassPage> {

  bool invalidEmail = false;
  bool mauvaisEmail = false;
  bool erreurInterne = false;

  final email = TextEditingController();

  Future<void> requestChangePass(String aEmail) async {
    // 1. regex format email
    if (emailRegEx.hasMatch(aEmail)) {
      setState(() {
        invalidEmail = false;
      });

      // 2. Faire la requête: Done et gestion d'erreur: TODO
      var url = Uri.http(apiURL, '/sendcodeforpw');
      var response = await http.post(url, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({ 'email' : aEmail }));
      if (response.statusCode == 201) {
        print("Demande de changement faite!");

        setState(() {
          invalidEmail = false;
          mauvaisEmail = false;
          erreurInterne = false;
        });

        // 3. Navigation
        preloadMailFMDP = aEmail;
        setCurrentPage(ChangerPassPage(), context);

      } else if (response.statusCode == 404) {
        setState(() {
          invalidEmail = false;
          mauvaisEmail = true;
          erreurInterne = false;
        });

      } else {
        setState(() {
          invalidEmail = false;
          mauvaisEmail = false;
          erreurInterne = true;
        });
      }


    } else {
      setState(() {
        invalidEmail = true;
        mauvaisEmail = false;
        erreurInterne = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery
        .of(context)
        .size
        .width;
    
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('images/UniverSell_Logo_Small.png'),
              MyDivider(0.01 * width),
              const Text(
                "Mot de Passe oublié!",
                style: TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
              ),
              invalidEmail ? const Text(
                "Format d'adresse courriel invalide",
                style: TextStyle(
                    color: Colors.red
                ),
                textAlign: TextAlign.center,
              ) : SizedBox(),
              mauvaisEmail ? const Text(
                "Adresse Courriel Inconnue",
                style: TextStyle(
                    color: Colors.red
                ),
                textAlign: TextAlign.center,
              ) : SizedBox(),
              erreurInterne ? const Text(
                "Erreur Interne!",
                style: TextStyle(
                    color: Colors.red
                ),
                textAlign: TextAlign.center,
              ) : SizedBox(),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: MyTextField( "Adresse Courriel", email, false),
              ),
              //MyTextField( "Adresse Courriel", email, false),
              /*TextButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),

                ),
                onPressed: () { setCurrentPage( ChangerPassPage(), context); },
                child: Text('Code déjà envoyé...'),
              ),*/ // Bouton pour code deja envoyé mdp oublie, enlevé pour l'instant, fonctionnel
              //SizedBox(height: 25),
              MyStyleButton( "Confirmer", () => requestChangePass(this.email.text)),
              MyDivider(0.01 * width),
              MyStyleButton( "Retour à la Connexion", () => setCurrentPage( ConnexionPage(), context) )
            ]
        )
      )
    );
  }
}

class ChangerPassPage extends StatefulWidget {
  ChangerPassPage({Key key}) : super(key: key);

  @override
  _ChangerPassPage createState() => _ChangerPassPage();
}

class _ChangerPassPage extends State<ChangerPassPage> {

  // text controllers pour les textfields
  final email = TextEditingController();
  final code = TextEditingController();
  final motPass = TextEditingController();
  final motPassConf = TextEditingController();

  // booleans pour l'affichage
  bool invalidFormat = false;
  bool pasMemeMdp = false;
  bool emailInconnu = false;
  bool mauvaisCode = false;
  bool erreurInterne = false;

  bool reussiteC = false;

  Future<void> changerMDP(String aEmail, String aCode, String aMdp, String aMdpConf) async {

    // 1. check format avec regex et aMdp == aMdpConf
    if (aMdp != aMdpConf) {
      setState(() {
        pasMemeMdp = true;
        invalidFormat = false;
        emailInconnu = false;
        mauvaisCode = false;
        erreurInterne = false;

        reussiteC = false;
      });

    }else if (!(emailRegEx.hasMatch(aEmail) && codeVerifRegEx.hasMatch(aCode) && passRegEx.hasMatch(aMdp))) {
      setState(() {
        pasMemeMdp = false;
        invalidFormat = true;
        emailInconnu = false;
        mauvaisCode = false;
        erreurInterne = false;

        reussiteC = false;
      });
    } else {

      // 2. request pour le changement de mot de passe: TODO
      var url = Uri.http(apiURL, '/changepassword');
      var response = await http.post(url, headers: { 'Content-Type': 'application/json' }, body: jsonEncode({ 'email' : aEmail, "codeforchange": aCode, "newpassword": aMdp }));
      if (response.statusCode == 201) {
        print("Mot de passe changé!");

        setState(() {
          pasMemeMdp = false;
          invalidFormat = false;
          emailInconnu = false;
          mauvaisCode = false;
          erreurInterne = false;

          reussiteC = true;
        });

        // petite attente pour montrer la réussite
        await Future.delayed(const Duration(seconds: 2));

        // 3. Navigation
        setCurrentPage(ConnexionPage(), context);

      } else if (response.statusCode == 404) {
        print("Un ptit 404 accidentel j'en suis certain!");
        setState(() {
          pasMemeMdp = false;
          invalidFormat = false;
          emailInconnu = true;
          mauvaisCode = false;
          erreurInterne = false;

          reussiteC = false;
        });

      } else if (response.statusCode == 401) {
        print("Anguille sous roche ou juste un test! Thinking");
        setState(() {
          pasMemeMdp = false;
          invalidFormat = false;
          emailInconnu = false;
          mauvaisCode = true;
          erreurInterne = false;

          reussiteC = false;
        });

      } else {
        print("Erreur interne!");
        setState(() {
          pasMemeMdp = false;
          invalidFormat = false;
          emailInconnu = false;
          mauvaisCode = false;
          erreurInterne = true;

          reussiteC = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    this.email.text = preloadMailFMDP;
    preloadMailFMDP = null;

    double width = MediaQuery
        .of(context)
        .size
        .width;

    // spacing
    double spacingDivider = 0.01 * width;

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset('images/UniverSell_Logo_Small.png'),

                      MyDivider(spacingDivider),

                      const Text(
                        "Changez votre mot de passe (Regardez votre boîte de réception)",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.center,
                      ),

                      MyDivider(spacingDivider),

                      invalidFormat ? const Text(
                        "Le format d'un ou de plusieurs champs est invalide",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      emailInconnu ? const Text(
                        "Adresse Courriel Inconnue!",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      mauvaisCode ? const Text(
                        "Veuillez entrer le bon code d'identification...",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      erreurInterne ? const Text(
                        "Erreur Interne!",
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      reussiteC ? const Text(
                        "Mot de passe changé!",
                        style: TextStyle(
                            color: Colors.green
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      MyTextField( 'Adresse Courriel', this.email, false),

                      MyTextField( 'Code De Confirmation (envoyé par email)', code, true),

                      MyTextField( 'Nouveau Mot de Passe', motPass, true),

                      pasMemeMdp ? Text(
                        'Veuillez rentrer le même mot de passe...',
                        style: TextStyle(
                            color: Colors.red
                        ),
                        textAlign: TextAlign.center,
                      ) : SizedBox(),

                      MyTextField('Confirmez le Nouveau Mot de Passe', motPassConf, true),

                      MyStyleButton( 'Confirmer', () => changerMDP(this.email.text, code.text, motPass.text, motPassConf.text) ),

                      MyDivider(0.01 * width),

                      MyStyleButton( 'Retour à la Connexion', () => setCurrentPage(ConnexionPage(), context))
                    ]
                )
            )
        )
    );
  }
}


/////////////////////////////////////////////////////////////////
// Éléments avec style normalisés (rétilisatble)
/////////////////////////////////////////////////////////////////

// Boutons
class MyStyleButton extends OutlinedButton {
  MyStyleButton(String monText, void Function() f) :super (
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0), side: BorderSide(width: 2.0) )),
      backgroundColor: MaterialStateProperty.all<Color>(monBleu),

    ),

    onPressed: f,

    child: Text(
      monText,
      style: TextStyle(
          color: Colors.white
      ),
    ),
  );
}

// Divider avec un style particulier
class MyDivider extends Divider {
  MyDivider(double sideSpacing) : super (
    color: monBleu,
    //color: Colors.orange,
    //color of divider
    height: 5,
    //height spacing of divider
    thickness: 2,
    //thickness of divier line
    indent: sideSpacing,
    //spacing at the start of divider
    endIndent: sideSpacing,
  );
}

class MyOrangeDivider extends Divider {
  MyOrangeDivider(double sideSpacing) : super (
    color: Colors.orange,
    //color of divider
    height: 5,
    //height spacing of divider
    thickness: 2,
    //thickness of divier line
    indent: sideSpacing,
    //spacing at the start of divider
    endIndent: sideSpacing,
  );
}

// Textfield avec un style particulier
class MyTextField extends TextField {

  /*MyTextField( String myHintText, TextEditingController monController, bool cacheText ) {

    // Style Border textfield
    BorderRadius radiusTextField = BorderRadius.circular(8);
    BorderSide bordureTailleCouleur = BorderSide(
        width: 12, color: Colors.black);
    OutlineInputBorder bordureText = OutlineInputBorder(
        borderRadius: radiusTextField, borderSide: bordureTailleCouleur);
    super(
        ...
    );

  }*/

  MyTextField( String myHintText, TextEditingController monController, bool cacheText ) : super (
      decoration: InputDecoration(
        filled: true,
        fillColor: monFillBleu,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 12, color: Colors.black),
        ),
        hintText: myHintText,
      ),

      controller: monController,

      obscureText: cacheText
  );

  MyTextField.notActive( String myHintText ) {
    MyTextField( myHintText, null, false);
  }
}

// Menu déroullant pour choisir une catégorie
// Done: ajouter le contrôleur dans les parametres
// class MyCategoryDropDown extends DropdownButtonFormField<String>
class MyCategoryDropDown extends DropdownButtonFormField<String> {

  MyCategoryDropDown({Key key, TextEditingController controllerB}) : super (
    key: key, decoration: InputDecoration(
      filled: true,
      fillColor: monFillBleu,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 12, color: Colors.black),
      ),
      hintText: 'Catégorie',
    ),
    isExpanded: true,

    items: [
      const DropdownMenuItem(
        value: 'Manuel',
        child: Text('Manuel ou documentation'),
      ),
      const DropdownMenuItem(
        value: 'Appareil IT',
        child: Text('Appareil Technologique'),
      ),
      const DropdownMenuItem(
        value: 'Papeterie',
        child: Text('Papeterie ou fourniture de bureau'),
      ),
      const DropdownMenuItem(
        value: 'Autre',
        child: Text('Autre'),
      ),
    ],

    onChanged: (value) {
      controllerB.text = value ?? ''; // donner la valeur au controlleur pour pouvoir l'envoyer
    },
  );
}

class MyDropDown extends StatelessWidget{
  final List<String> itemVals;
  final TextEditingController controllerB;
  final String nomMenu;

  const MyDropDown({
    Key key,
    @required this.itemVals,
    @required this.controllerB,
    @required this.nomMenu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: monFillBleu,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(width: 12, color: Colors.black),
        ),
        hintText: nomMenu,
      ),
      isExpanded: true,

      items: itemVals.map((anItemStr) {
        return DropdownMenuItem(
          //value: anItemStr,
          value: Utf8Decoder().convert(anItemStr.codeUnits),
          //child: Text(anItemStr),
          child: Text(Utf8Decoder().convert(anItemStr.codeUnits)),
        );
      }).toList(),

      onChanged: (value) {
        controllerB.text = value ?? '';
      },
    );
  }
}

class MyTextArea extends TextField {

  MyTextArea(String myHintText, TextEditingController monController, bool cacheText, int maxLines) : super (

    maxLines: maxLines, // nombre de ligne / etage du text area

    decoration: InputDecoration(
      filled: true,
      fillColor: monFillBleu,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(width: 12, color: Colors.black),
      ),
      hintText: myHintText,
    ),

    controller: monController,

    obscureText: cacheText,

  );

}


