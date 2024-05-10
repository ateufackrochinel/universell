package com.back_end.Universell_back_end.modele;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Userchange {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String email;
    private String hashcodeforchange;

    public Userchange() {
    }

    public String getEmail() {
        return email;
    }

    public String getHashcodeforchange() {
        return hashcodeforchange;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setHashcodeforchange(String codeforchange) {
        this.hashcodeforchange = codeforchange;
    }

    public Userchange(String email, String codeforchange) {
        this.email = email;
        this.hashcodeforchange = codeforchange;

    }
}
