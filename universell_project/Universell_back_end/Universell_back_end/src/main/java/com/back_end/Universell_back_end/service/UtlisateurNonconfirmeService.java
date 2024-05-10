package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.UtilisateurNonconfirme;

public interface UtlisateurNonconfirmeService {

    public void addEtudiantNonconfirme(String pseudo, String CodePerm, String email, String hashmdp,String hashcodeverif);
    public UtilisateurNonconfirme trouveUtilisateurNonconfirme( String email);
    public void deleteUtilisateurNonconfirme(UtilisateurNonconfirme utilisateurNonconfirme);
}
