package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.modele.Userchange;

public interface UserchangeService {

    public  void addUserchange(String email,String hashcodeforchange);
    public Userchange trouvUserchange(String email);
    public void deleteUserchange(Userchange userchange);
}
