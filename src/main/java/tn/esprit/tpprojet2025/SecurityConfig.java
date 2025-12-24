package tn.esprit.tpprojet2025;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests()
            .requestMatchers("/actuator/prometheus").permitAll() // <-- important
            .anyRequest().authenticated()
            .and()
            .httpBasic()
            .and()
            .csrf().disable();
    }
}
