package com.back_end.Universell_back_end.modele;

import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.List;

@Entity
public class Article {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idarticle;
    private String nomimage;

    @Lob
    @Column(name="tailleimage", columnDefinition ="LONGBLOB")
    private byte[] tailleimage;
    private String typeimage;
    private String nomarticle;
    private String description;
    private Float prix;
    private String categorie;


    @ManyToOne
    @JsonIgnore
    @JoinColumn(name="id_utilisateur")
    private Utilisateur utilisateur;

    public String getNomimage() {
        return nomimage;
    }

    public byte[] getTailleimage() {
        return tailleimage;
    }

    public String getTypeimage() {
        return typeimage;
    }

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

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setNomimage(String nomimage) {
        this.nomimage = nomimage;
    }

    public void setTailleimage(byte[] tailleimage) {
        this.tailleimage = tailleimage;
    }


    public void setTypeimage(String typeimage) {
        this.typeimage = typeimage;
    }

    public void setNomarticle(String nomarticle) {
        this.nomarticle = nomarticle;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setPrix(Float prix) {
        this.prix = prix;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public Article(){

    }
    public Article(String nomimage, byte[] tailleimage,String typeimage, String nomarticle, String description, Float prix, String categorie, Utilisateur utilisateur) {
        this.nomimage = nomimage;
        this.tailleimage = tailleimage;
        this.typeimage=typeimage;
        this.nomarticle = nomarticle;
        this.description = description;
        this.prix = prix;
        this.categorie = categorie;
        this.utilisateur = utilisateur;
    }
}
