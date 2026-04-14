################################################ Server 설정 ################################################
server:
  port: 8080

################################################ SPRING BOOT ################################################
spring:
  profiles:
    active: local

  application:
    name: ${name}

<#if orm?has_content>
  ### datasource 설정 ###
  datasource:
    driver-class-name: '${driverClassName}'
    url: '${url}'
    username: '${username}'
    password: '${password}'
    hikari:
      connection-timeout: 30000
      validation-timeout: 30000
      minimum-idle: 5
      max-lifetime: 240000
      maximum-pool-size: 5

    <#if orm == "jpa">
  ### JPA 설정 ###
  jpa:
    hibernate:
      ddl-auto: validate # 테이블 유효성 검사
      naming.physical-strategy: org.hibernate.boot.model.naming.CamelCaseToUnderscoresNamingStrategy
    properties:
      hibernate:
        show_sql: true
        format_sql: true
        use_sql_comments: true
    </#if>
</#if>

# ==================================== Swagger 설정 ====================================
springdoc:
  auto-response-codes: false
  swagger-ui:
    path: /swagger
  api-docs:
    path: /swagger/docs
    groups:
      enabled: true
  cache:
    disabled: true
  api-info:
    title: Boot Generator
    description: API in/out for AMIS 3.0
    version: 1.0.0
    terms-of-service: http://${groupUrl}/termsofservice
    contact:
      name: Administrator
      url: https://${groupUrl}
      email: admin@${groupUrl}
    license:
      name: MIT License
      url: https://${groupUrl}/license

<#if orm?has_content>
    <#if orm == "mybatis">
################################################ mybatis ################################################
mybatis:
  type-aliases-package: '${package}'
  configuration:
    map-underscore-to-camel-case: true
  mapper-locations:
    - classpath:mappers/**/*Mapper.xml
    </#if>
</#if>