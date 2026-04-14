package org.boot.generator.spring.service.generator;

import com.google.common.collect.Maps;
import lombok.RequiredArgsConstructor;
import org.boot.generator.spring.meta.GenProject;
import org.boot.generator.spring.service.renderer.TemplateRenderer;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class PropertyGenerator {
    private final static String PROPERTY_ARCHITECTURE = "property";
    private final static String YAML_EXTENSION = ".yml";

    private final TemplateRenderer templateRenderer;

    public void generate(GenProject project, String basePackage, Path resourcePath) throws IOException {

        // 프로퍼티 파일 생성
        Map<String, Object> propertyModel = Maps.newHashMap();
        propertyModel.put("package", basePackage);
        propertyModel.put("name", project.getName());
        propertyModel.put("groupUrl", project.getGroup().replaceAll("-", "."));
        propertyModel.put("orm", project.getOrm());
        propertyModel.put("driverClassName", project.getDriverClassName());
        propertyModel.put("url", project.getDbUrl());
        propertyModel.put("username", project.getDbUsername());
        propertyModel.put("password", project.getDbPassword());
        propertyModel.put("localPort", project.getLocalPort());

        GeneratorUtils.writeFile(resourcePath, "application" + YAML_EXTENSION,
                templateRenderer.render(PROPERTY_ARCHITECTURE, "application.ftl", propertyModel));

        GeneratorUtils.writeFile(resourcePath, "application-local" + YAML_EXTENSION,
                templateRenderer.render(PROPERTY_ARCHITECTURE, "application-local.ftl", propertyModel));

    }
}