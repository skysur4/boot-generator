package ${package}.common.context;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.oidc.OidcUserInfo;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.jwt.Jwt;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
public class UserContext {

    public static Authentication getAuthentication() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        return authentication;
    }

    public static String getId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null){
            throw new InsufficientAuthenticationException(HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }

        if (authentication.getPrincipal() instanceof Jwt jwt) {
            return jwt.getId();
        }

        if (authentication.getPrincipal() instanceof DefaultOidcUser oidcUser) {
            return oidcUser.getSubject();
        }

        return null;
    }

    public static String getUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null){
            throw new InsufficientAuthenticationException(HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }

        if (authentication.getPrincipal() instanceof Jwt jwt) {
            return jwt.getClaim("preferred_username");
        }

        if (authentication.getPrincipal() instanceof DefaultOidcUser oidcUser) {
            return oidcUser.getPreferredUsername();
        }

        return null;
    }

    public static String getName() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null){
            throw new InsufficientAuthenticationException(HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }

        if (authentication.getPrincipal() instanceof Jwt jwt) {
            // Keycloak Authorized Party
            return jwt.getClaim("azp");
        }

        if (authentication.getPrincipal() instanceof DefaultOidcUser oidcUser) {
            return oidcUser.getFullName();
        }

        return null;
    }

    public static OidcUserInfo getOidcUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null){
            throw new InsufficientAuthenticationException(HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }

        if (authentication.getPrincipal() instanceof DefaultOidcUser oidcUser) {
            return oidcUser.getUserInfo();
        }

        return null;
    }

    public static List<GrantedAuthority> getAuthorities() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getPrincipal() == null){
            throw new InsufficientAuthenticationException(HttpStatus.UNAUTHORIZED.getReasonPhrase());
        }

        return new ArrayList<>(authentication.getAuthorities());
    }
}