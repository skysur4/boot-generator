package org.boot.generator.spring.config;

import org.boot.generator.spring.handler.InheritedRequestMappingHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.DelegatingWebMvcConfiguration;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

/**
 * BaseController 및 BaseV1Controller의 requestMapping 경로를 상속 받도록 설정
 */
@Configuration
public class RequestMappingConfig extends DelegatingWebMvcConfiguration {
    @Override
    protected RequestMappingHandlerMapping createRequestMappingHandlerMapping() {
        return new InheritedRequestMappingHandler();
    }
}