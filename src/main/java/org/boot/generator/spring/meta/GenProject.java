package org.boot.generator.spring.meta;

import lombok.*;

import java.nio.file.Path;
import java.util.List;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenProject {
    private String name;
    private String group;
    private String architecture;
    private String orm;
    private String driverClassName;
    private String dbUrl;
    private String dbUsername;
    private String dbPassword;
    private List<GenSchema> schemas;
    private Path destinationPath;
    private String localPort;
}
