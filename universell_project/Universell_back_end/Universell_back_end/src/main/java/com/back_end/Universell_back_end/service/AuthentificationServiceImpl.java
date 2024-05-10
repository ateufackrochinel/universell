package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Authentification;
import com.back_end.Universell_back_end.repository.AuthentificationRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class AuthentificationServiceImpl implements AuthentificationService{

    private AuthentificationRepository authRepository;

    @Override
    public Authentification trouverAuth(String email, String mdpHash){
        //return authRepository.findByadresse_courielAndmot_de_passe_hash (email, mdpHash);
        Optional<Authentification> optAuthentification = authRepository.findAuthentificationByMotDePasseHashAndAdresseCouriel(mdpHash, email);
        if (optAuthentification.isEmpty()) {
            return null;
        }
        return optAuthentification.get ();
    }

    @Override
    public Authentification trouverAuth(String email){
        Optional<Authentification> optAuthentification = authRepository.findAuthentificationByAdresseCouriel(email);
        if (optAuthentification.isEmpty()) {
            return null;
        }
        return optAuthentification.get ();
    }

    @Override
    public void updateAuthentification( String email ,String motDePasseHash){
        Authentification auth =trouverAuth(email);
        auth.setMotDePasseHash(motDePasseHash);
    }}
