package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Article;
import com.back_end.Universell_back_end.modele.Session;
import com.back_end.Universell_back_end.modele.Utilisateur;
import org.springframework.stereotype.Service;

import java.util.List;


public interface ArticleService {

    public void addArticle(String nomimage, byte[] taille,String typeimage, String nomarticle, String description, Float prix, String categorie, Utilisateur utilisateur);

    public List<Article> trouveArticle(String categorie);
}
