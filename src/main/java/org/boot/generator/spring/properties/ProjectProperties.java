package org.boot.generator.spring.properties;

import com.zaxxer.hikari.HikariConfig;
import jakarta.activation.DataSource;
import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.nio.file.Path;
import java.util.List;

@Getter
@Setter
@Configuration
@ConfigurationProperties(prefix = "generator")
public class ProjectProperties {
    private Path destinationPath;
    private List<ProjectConfig> project;

    @Getter
    @Setter
    public static class ProjectConfig {
        private String name;
        private String pattern;
        private String orm;
        private HikariConfig hikariConfig;
        private String schemaFilter;
        private String tableFilter;
        private String columnFilter;
    }
}