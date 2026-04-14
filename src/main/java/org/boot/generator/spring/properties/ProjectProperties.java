package org.boot.generator.spring.properties;

import com.zaxxer.hikari.HikariConfig;
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
    private List<ProjectConfig> project;

    @Getter
    @Setter
    public static class ProjectConfig {
        private String name;
        private String group;
        private String desc;
        private String architecture;
        private String orm;
        private HikariConfig hikariConfig;
        private String schemaFilter;
        private String tableFilter;
        private String columnFilter;
        private Path destinationPath;
        private String localPort;

        public void setLocalPort(Integer localPort){
            this.localPort = (localPort == null || localPort < 80) ? "80" : String.valueOf(localPort);
        }
    }
}