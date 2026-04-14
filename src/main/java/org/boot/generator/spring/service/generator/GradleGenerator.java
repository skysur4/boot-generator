package org.boot.generator.spring.service.generator;

import com.google.common.collect.Maps;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.boot.generator.spring.meta.GenProject;
import org.boot.generator.spring.service.renderer.TemplateRenderer;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class GradleGenerator {
    private final static String GRADLE_ARCHITECTURE = "gradle";
    private final static String GRADLE_EXTENSION = ".gradle";

    private final TemplateRenderer templateRenderer;

    public void generate(GenProject project, String basePackage, Path packagePath) throws IOException {

        Map<String, Object> projectModel = Maps.newHashMap();
        projectModel.put("basePackage", basePackage);
        projectModel.put("package", packagePath);
        projectModel.put("group", project.getGroup());
        projectModel.put("name", project.getName());
        projectModel.put("orm", project.getOrm());

        GeneratorUtils.writeFile(project.getDestinationPath(), "build" + GRADLE_EXTENSION,
                templateRenderer.render(GRADLE_ARCHITECTURE, "build.ftl", projectModel));

        GeneratorUtils.writeFile(project.getDestinationPath(), "settings" + GRADLE_EXTENSION,
                templateRenderer.render(GRADLE_ARCHITECTURE, "settings.ftl", projectModel));

        try {
            GeneratorUtils.copyRawFiles(templateRenderer.loadRawFilesFrom("raw"), project.getDestinationPath());
        } catch (IOException | URISyntaxException e) {
            log.info("Failed to copy files : {}", e.getMessage());
        }
    }
}