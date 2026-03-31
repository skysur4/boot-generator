# Boot Generator

## 사용법
### 프로젝트 정보 설정
[application.yml](src/main/resources/application.yml) `generator` 항목 하위 프로젝트로 및 소스가 될 디비 정보 설정

```
  project:
    - name: test-backend-sevice # 프로젝트명 -를 기준으로 패키지명 추출
      pattern: mvc #mvc/cqrs    # 아키텍처 패턴 설정
      orm: jpa #jpa/mybatis     # 데이터 처리 방식 설정
      hikari-config:
        driver-class-name: 'org.postgresql.Driver' # PostgreSQL만 사용
        jdbc-url: 'jdbc:postgresql://127.0.0.1/postgres'
        username: 'postgres'
        password: 'postgres'
      schema-filter: 'public'   # 다른 스키마가 포함되지 않도록 풀네임 설정
      table-filter: '%test%'    # 모든 테이블 사용 시 '%'
      column-filter: '%'        # 특수한 경우가 아니면 변경 금지
```

#### bootRun 이후
1. http://localhost:8080/swagger 접속
2. `/api/project` API를 사용하여 프로젝트 생성
3. 해당 프로젝트는 `..`(상위 폴더)에 생성되거나 `generator.destination-path`를 변경하여 위치 변경이 가능함

