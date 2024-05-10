package com.back_end.Universell_back_end.repository;

import com.back_end.Universell_back_end.modele.Authentification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AuthentificationRepository extends JpaRepository <Authentification, Long> {

    /*@Query("SELECT authentification FROM  authentification WHERE authentification.adresse_couriel = ?1 AND authentification.mote_de_passe_hash = ?2")
    Authentification findByadresse_courielAndmot_de_passe_hash(String adresse_couriel, String mot_de_passe_hash);*/
    //Optional<Authentification> findByAdresse_CourielAndMot_De_Passe_Hash(String adresse_couriel, String mot_de_passe_hash);
    Optional<Authentification> findAuthentificationByMotDePasseHashAndAdresseCouriel(String motDePasseHash, String adresseCouriel);
    Optional<Authentification> findAuthentificationByAdresseCouriel(String adressCouriel);
}
