package com.back_end.Universell_back_end.service;

import com.back_end.Universell_back_end.Repository.UserchangeRepository;
import com.back_end.Universell_back_end.modele.Userchange;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@AllArgsConstructor
public class UserchangeServiceImp implements UserchangeService {

    @Autowired
    private UserchangeRepository userchangeRepository;

    @Override
    public  void addUserchange(String email,String hashcodeforchange){
         Userchange userchange=new Userchange();
        userchange.setEmail(email);
        userchange.setHashcodeforchange(hashcodeforchange);
        userchangeRepository.save(userchange);
    }
    @Override
    public Userchange trouvUserchange(String email){

        Optional<Userchange> userchange=userchangeRepository.findUserchangeByEmail(email);
        if(userchange.isEmpty())
                return null;

                return userchange.get();
    }

    public void deleteUserchange(Userchange userchange){
        userchangeRepository.delete(userchange);
    }
}
