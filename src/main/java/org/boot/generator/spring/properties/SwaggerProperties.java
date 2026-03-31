package org.boot.generator.spring.properties;

import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "springdoc.api-info")
public class SwaggerProperties {
    private String title;
    private String description;
    private String version;
    private String termsOfService;
    private License license;
    private Contact contact;

    public SecurityScheme getSecurityScheme() {
        return new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .in(SecurityScheme.In.HEADER)
                .name("Authorization")
                .scheme("bearer")
                .bearerFormat("JWT");
    }

    public SecurityRequirement getSecurityRequirement() {
        return new SecurityRequirement()
                .addList("Bearer Token");
    }

    public Info getInfo() {
        return new Info()
                .title(title)
                .description(description)
                .termsOfService(termsOfService)
                .version(version)
                .license(license);
    }
}