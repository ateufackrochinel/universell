package com.back_end.Universell_back_end.modele;


//import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;
import java.util.List;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "utilisateur_type", discriminatorType = DiscriminatorType.STRING)
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_utilisateur;
    private String pseudo;

    @OneToOne
    @JsonIgnore
    @JoinColumn(name ="id_authentification")
    private Authentification authentification;

    @OneToMany(mappedBy = "utilisateur")
    @JsonIgnore
    private List<Article> articles;

    public String getPseudo() {
        return pseudo;
    }

    public void setPseudo(String pseudo) {
        this.pseudo = pseudo;
    }

    public Authentification getAuthentification() {
        return authentification;
    }

    public void setAuthentification(Authentification authentification) {
        this.authentification = authentification;
    }

    public Utilisateur(){

    }

    public Utilisateur(String pseudo, String nom, String prenom, Authentification authentification) {
        this.pseudo = pseudo;
        this.authentification = authentification;
    }


}
