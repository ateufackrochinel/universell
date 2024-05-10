package com.back_end.Universell_back_end.modele;


//import jakarta.persistence.DiscriminatorValue;
//import jakarta.persistence.Entity;
import javax.persistence.*;

@Entity
@DiscriminatorValue("etudiant")
public class Etudiant extends Utilisateur {


    private String codepermanent;


    public Etudiant() {

    }


    public String getCodepermanent() {
        return codepermanent;
    }

    public void setCodepermanent(String codePermanent) {
        this.codepermanent = codePermanent;
    }

    public Etudiant(String pseudo, String nom, String prenom, String codePermanent, Authentification authentification) {
        super(pseudo, nom, prenom, authentification);
        this.codepermanent = codePermanent;
    }
}

