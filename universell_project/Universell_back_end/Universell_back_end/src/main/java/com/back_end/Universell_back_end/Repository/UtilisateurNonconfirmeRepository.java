package com.back_end.Universell_back_end.Repository;

import com.back_end.Universell_back_end.modele.Utilisateur;
import com.back_end.Universell_back_end.modele.UtilisateurNonconfirme;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UtilisateurNonconfirmeRepository extends JpaRepository<UtilisateurNonconfirme, Long> {
    Optional<UtilisateurNonconfirme> findUtilisateurNonconfirmeByEmail(String email);


}
