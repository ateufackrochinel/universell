package com.back_end.Universell_back_end.modele;

//import jakarta.persistence.DiscriminatorValue;
//import jakarta.persistence.Entity;
import javax.persistence.*;

@Entity
@DiscriminatorValue("admin")
public class Administrateur extends Utilisateur {

    private String ident_admin;

    public String getIdent_admin() {
        return ident_admin;
    }

    public void setIdent_admin(String ident_admin) {
        this.ident_admin = ident_admin;
    }

    public Administrateur(){

    }

    public Administrateur(String pseudo, String nom, String prenom, Authentification authentification, String ident_admin) {
        super(pseudo, nom, prenom, authentification);
        this.ident_admin = ident_admin;
    }
}