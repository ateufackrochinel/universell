package com.back_end.Universell_back_end.repository;

import com.back_end.Universell_back_end.modele.Administrateur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdministrateurRepository extends JpaRepository <Administrateur, Long>{
}

