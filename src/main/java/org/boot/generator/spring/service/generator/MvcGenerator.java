package org.boot.generator.spring.service.generator;

import com.google.common.collect.Maps;
import lombok.RequiredArgsConstructor;
import org.boot.generator.spring.meta.*;
import org.boot.generator.spring.service.renderer.TemplateRenderer;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Comparator;
import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class MvcGenerator {
    private final static String JAVA_EXTENSION = ".java";

    private final TemplateRenderer templateRenderer;

    public void generate(GenProject project, String basePackage, Path packagePath) throws IOException {

        // 목표 서비스 파일 생성
        List<GenSchema> schemas = project.getSchemas();

        for (GenSchema schema : schemas) {
            for (GenTable table : schema.getTables()) {

                boolean isCompositeKey = table.getPrimaryKeys().size() > 1;

                List<Map<String, Object>> pkFields = table.getPrimaryKeys().stream()
                        .sorted(Comparator.comparingInt(GenPrimaryKey::getSeq))
                        .map(pk -> {
                            Map<String, Object> map = Maps.newHashMap();
                            map.put("name", GeneratorUtils.toCamel(pk.getColumn()));
                            map.put("column", pk.getColumn());
                            return map;
                        })
                        .toList();

                List<Map<String, Object>> fkFields = table.getForeignKeys().stream()
                        .sorted(Comparator.comparingInt(GenForeignKey::getSeq))
                        .map(fk -> {
                            Map<String, Object> map = Maps.newHashMap();
                            map.put("name", GeneratorUtils.toCamel(fk.getColumn()));
                            map.put("column", fk.getColumn());
                            map.put("refColumn", fk.getRefColumn());
                            map.put("refEntity", GeneratorUtils.toPascal(fk.getRefTable()));
                            map.put("refEntityName", GeneratorUtils.toCamel(fk.getRefTable()));
                            map.put("refEntityPackage", GeneratorUtils.toPackagePath(fk.getRefTable()));
                            map.put("refField", GeneratorUtils.toCamel(fk.getRefColumn()));
                            return map;
                        })
                        .toList();

                List<Map<String, Object>> ekFields = table.getExportedKeys().stream()
                        .sorted(Comparator.comparingInt(GenExportedKey::getSeq))
                        .map(ek -> {
                            Map<String, Object> map = Maps.newHashMap();
                            map.put("name", GeneratorUtils.toCamel(ek.getColumn()));
                            map.put("column", ek.getColumn());
                            map.put("subColumn", ek.getSubColumn());
                            map.put("subEntity", GeneratorUtils.toPascal(ek.getSubTable()));
                            map.put("subEntityName", GeneratorUtils.toCamel(ek.getSubTable()));
                            map.put("subEntityPackage", GeneratorUtils.toPackagePath(ek.getSubTable()));
                            map.put("subField", GeneratorUtils.toCamel(ek.getSubColumn()));
                            return map;
                        })
                        .toList();

                List<Map<String, Object>> fields = table.getColumns().stream()
                        .filter(c -> !isAuditColumn(c.getName()))
                        .map(c -> {
                            Map<String, Object> map = Maps.newHashMap();
                            map.put("name", GeneratorUtils.toCamel(c.getName()));
                            map.put("pascalName", GeneratorUtils.toPascal(c.getName()));
                            map.put("column", c.getName());
                            map.put("comment", c.getRemarks());
                            map.put("type", c.getJavaType().getSimpleName());
                            map.put("id", pkFields.stream().anyMatch(pk -> pk.get("column").equals(c.getName())));
                            map.put("imported", fkFields.stream().anyMatch(fk -> fk.get("column").equals(c.getName())));
                            map.put("exported", ekFields.stream().anyMatch(ek -> ek.get("column").equals(c.getName())));
                            return map;
                        })
                        .toList();

                String className = GeneratorUtils.toPascal(table.getName());
                String classPackage = GeneratorUtils.toPackagePath(table.getName());

                Map<String, Object> dataModel = Maps.newHashMap();
                dataModel.put("package", basePackage);
                dataModel.put("classPackage", classPackage);
                dataModel.put("className", className);
                dataModel.put("classCamel", GeneratorUtils.toCamel(table.getName()));
                dataModel.put("table", table.getName());
                dataModel.put("description", table.getRemarks());
                dataModel.put("fields", fields);
                dataModel.put("pkFields", pkFields);
                dataModel.put("fkFields", fkFields);
                dataModel.put("ekFields", ekFields);
                dataModel.put("compositeKey", isCompositeKey);

                Path servicePath = packagePath.resolve(classPackage);


                GeneratorUtils.writeFile(servicePath, "domain", className + "CreateRequest" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "domaincreaterequest.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "domain", className + "SearchRequest" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "domainsearchrequest.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "domain", className + "UpdateRequest" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "domainupdaterequest.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "domain", className + "Response" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "domainresponse.ftl", dataModel));

                if (isCompositeKey) {
                    // generate ID class
                    GeneratorUtils.writeFile(servicePath, "entity", className + "Id" + JAVA_EXTENSION,
                            templateRenderer.render(project.getArchitecture(), "id.ftl", dataModel));
                }

                GeneratorUtils.writeFile(servicePath, "entity", className + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "entity.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "entity", className + "Info" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "info.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "repository", className + "Repository" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "repository.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "service", className + "Service" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "service.ftl", dataModel));

                GeneratorUtils.writeFile(servicePath, "controller", className + "RestController" + JAVA_EXTENSION,
                        templateRenderer.render(project.getArchitecture(), "controller.ftl", dataModel));

            }
        }
    }

    private boolean isAuditColumn(String name) {
        return List.of(
//                "id", "public_id",
                "created_at", "created_by",
                "updated_at", "updated_by"
        ).contains(name);
    }
}