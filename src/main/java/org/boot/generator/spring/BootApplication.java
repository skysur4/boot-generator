package org.boot.generator.spring;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

import java.util.Locale;
import java.util.TimeZone;

@Slf4j
@EnableCaching
@SpringBootApplication
public class BootApplication {

    public static void main(String[] args) {
        TimeZone.setDefault(TimeZone.getTimeZone("Asia/Seoul"));
        Locale.setDefault(Locale.KOREA);

        SpringApplication.run(BootApplication.class, args);
    }
}
