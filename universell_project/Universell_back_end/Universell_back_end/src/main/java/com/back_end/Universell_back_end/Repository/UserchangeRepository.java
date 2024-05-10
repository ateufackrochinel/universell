package com.back_end.Universell_back_end.Repository;

import com.back_end.Universell_back_end.modele.Session;
import com.back_end.Universell_back_end.modele.Userchange;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserchangeRepository extends JpaRepository<Userchange, Long> {

    Optional<Userchange> findUserchangeByEmail(String email);
}
