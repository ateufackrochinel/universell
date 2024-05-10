package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.Repository.ArticleRepository;
import com.back_end.Universell_back_end.modele.Article;
import com.back_end.Universell_back_end.modele.Utilisateur;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;


@Service
@AllArgsConstructor
public class ArticleServiceImpl implements ArticleService {

    @Autowired
    private com.back_end.Universell_back_end.repository.AuthentificationRepository authentificationRepository;

    @Autowired
    private com.back_end.Universell_back_end.repository.UtilisateurRepository utilisateurRepository;

    @Autowired
    private ArticleRepository articleRepository;


    @Override
    public void  addArticle(String nomimage, byte[] taille,String typeimage, String nomarticle, String description, Float prix, String categorie, Utilisateur utilisateur){

         Article article=new Article();
         article.setNomimage(nomimage);
         article.setTailleimage(taille);
         article.setTypeimage(typeimage);
         article.setNomarticle(nomarticle);
         article.setCategorie(categorie);
         article.setDescription(description);
         article.setPrix(prix);
        authentificationRepository.save (utilisateur.getAuthentification());
        utilisateurRepository.save(utilisateur);
         article.setUtilisateur(utilisateur);

         articleRepository.save(article);
    }

    @Override
    public List<Article> trouveArticle(String categorie){
        List<Optional<Article>> articles= articleRepository.findArticleByCategorie(categorie);
        List<Article> articles1= new ArrayList<>();
        if(articles.size()==0) {
            return null;
        }
        for (int i=0;i<articles.size();i++) {

             articles1.add(articles.get(i).get());
        }
        return articles1;
    }
}
