package com.back_end.Universell_back_end.modele;

import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
public class UtilisateurNonconfirme {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long Idunc;
    private String pseudo;
    private String email;
    private String codeperm;
    private String hashpw;

    private String hashcodeverif;

    public UtilisateurNonconfirme() {
    }


    public String getPseudo() {
        return pseudo;
    }

    public String getEmail() {
        return email;
    }

    public String getCodeperm() {
        return codeperm;
    }

    public String getHashpw() {
        return hashpw;
    }

    public String getHashcodeverif() {
        return hashcodeverif;
    }

    public void setPseudo(String pseudo) {
        this.pseudo = pseudo;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setCodeperm(String codePerm) {
       this.codeperm = codePerm;
    }

    public void setHashpw(String hashpw) {
        this.hashpw = hashpw;
    }

    public void setHashcodeverif(String hashcodeverif) {
        this.hashcodeverif = hashcodeverif;
    }

    public UtilisateurNonconfirme(String pseudo, String email, String codePerm, String hashpw, String hashcodeverif) {
        this.pseudo = pseudo;
        this.email = email;
        this.codeperm = codePerm;
        this.hashpw = hashpw;
        this.hashcodeverif = hashcodeverif;
    }
}
