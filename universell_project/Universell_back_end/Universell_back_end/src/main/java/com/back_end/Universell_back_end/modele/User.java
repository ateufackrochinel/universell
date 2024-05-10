package com.back_end.Universell_back_end.modele;

public class User {
    private String pseudo;
    private String email;
    private String CodePerm;
    private String password;

    public String getPseudo() {
        return pseudo;
    }

    public String getEmail() {
        return email;
    }

    public String getCodePerm() {
        return CodePerm;
    }

    public String getPassword() {
        return password;
    }

    public User(String pseudo, String email, String codePerm, String mdp) {
        this.pseudo = pseudo;
        this.email = email;
        CodePerm = codePerm;
        this.password = mdp;
    }
}
