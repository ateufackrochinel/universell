package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.Repository.UtilisateurNonconfirmeRepository;
import com.back_end.Universell_back_end.modele.UtilisateurNonconfirme;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class UtilisateurNonconfirmeServiceImpl implements UtlisateurNonconfirmeService{

    @Autowired
    private UtilisateurNonconfirmeRepository utilisateurNonconfirmeRepository;

    @Override
    public void addEtudiantNonconfirme(String pseudo,  String email,String CodePerm, String hashmdp,String hashcodeverif){

        UtilisateurNonconfirme utilisateurNonconfirme=new UtilisateurNonconfirme();
        utilisateurNonconfirme.setPseudo(pseudo);
        utilisateurNonconfirme.setEmail(email);
        utilisateurNonconfirme.setCodeperm(CodePerm);
        utilisateurNonconfirme.setHashpw(hashmdp);
        utilisateurNonconfirme.setHashcodeverif(hashcodeverif);
        utilisateurNonconfirmeRepository.save(utilisateurNonconfirme);
    }

    @Override
    public UtilisateurNonconfirme trouveUtilisateurNonconfirme( String email){
        Optional<UtilisateurNonconfirme> optionalUtilisateurNonconfirme= utilisateurNonconfirmeRepository.findUtilisateurNonconfirmeByEmail(email);
        if(optionalUtilisateurNonconfirme.isEmpty())
            return  null;

        return optionalUtilisateurNonconfirme.get();

    }

    @Override
    public void deleteUtilisateurNonconfirme(UtilisateurNonconfirme utilisateurNonconfirme){
        utilisateurNonconfirmeRepository.delete(utilisateurNonconfirme);
    }
}
