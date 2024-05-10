package com.back_end.Universell_back_end.modele;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

import javax.persistence.Column;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Articlesend {

    private String nomarticle;
    private String description;
    private Float prix;
    private String categorie;
    private MultipartFile file;
    private String tokensession;
    private String nomsession;

    public String getNomarticle() {
        return nomarticle;
    }

    public String getDescription() {
        return description;
    }

    public Float getPrix() {
        return prix;
    }

    public String getCategorie() {
        return categorie;
    }

    public MultipartFile getFile() {
        return file;
    }

    public String getTokensession() {
        return tokensession;
    }

    public String getNomsession() {
        return nomsession;
    }


}
