package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Authentification;

public interface AuthentificationService {

    public Authentification trouverAuth(String email, String mdp);

    public Authentification trouverAuth(String email);
    public void updateAuthentification(String email, String motDePasseHash);
}
