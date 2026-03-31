package org.boot.generator.spring.generator;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.boot.generator.spring.meta.GenProject;
import org.boot.generator.spring.meta.GenSchema;
import org.boot.generator.spring.meta.GenTable;
import org.boot.generator.spring.render.ColumnRender;
import org.boot.generator.spring.renderer.TemplateRenderer;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class JpaCoder {

    private final TemplateRenderer templateRenderer;
    private final ObjectMapper mapper;

    public void generate(GenProject project, Path outputDir) throws IOException {

        String basePackage = GeneratorUtils.toBasePackage(project.getName());

        List<GenSchema> schemas = project.getSchemas();

        for (GenSchema schema : schemas) {
            for (GenTable table : schema.getTables()) {

                String className = GeneratorUtils.toPascal(table.getName());

                List<ColumnRender> fields = table.getColumns().stream()
                        .filter(c -> !isAuditColumn(c.getName()))
                        .map(c -> new ColumnRender(
                                GeneratorUtils.toCamel(c.getName()),
                                c.getName(),
                                c.getJavaType(),
                                table.getPrimaryKeys().stream().anyMatch(pk -> pk.getColumn().equalsIgnoreCase(c.getName()))
                        ))
                        .toList();

                // Use TypeReference to handle generic types correctly
                List<Map<String, Object>> fieldList = mapper.convertValue(fields, new TypeReference<List<Map<String, Object>>>() {});

                Map<String, Object> model = new HashMap<>();
                model.put("package", basePackage);
                model.put("className", className);
                model.put("tableName", table.getName());
                model.put("fields", fieldList);

                write(outputDir, "entity", className,
                        templateRenderer.render("entity.ftl", model));

                write(outputDir, "repository", className + "Repository",
                        templateRenderer.render("repository.ftl", model));

                write(outputDir, "service", className + "Service",
                        templateRenderer.render("service.ftl", model));

                write(outputDir, "controller", className + "Controller",
                        templateRenderer.render("controller.ftl", model));
            }
        }

    }

    private boolean isAuditColumn(String name) {
        return List.of(
                "created_at", "created_by",
                "updated_at", "updated_by"
        ).contains(name);
    }

    private void write(Path root, String layer, String className, String content) throws IOException {
        Path dir = root.resolve(layer);
        Files.createDirectories(dir);

        Path file = dir.resolve(className + ".java");
        Files.writeString(file, content);
    }
}