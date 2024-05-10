package com.back_end.Universell_back_end.Repository;

import com.back_end.Universell_back_end.modele.Article;
import com.back_end.Universell_back_end.modele.Authentification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface ArticleRepository extends JpaRepository<Article,Long> {

    List<Optional<Article>> findArticleByCategorie(String categorie);
}
