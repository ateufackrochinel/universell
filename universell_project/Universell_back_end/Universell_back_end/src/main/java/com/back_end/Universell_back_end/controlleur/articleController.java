package com.back_end.Universell_back_end.controlleur;


import antlr.StringUtils;
import com.back_end.Universell_back_end.modele.*;
import com.back_end.Universell_back_end.service.ArticleService;
import com.back_end.Universell_back_end.service.SessionService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.lang.Nullable;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.zip.Deflater;

import static antlr.StringUtils.*;
import static org.springframework.util.StringUtils.cleanPath;
import static org.springframework.web.bind.annotation.RequestMethod.GET;
import static org.springframework.web.bind.annotation.RequestMethod.POST;

@Controller

@AllArgsConstructor

public class articleController {

    final private String salt = BCrypt.gensalt ();
    private  final ArticleService articleService;
    private  final SessionService sessionService;


    //Route pour ajouter un article

    @RequestMapping(path = "/ajouter_article", method = POST, consumes = { MediaType.MULTIPART_FORM_DATA_VALUE })
    public ResponseEntity<ReturnJson> ajouter_article(@ModelAttribute Articlesend articlesend)throws Exception {



            String nomimage = cleanPath(articlesend.getFile().getOriginalFilename());


                if (nomimage.contains("..")) {
                    throw new Exception("file name contains invalid path sequence" + nomimage);
                }


                String nom = articlesend.getNomarticle();
                String description = articlesend.getDescription();
                float prix = articlesend.getPrix();
                String tokensession= articlesend.getTokensession();

                String nomsession=articlesend.getNomsession();

                 System.out.println(nomsession);

                 Session session=sessionService.trouveSession(nomsession);
                 System.out.println(session.getNom());

                if (session !=null && verifHash (tokensession, session.getTokenhash())) {
                    String categorie = articlesend.getCategorie();


                    Authentification auth=session.getAuthentification();

                    Utilisateur utilisateur = auth.getUtilisateur();

                    articleService.addArticle(nomimage, articlesend.getFile().getBytes(), articlesend.getFile().getContentType(), nom, description, prix, categorie, utilisateur);

                    System.out.println(articlesend.getFile().getBytes());
                    String succesMessage = "votre article a été ajouté ";
                    System.out.println(succesMessage);
                    Success successMess = new Success(succesMessage);
                    return ResponseEntity.status(HttpStatus.CREATED).body(successMess);

                }


        String errorMessage = "Vous n'etes pas autorisé à effectuer cette requette ";
        System.out.println(errorMessage);
        Errone errorMess = new Errone( errorMessage );
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(errorMess);
    }

    //Route pour rechercher les articles avec le mot clé de la recherche et la catégorie de l'article

    @RequestMapping(path = "/rechercher_article", method = GET)
    @ResponseBody
    public ResponseEntity<List<Article>> rechercher_article(@RequestBody Rechercherequest rechercherequest)throws Exception {

        String motcle = rechercherequest.getMotcle();
        String categorie = rechercherequest.getCategorie();
        String tokensession= rechercherequest.getTokensession();

        String nomsession=rechercherequest.getNomsession();
        Session session=sessionService.trouveSession(nomsession);

        if(session !=null && verifHash (tokensession, session.getTokenhash())){

            List<Article> articles = articleService.trouveArticle(categorie);
            if (motcle == null) {


                return ResponseEntity.ok(articles);
            } else {

                List<Article> articleList = new ArrayList<>();
                for (int i = 0; i < articles.size(); i++) {

                    if(articles.get(i).getNomarticle().contains(motcle) || articles.get(i).getDescription().contains(motcle))
                    {

                        articleList.add(articles.get(i));


                    }
                }
                System.out.println(articleList.get(0).getTailleimage());
                return ResponseEntity.ok(articleList);
            }
        }else{
            List<Article> articles=new ArrayList<>();
            String errorMessage = "Vous n'etes pas autorisé à effectuer cette requette ";
            System.out.println(errorMessage);

            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(articles);
        }

    }


    private String hash(String mdp) {

        return BCrypt.hashpw(mdp, salt);


    }

    private Boolean verifHash(String mdp, String hash){
        return BCrypt.checkpw(mdp, hash);}

    public class Success extends ReturnJson {
        private String messagesucces;

        public String getMessagesucces() {
            return messagesucces;
        }

        public Success(String messagesucces) {
            this.messagesucces = messagesucces;
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

    private abstract class ReturnJson {

    }
}



