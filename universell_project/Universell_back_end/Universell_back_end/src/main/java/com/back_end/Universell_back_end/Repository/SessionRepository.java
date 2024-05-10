package com.back_end.Universell_back_end.repository;

import com.back_end.Universell_back_end.modele.Session;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface SessionRepository extends JpaRepository<Session, Long> {

    Optional<Session> findSessionByTokenhashAndNom(String token_hash, String nomsession);
    Optional<Session> findSessionByNom(String nomsession);

}
