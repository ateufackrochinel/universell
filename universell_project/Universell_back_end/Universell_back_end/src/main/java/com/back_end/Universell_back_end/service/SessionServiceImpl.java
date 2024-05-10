package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Authentification;
import com.back_end.Universell_back_end.modele.Session;
import com.back_end.Universell_back_end.repository.AuthentificationRepository;
import com.back_end.Universell_back_end.repository.SessionRepository;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class SessionServiceImpl implements SessionService {

   // @Autowired
    private SessionRepository sessionRepository;

    @Autowired
    private AuthentificationRepository authentificationRepository;

    @Override
    public void ajouterSession(String nom, String tokenhash/*, Date datecreate*/, Long idAuth) {

        Optional<Authentification> optAuthentification = authentificationRepository.findById(idAuth);
        if (optAuthentification.isEmpty()) {
            throw new IllegalArgumentException("Erreur!");
        }

        Authentification auth = optAuthentification.get ();

        Session session = new Session ();
        session.setNom(nom);
        session.setTokenhash(tokenhash);
        session.setAuthentification (auth);
        sessionRepository.save (session);

    }

    @Override
    public  void ajouterSession(Session session){
        sessionRepository.save(session);
    }

//    @Override
//    public Session trouveSession(String token_hash, String nomsesion){
//        Optional<Session> optionalSession=sessionRepository.findSessionByTokenhashAndNom(token_hash,nomsesion);
//
//        if (optionalSession.isEmpty()) {
//            return null;
//        }
//        return optionalSession.get ();
//    }

    @Override
    public Session trouveSession(String nomsession){
        Optional<Session> optSession=sessionRepository.findSessionByNom(nomsession);

        if (optSession.isEmpty()) {
            return null;
        }
        return optSession.get ();
    }
}
