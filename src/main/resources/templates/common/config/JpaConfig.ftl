package ${package}.config;

import ${package}.common.repository.BaseRepositoryImpl;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@Configuration
@EntityScan(basePackages = {"${scanPackage}"})
@EnableJpaRepositories(basePackages = "${scanPackage}", repositoryBaseClass = BaseRepositoryImpl.class)
public class JpaConfig  {

}