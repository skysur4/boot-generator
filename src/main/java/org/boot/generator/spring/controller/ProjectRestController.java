package org.boot.generator.spring.controller;

import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.boot.generator.spring.common.BaseRestController;
import org.boot.generator.spring.meta.GenProject;
import org.boot.generator.spring.service.extractor.ExtractorService;
import org.boot.generator.spring.util.GeneratorUtils;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;

@Slf4j
@RestController
@RequestMapping("/project")
@RequiredArgsConstructor
public class ProjectRestController extends BaseRestController {
    private final ExtractorService extractorService;

    @Operation(summary = "프로젝트 생성", description = "DB 정보를 기반으로 프로젝트 생성")
    @PostMapping
    public ResponseEntity<StreamingResponseBody> createProjects() throws Exception {
        StreamingResponseBody responseBody = outputStream -> {

            log.info("################### Project Info ###################");
            try {
                for (GenProject project : extractorService.extractProject()) {
                    log.info("# Extracted base package: {}", GeneratorUtils.toBasePackage(project.getName()));

                    String message = GeneratorUtils.toBasePackage(project.getName()) + "\n";
                    outputStream.write(message.getBytes());
                    outputStream.flush(); // Flush the buffer to send the chunk immediately
                }
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        };

        return ResponseEntity.ok()
                .contentType(MediaType.TEXT_PLAIN)
                .body(responseBody);
    }
}
