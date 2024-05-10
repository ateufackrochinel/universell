package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Session;

public interface SessionService {
    public void ajouterSession(String nom, String tokenhash/*, Date datecreate*/, Long idAuth);
    public void ajouterSession(Session session);
  //  public Session trouveSession(String token_hash, String nomsession );
    public Session trouveSession(String nomsession);
}
