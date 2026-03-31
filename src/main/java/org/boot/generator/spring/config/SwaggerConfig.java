package org.boot.generator.spring.config;

import lombok.RequiredArgsConstructor;
import org.boot.generator.spring.properties.SwaggerProperties;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

@Profile("local")
@Configuration
@RequiredArgsConstructor
public class SwaggerConfig {
    private final SwaggerProperties swaggerProperties;

    @Bean
    GroupedOpenApi openApiV1() {
        return GroupedOpenApi.builder()
                .group("OpenAPI")
                .pathsToMatch("/**")
                .addOpenApiCustomizer(openApi -> {
//                    openApi.components(new Components().addSecuritySchemes("Bearer Token", swaggerProperties.getSecurityScheme()));
//                    openApi.addSecurityItem(swaggerProperties.getSecurityRequirement());
                    openApi.info(swaggerProperties.getInfo());
                })
                .build();
    }
}
