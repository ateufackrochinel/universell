package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Administrateur;
import com.back_end.Universell_back_end.modele.Authentification;
import com.back_end.Universell_back_end.modele.Etudiant;
import com.back_end.Universell_back_end.modele.Utilisateur;
import com.back_end.Universell_back_end.repository.AuthentificationRepository;
import com.back_end.Universell_back_end.repository.UtilisateurRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class UtilisateurServiceImpl implements UtilisateurService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private AuthentificationRepository authentificationRepository;

    @Override
    public void addEtudiant(String pseudo, String CodePerm, String email, String hashmdp){
        Etudiant etudiant = new Etudiant ();
        etudiant.setPseudo (pseudo);
        etudiant.setCodepermanent (CodePerm);

        Authentification auth = new Authentification ();
        auth.setAdresseCouriel (email);
        auth.setMotDePasseHash (hashmdp);
        etudiant.setAuthentification (auth);
        authentificationRepository.save (auth);
        utilisateurRepository.save(etudiant);
    }

    @Override
    public void addAdmin(String pseudo, String identadm, String email, String hashmdp){
        Administrateur admin = new Administrateur ();
        admin.setPseudo (pseudo);
        admin.setIdent_admin (identadm);

        Authentification auth = new Authentification ();
        auth.setAdresseCouriel (email);
        auth.setMotDePasseHash (hashmdp);
        admin.setAuthentification (auth);
        utilisateurRepository.save(admin);
    }


//    @Override
//    public void updateUtilisateur(String email, String motDePasseHash){
//        Authentification auth=
//    }
    /*public UtilisateurServiceImpl(){

    }*/
}
