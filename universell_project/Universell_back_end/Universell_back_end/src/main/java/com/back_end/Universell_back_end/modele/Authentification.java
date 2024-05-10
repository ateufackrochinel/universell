package com.back_end.Universell_back_end.modele;

//import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;

import java.util.List;

@Entity
@Table(name = "Authentification")
public class Authentification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_authentification;
    private String motDePasseHash;
    private String adresseCouriel;

    @OneToOne(mappedBy = "authentification")
    @JsonIgnore
    private Utilisateur utilisateur;

    @OneToMany(mappedBy = "authentification")
    @JsonIgnore
    private List<Session> session;

    public Authentification() {
    }

    public String getMotDePasseHash() {
        return motDePasseHash;
    }

    public void setMotDePasseHash(String motDePasseHash) {
        this.motDePasseHash = motDePasseHash;
    }

    public String getAdresseCouriel() {
        return adresseCouriel;
    }

    public void setAdresseCouriel(String adresseCouriel) {
        this.adresseCouriel = adresseCouriel;
    }

    public com.back_end.Universell_back_end.modele.Utilisateur getUtilisateur() {
        return this.utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public List<Session> getSession() {
        return session;
    }

    public void setSession(List<Session> session) {
        this.session = session;
    }

    public Authentification(String motDePasseHash, String adresse_couriel, Etudiant etudiant, Administrateur administrateur, List<Session> session) {
        this.motDePasseHash = motDePasseHash;
        this.adresseCouriel = adresse_couriel;
        this.utilisateur = utilisateur;
        this.session = session;

    }

    public Authentification(String motDePasseHash, String adresseCouriel) {
        this.motDePasseHash = motDePasseHash;
        this.adresseCouriel = adresseCouriel;
    }
}

