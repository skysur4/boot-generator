package org.boot.generator.spring.service.generator;

import lombok.RequiredArgsConstructor;
import org.boot.generator.spring.meta.GenProject;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.file.Path;

@Component
@RequiredArgsConstructor
public class ApplicationGenerator {
    private final static String MVC_ARCHITECTURE = "mvc";
    private final static String CRS_ARCHITECTURE = "crs";
    private final static String QRS_ARCHITECTURE = "qrs";

    private final GradleGenerator gradleGenerator;
    private final CommonGenerator commonGenerator;
    private final PropertyGenerator propertyGenerator;
    private final MvcGenerator mvcGenerator;

    public void generate(GenProject project) throws IOException {
        // 패키지 경로 설정
        String basePackage = GeneratorUtils.toBasePackage(project.getName(), project.getGroup());

        // 파일 기본 패스 설정
        Path projectPath = project.getDestinationPath();
        // 코드 경로 설정
        Path srcPath = projectPath.resolve("src/main");
        Path javaPath = srcPath.resolve("java");
        // 리소스 경로 설정
        Path resourcePath = srcPath.resolve("resources");

        Path packagePath = javaPath.resolve(GeneratorUtils.toBasePath(project.getName(), project.getGroup()));

        gradleGenerator.generate(project, basePackage, packagePath);

        commonGenerator.generate(project, basePackage, packagePath);

        propertyGenerator.generate(project, basePackage, resourcePath);

        if(StringUtils.hasText(project.getOrm())) {
            if(MVC_ARCHITECTURE.equalsIgnoreCase(project.getArchitecture())){
                mvcGenerator.generate(project, basePackage, packagePath);
            }

            if(CRS_ARCHITECTURE.equalsIgnoreCase(project.getArchitecture())){
                //TODO CRS 생성기
            }

            if(QRS_ARCHITECTURE.equalsIgnoreCase(project.getArchitecture())){
                //TODO QRS 생성기
            }
        }
    }
}