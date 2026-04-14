plugins {
    id 'org.springframework.boot'
}

apply plugin: 'java'
apply plugin: 'io.spring.dependency-management'

ext {
    BRANCH_NAME = project.findProperty("branchName") ?: "local"
    println "[ BRANCH_NAME ] : $BRANCH_NAME"
    BUILD_NUMBER = project.findProperty("buildVersion") ?: "0.0.1-SNAPSHOT"
    println "[ BUILD_NUMBER ] : $BUILD_NUMBER"
    IS_LOCAL = BRANCH_NAME.equals("local")
    IS_RELEASE = BRANCH_NAME.contains("refs/tags/") || BRANCH_NAME.contains("stg")
    println "[ IS_LOCAL : IS_RELEASE ] : $IS_LOCAL : $IS_RELEASE"

    TIME_ZONE = TimeZone.getTimeZone("Asia/Seoul")                     // 한국 시간대
    BUILD_TIME = new Date().format("yyyy-MM-dd HH:mm:ss", TIME_ZONE)   // 빌드 시간

    // CI/CD Variables
    NEXUS_URL = project.findProperty('NEXUS_URL') ?: System.getenv('NEXUS_URL')
    NEXUS_ID = project.findProperty('NEXUS_ID') ?: System.getenv('NEXUS_ID')
    NEXUS_PASSWORD = project.findProperty('NEXUS_PASSWORD') ?: System.getenv('NEXUS_PASSWORD')
    NEXUS_PUBLIC_REPOSITORY = project.findProperty('NEXUS_PUBLIC_REPOSITORY') ?: (System.getenv('NEXUS_PUBLIC_REPOSITORY') ?: 'maven-public')
    NEXUS_RELEASE_REPOSITORY = project.findProperty('NEXUS_RELEASE_REPOSITORY') ?: (System.getenv('NEXUS_RELEASE_REPOSITORY') ?: 'maven-releases')
    NEXUS_SNAPSHOT_REPOSITORY = project.findProperty('NEXUS_SNAPSHOT_REPOSITORY') ?: (System.getenv('NEXUS_SNAPSHOT_REPOSITORY') ?: 'maven-snapshot')
}

group = '${group}'
version = BUILD_NUMBER
description = '${desc}'
<#noparse>
println "[ project.group ] : ${group}"
println "[ project.version ] : ${version}"
println "[ project.description ] : ${description}"
</#noparse>
allprojects {
    configurations.configureEach {
        resolutionStrategy.cacheChangingModulesFor 0, 'seconds'
    }
}

dependencies {
    developmentOnly 'org.springframework.boot:spring-boot-devtools'

    implementation 'org.springframework.boot:spring-boot-starter'
    implementation 'org.springframework.boot:spring-boot-starter-web'

    // OAuth2
    implementation 'org.springframework.boot:spring-boot-starter-oauth2-client'
    implementation 'org.springframework.boot:spring-boot-starter-oauth2-resource-server'

    // JSON
    implementation 'org.springframework.boot:spring-boot-starter-json'

    // lombok
    implementation 'org.projectlombok:lombok'
    annotationProcessor 'org.projectlombok:lombok'

    // database
<#if orm?has_content>
    implementation 'org.postgresql:postgresql'
    implementation 'org.springframework.boot:spring-boot-starter-jdbc'
    <#if orm == "jpa">
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa'
    </#if>
    <#if orm == "mybatis">
    implementation libs.mybatis.starter
    </#if>
    <#else>
    implementation 'org.springframework.data:spring-data-commons'
</#if>

    // uuid
    implementation libs.uuid.generator
    // guava
    implementation libs.google.guava
    // swagger
    implementation libs.swagger.mvc
    // freemarker
    implementation libs.apache.freemarker

    testImplementation platform('org.junit:junit-bom:5.10.0')
    testImplementation 'org.junit.jupiter:junit-jupiter'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
}

java {
    sourceCompatibility = JavaVersion.VERSION_21
    targetCompatibility = JavaVersion.VERSION_21
}

bootJar  {
    enabled = false
    mainClass = '${basePackage}.Application'
}

jar {
    enabled = true
    archiveClassifier = '' //jar파일명에 -plain 제거
}

test {
    useJUnitPlatform()
}
