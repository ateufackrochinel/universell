package com.back_end.Universell_back_end.service;

public interface UtilisateurService {

    public void addEtudiant(String pseudo, String CodePerm, String email, String hashmdp);

    public void addAdmin(String pseudo, String identadm, String email, String hashmdp);



}
