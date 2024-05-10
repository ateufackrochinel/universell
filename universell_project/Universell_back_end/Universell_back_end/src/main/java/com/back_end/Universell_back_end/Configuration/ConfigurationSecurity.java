package com.back_end.Universell_back_end.Configuration;

import com.back_end.Universell_back_end.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.BeanIds;
import org.springframework.security.config.annotation.SecurityBuilder;
import org.springframework.security.config.annotation.SecurityConfigurer;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.WebSecurityConfigurer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.password.NoOpPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configuration.*;
import org.springframework.security.web.DefaultSecurityFilterChain;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
@EnableWebSecurity
public class ConfigurationSecurity extends WebSecurityConfigurerAdapter {

    /*@Autowired
    private UserDetailsServiceImpl userDetailsService;*/

    /*@Override
    protected  void configure(AuthenticationManagerBuilder authenticate) throws Exception{
        authenticate.userDetailsService(userDetailsService);

    }*/
    /*@Bean PasswordEncoder passwordEncoder(){
        return NoOpPasswordEncoder.getInstance();
    }



    @Bean(name= BeanIds.AUTHENTICATION_MANAGER)
    public AuthenticationManager AuthenticationManagerBean() throws Exception{
        return super.authenticationManagerBean();
    }*/

    @Override
    protected  void configure(HttpSecurity http )throws Exception{
        http.csrf().disable().authorizeRequests().antMatchers("/**").permitAll().anyRequest().authenticated();
    }


}

/*@Configuration
@EnableWebSecurity
public class WebSecurityConfig implements SecurityConfigurer<DefaultSecurityFilterChain, HttpSecurity> {

    @Override
    public void init(HttpSecurity builder) throws Exception {

    }

    @Override
    public void configure(HttpSecurity http) throws Exception {
        http
                .authorizeRequests()
                .anyRequest().permitAll()
                .and()
                .csrf().disable();
    }
}
*/