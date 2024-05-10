package com.back_end.Universell_back_end.modele;

public class Parameterforchange {

    private String email;
    private String codeforchange;
    private String newpassword;

    public String getEmail() {
        return email;
    }

    public String getCodeforchange() {
        return codeforchange;
    }

    public String getNewpassword() {
        return newpassword;
    }

    public Parameterforchange(String email, String codeforchange, String newpassword) {
        this.email = email;
        this.codeforchange = codeforchange;
        this.newpassword = newpassword;
    }
}
