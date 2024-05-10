package com.back_end.Universell_back_end.controlleur;

import com.back_end.Universell_back_end.modele.*;
import com.back_end.Universell_back_end.service.*;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping
@AllArgsConstructor
public class appController {

    final private String salt = BCrypt.gensalt ();

    private final UtilisateurService utilisateurService;
    private final UtlisateurNonconfirmeService utlisateurNonconfirmeService;
    private final UserchangeService userchangeService;
    private final AuthentificationService authentificationService;
    private final SessionService sessionService;

    @Autowired
    public JavaMailSender emailSend;

    //Route pour la creation d'un utilisateur

    @PostMapping("/createuser")
    public ResponseEntity<ReturnJson> createUser(@RequestBody User user) {
        String email = user.getEmail();
        String mdp = user.getPassword();
        String CodePerm =user.getCodePerm();
        String pseudo=user.getPseudo();

        Authentification auth = authentificationService.trouverAuth(email);
        if ((auth != null) ) {
            String errorMessage = "un utilisateur existe deja avec cet email ";
            System.out.println(errorMessage);
            Errone errorMess = new Errone(errorMessage);
            return ResponseEntity.status(HttpStatus.CONFLICT).body(errorMess);
        }



        String codeverif=randomString(6);

        Idoutlook.destinataire=email;
        SimpleMailMessage message = new SimpleMailMessage();

        message.setTo(Idoutlook.destinataire);
        message.setSubject("veuillez saisir ce code pour verifier votre adresse mail");

        message.setText(" Votre code de verification est:"+codeverif);

        // Envoyer le code !
        this.emailSend.send(message);

        String hashmdp=hash(mdp);
        String hashcodeverif=hash(codeverif);
        utlisateurNonconfirmeService.addEtudiantNonconfirme(pseudo,email,CodePerm,hashmdp,hashcodeverif);


        //utilisateur non confirme
        String verifMessage="Un code de verification a ete envoye a cet adresse ";
        System.out.println(verifMessage);
        Verif verifMess= new Verif(verifMessage);
        return ResponseEntity.status(HttpStatus.CREATED).body(verifMess);

    }

    //Route pour la verification de l'email lors de l'ajout d'un utilisateur

    @PostMapping("/verificationmail")
    public ResponseEntity<ReturnJson> verificationmail(@RequestBody Verifmail verifmail) {

        String email = verifmail.getEmail();
        String codeverif = verifmail.getCodeverif();
        UtilisateurNonconfirme utilisateurnc = utlisateurNonconfirmeService.trouveUtilisateurNonconfirme(email);

        if ((utilisateurnc == null) ) {

            String errorMessage = "Vous n'existez pas dans le systeme  ";
            System.out.println(errorMessage);
            Errone errorMess = new Errone ( errorMessage );
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorMess);
        }else if (!verifHash(codeverif, utilisateurnc.getHashcodeverif())){
            String errorMessage = "S'il vous plait veuillez saisir le bon code ";
            System.out.println(errorMessage);
            Errone errorMess = new Errone ( errorMessage );
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMess);
        }

        String pseudo=utilisateurnc.getPseudo();
        String Codeperm=utilisateurnc.getCodeperm();
        String hashpw=utilisateurnc.getHashpw();

        utilisateurService.addEtudiant(pseudo,Codeperm,email,hashpw);
        utlisateurNonconfirmeService.deleteUtilisateurNonconfirme(utilisateurnc);

        String succesMessage="Bienvenue"+pseudo;
        System.out.println(succesMessage);
        Success successMess=new Success(succesMessage);
        return ResponseEntity.status(HttpStatus.CREATED).body(successMess);

    }

    //Route pour l'authentification d'un utilisateur

    @PostMapping("/login")
    public ResponseEntity<ReturnJson> login(@RequestBody Login login){
        String email = login.getEmail ();
        String mdp = login.getPassword ();

        Authentification auth = authentificationService.trouverAuth (email);
        if ( (auth == null) || (!verifHash (mdp, auth.getMotDePasseHash ())) ) {
            String errorMessage = "email ou mot de passe érroné";
            System.out.println(errorMessage);
            Errone errorMess = new Errone ( errorMessage );
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMess);
        }

        String sessionNom = randomString (10);
        String sessionToken = randomString (25);

        String hashSessionToken = hash (sessionToken);

        Session session = new Session ();
        session.setTokenhash( hashSessionToken );
        session.setNom ( sessionNom );
        session.setAuthentification ( auth );
        sessionService.ajouterSession (session);

        AuthToken authToken = new AuthToken (sessionNom, sessionToken);
        return ResponseEntity.ok (authToken);

    }

    //Route pour envoyer le code pour le changement du mot de passe

    @PostMapping("/sendcodeforpw")
    public ResponseEntity<ReturnJson> sendcodeforpw (@RequestBody Parameterforchange parameterforchange){

        String email= parameterforchange.getEmail();

        Authentification auth= authentificationService.trouverAuth(email);
        if(auth==null){
            String errorMessage = "Vous n'avez pas de compte dans notre systeme ";
            System.out.println(errorMessage);
            Errone errorMess = new Errone ( errorMessage );
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMess);
        }

        String codeforchange=randomString(6);

        Idoutlook.destinataire=email;
        SimpleMailMessage message = new SimpleMailMessage();

        message.setTo(Idoutlook.destinataire);
        message.setSubject("veuillez saisir ce code pour changer votre mot de passe");

        message.setText(" Votre code pour changer votre mot de passe  est:"+codeforchange);

        // Envoyer le code !
        this.emailSend.send(message);

        String hashcodeforchange=hash(codeforchange);
        userchangeService.addUserchange(email,hashcodeforchange);

        String succesMessage="un code pour changer votre mot de passe a été envoyé à cet adresse";
        System.out.println(succesMessage);
        Success successMess=new Success(succesMessage);
        return ResponseEntity.status(HttpStatus.CREATED).body(successMess);
    }

    //Route pour changer le mot de passe

    @PostMapping("/changepassword")
    public ResponseEntity<ReturnJson> changepassword (@RequestBody Parameterforchange parameterforchange) {

        String email= parameterforchange.getEmail();
        String codeforchange= parameterforchange.getCodeforchange();
        String newpassword=parameterforchange.getNewpassword();

        Userchange userchange=userchangeService.trouvUserchange(email);

        if(userchange==null){

            String errorMessage = "Vous n'etes pas autorise à changer le mot de passe";
            System.out.println(errorMessage);
            Errone errorMess = new Errone ( errorMessage );
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorMess);

    }else if (!verifHash(codeforchange,userchange.getHashcodeforchange())){
        String errorMessage = "S'il vous plait veuillez saisir le bon code ";
        System.out.println(errorMessage);
        Errone errorMess = new Errone ( errorMessage );
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMess);
    }

        String hashnewpassword=hash(newpassword);
        authentificationService.updateAuthentification(email,hashnewpassword);
        userchangeService.deleteUserchange(userchange);


        String succesMessage="Votre mot de passe a ete modifie avec success ";
        System.out.println(succesMessage);
        Success successMess=new Success(succesMessage);

        //pour le test
        Authentification auth= authentificationService.trouverAuth(email);
        if((verifHash (newpassword, auth.getMotDePasseHash ()))) {
            System.out.println("Succes");
        }
        return ResponseEntity.status(HttpStatus.CREATED).body(successMess);
    }
    private String hash(String mdp) {

        return BCrypt.hashpw(mdp, salt);


    }

    private Boolean verifHash(String mdp, String hash){
        return BCrypt.checkpw(mdp, hash);
    }

    private String randomString(int size) {
        String lettres = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String valRetour = "";
        for (int i = 0; i < size; i++) {
            int index = (int) (Math.random() * lettres.length());
            valRetour = valRetour + lettres.charAt (index);
        }
        return valRetour;
    }


    private class AuthToken extends ReturnJson{

        private String sessionName;
        private String sessionToken;

        private AuthToken (String sNom, String sToken) {
            this.sessionName = sNom;
            this.sessionToken = sToken;
        }

        public String getSessionName() {
            return sessionName;
        }

        public String getSessionToken() {
            return sessionToken;
        }
    }

    private class Errone extends ReturnJson {
        private String messageErreur;

        private Errone (String messErr) {
            this.messageErreur = messErr;
        }

        public String getMessageErreur() {
            return messageErreur;
        }
    }

    private class Verif extends ReturnJson{
        private String verifmessage;

        public String getVerifmessage() {
            return verifmessage;
        }

        public Verif(String verifmessage) {
            this.verifmessage = verifmessage;
        }
    }

    public class Success extends ReturnJson{
        private String messagesucces;

        public String getMessagesucces() {
            return messagesucces;
        }

        public Success(String messagesucces) {
            this.messagesucces = messagesucces;
        }
    }

    private abstract class ReturnJson {

    }
}




