package org.boot.generator.spring.service.generator;

import com.google.common.collect.Maps;
import lombok.RequiredArgsConstructor;
import org.boot.generator.spring.meta.GenProject;
import org.boot.generator.spring.service.renderer.TemplateRenderer;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.file.Path;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class CommonGenerator {
    private final static String APP_ARCHITECTURE = "app";
    private final static String COMMON_ARCHITECTURE = "common";
    private final static String JPA_ORM = "jpa";
    private final static String MYBATIS_ORM = "mybatis";
    private final static String JAVA_EXTENSION = ".java";

    private final TemplateRenderer templateRenderer;

    public void generate(GenProject project, String basePackage, Path packagePath) throws IOException {

        // ==================================== 앱 파일 생성 ====================================
        Map<String, Object> packageModel = Maps.newHashMap();
        packageModel.put("package", basePackage);

        GeneratorUtils.writeFile(packagePath, "Application" + JAVA_EXTENSION,
                templateRenderer.render(APP_ARCHITECTURE, "Application.ftl", packageModel));

        GeneratorUtils.writeFile(packagePath, "AppConstants" + JAVA_EXTENSION,
                templateRenderer.render(APP_ARCHITECTURE, "AppConstants.ftl", packageModel));

        // ==================================== 설정 파일 생성 ====================================
        Map<String, Object> configModel = Maps.newHashMap();
        configModel.put("package", basePackage);
        configModel.put("scanPackage", GeneratorUtils.toBasePackage(project.getGroup()));

        GeneratorUtils.writeFile(packagePath, "config", "WebConfig" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "config/WebConfig.ftl", configModel));

        GeneratorUtils.writeFile(packagePath, "config", "SecurityConfig" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "config/SecurityConfig.ftl", configModel));

        GeneratorUtils.writeFile(packagePath, "config", "RequestMappingConfig" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "config/RequestMappingConfig.ftl", configModel));

        // JPA Datasource 사용 시
        if(JPA_ORM.equalsIgnoreCase(project.getOrm())){

            GeneratorUtils.writeFile(packagePath, "config", "JpaConfig" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "config/JpaConfig.ftl", configModel));

        }

        // ==================================== 공통 서비스 파일 생성 ====================================
        Path commonPath = packagePath.resolve(COMMON_ARCHITECTURE);

        Map<String, Object> commonModel = Maps.newHashMap();
        commonModel.put("package", basePackage);

        GeneratorUtils.writeFile(commonPath, "context", "UserContext" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "context/UserContext.ftl", commonModel));

        GeneratorUtils.writeFile(commonPath, "controller", "BaseRestController" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "controller/BaseRestController.ftl", commonModel));

        GeneratorUtils.writeFile(commonPath, "handler", "InheritedRequestMappingHandler" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "handler/InheritedRequestMappingHandler.ftl", commonModel));

        GeneratorUtils.writeFile(commonPath, "util", "SimpleObjectMapper" + JAVA_EXTENSION,
                templateRenderer.render(COMMON_ARCHITECTURE, "util/SimpleObjectMapper.ftl", commonModel));

        // Datasource 사용 시
        if(StringUtils.hasText(project.getOrm())){

            GeneratorUtils.writeFile(commonPath, "annotation", "Search" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "annotation/Search.ftl", commonModel));

            GeneratorUtils.writeFile(commonPath, "annotation", "SearchOrder" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "annotation/SearchOrder.ftl", commonModel));

            GeneratorUtils.writeFile(commonPath, "enum", "CompareOperator" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "enum/CompareOperator.ftl", commonModel));

            GeneratorUtils.writeFile(commonPath, "model", "PageableResponse" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "model/PageableResponse.ftl", commonModel));

            GeneratorUtils.writeFile(commonPath, "model", "SearchRequest" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "model/SearchRequest.ftl", commonModel));

        }

        // JPA Datasource 사용 시
        if(JPA_ORM.equalsIgnoreCase(project.getOrm())){

            GeneratorUtils.writeFile(commonPath, "entity", "BaseEntity" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "entity/BaseEntity.ftl", commonModel));

            GeneratorUtils.writeFile(commonPath, "repository", "BaseRepository" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "repository/BaseRepository.ftl", commonModel));

            GeneratorUtils.writeFile(commonPath, "repository", "BaseRepositoryImpl" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "repository/BaseRepositoryImpl.ftl", commonModel));
        }

        // Mybatis Datasource 사용 시
        if(MYBATIS_ORM.equalsIgnoreCase(project.getOrm())){

            GeneratorUtils.writeFile(commonPath, "model", "BaseModel" + JAVA_EXTENSION,
                    templateRenderer.render(COMMON_ARCHITECTURE, "model/BaseModel.ftl", commonModel));

        }
    }
}