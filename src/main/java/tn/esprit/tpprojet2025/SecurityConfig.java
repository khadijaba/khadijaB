package t.e.t.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@Configuration
public class SecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .requestMatchers("/tpProjet/actuator/prometheus").permitAll() // autorise Prometheus
                .anyRequest().authenticated() // le reste reste sécurisé
            .and()
            .httpBasic().disable()
            .formLogin().disable()
            .csrf().disable(); // désactive CSRF pour Actuator
    }
}
