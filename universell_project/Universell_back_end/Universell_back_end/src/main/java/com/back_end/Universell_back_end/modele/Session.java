package com.back_end.Universell_back_end.modele;

//import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;

import javax.persistence.*;

import java.util.Calendar;
import java.util.Date;

@Entity
@Table(name = "Session")
public class Session {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_session;
    private String nom;
    private String tokenhash;
    private Date date_creation;
    private Date max_date;

    @ManyToOne
    @JsonIgnore
    @JoinColumn(name="id_authentification")
    private Authentification authentification;

    final int joursSession = 2;

    public Session() {
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getTokenhash() {
        return tokenhash;
    }

    public void setTokenhash(String tokenhash) {
        this.tokenhash = tokenhash;
    }

    public Date getDate_creation() {
        return date_creation;
    }

    public Date getMax_date() { return  max_date; }

    private void setMax_date(Date new_max_date) { max_date = new_max_date;}

    public void setDate_creation(Date date_creation) {
        this.date_creation = date_creation;
    }

    public Authentification getAuthentification() {
        return authentification;
    }

    public void setAuthentification(Authentification authentification) {
        this.authentification = authentification;
    }

    public Session(String nom, String token_hash, Date date_creation, Authentification authentification) {
        this.nom = nom;
        this.tokenhash = token_hash;
        this.date_creation = date_creation;
        this.authentification = authentification;


        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date_creation);
        calendar.add(Calendar.DAY_OF_MONTH, joursSession);
        this.max_date = calendar.getTime ();
    }

    public void updateSessionTime(){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(max_date);
        calendar.add(Calendar.DAY_OF_MONTH, joursSession);
        this.max_date = calendar.getTime();
    }
}
