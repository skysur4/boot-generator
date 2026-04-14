################################################ Server 설정 ################################################
server:
  port: ${localPort}

################################################ SPRING BOOT ################################################
spring:
<#if orm?has_content>
    <#if orm == "jpa">
  jpa:
    properties:
      hibernate:
        format_sql: true         # SQL 예쁘게 출력
        use_sql_comments: true   # SQL에 주석 포함
    </#if>
</#if>
################################################ LOGGING ################################################
logging:
  level:
    root: INFO
<#if orm?has_content>
    <#if orm == "jpa">
    org:
      hibernate:
        orm:
          jdbc:
            bind: TRACE
    </#if>
</#if>