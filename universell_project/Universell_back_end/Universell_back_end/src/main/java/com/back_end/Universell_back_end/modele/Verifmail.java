package com.back_end.Universell_back_end.modele;

public class Verifmail {

    private String email;
    private String codeverif;

    public String getEmail() {
        return email;
    }

    public String getCodeverif() {
        return codeverif;
    }

    public Verifmail(String email, String codeverif) {
        this.email = email;
        this.codeverif = codeverif;
    }
}
