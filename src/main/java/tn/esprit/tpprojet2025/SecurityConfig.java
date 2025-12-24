package tn.esprit.tpprojet2025;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/actuator/**").permitAll() // Autoriser Prometheus
                .anyRequest().authenticated()              // Authentification pour le reste
            )
            .csrf(csrf -> csrf.disable())                  // Désactiver CSRF pour API
            .httpBasic();                                 // Basic auth pour les autres endpoints si besoin
        return http.build();
    }
}
