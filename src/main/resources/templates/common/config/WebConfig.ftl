package ${package}.config;

import ${package}.common.util.SimpleObjectMapper;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.util.TimeZone;

@Slf4j
@Configuration
@RequiredArgsConstructor
@ComponentScan(basePackages = {"${scanPackage}"})
public class WebConfig implements WebMvcConfigurer {
	<#noparse>@Value("${spring.application.name:SYSTEM}")</#noparse>
	private String applicationName;

	@PostConstruct
	public void init() {
		String t = TimeZone.getDefault().getDisplayName();
		log.info("[{}] started at {} {}", applicationName, t, ZonedDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss VV")));
	}

    @Bean
    SimpleObjectMapper simpleObjectMapper(){
        return new SimpleObjectMapper();
    }
}