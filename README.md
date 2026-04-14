# Boot Generator

## 사용법
### 프로젝트 정보 설정
[application.yml](src/main/resources/application.yml) `generator` 항목 하위 프로젝트로 및 소스가 될 디비 정보 설정

```
  project:
    base-path: '..'                     # 프로젝트 생성 위치 
    - name: test-backend-sevice         # 프로젝트 이름 -를 기준으로 패키지명 추출
      group: bootgen-com                # 프로젝트 그룹 -를 기준으로 패키지명 추출
      desc: '보스 딜량 관리'              # 프로젝트 설명
      architecture: mvc #mvc/crs/qrs    # 아키텍처 패턴 설정 - 각각 MVC, Command, Query 패턴을 의미
      orm: jpa #jpa/mybatis             # 데이터 처리 방식 설정 - 빈값 설정 시 DB 관련 설정 삭제
      hikari-config:                    # orm 빈값 시 필요하지 않음
        driver-class-name: 'org.postgresql.Driver' # PostgreSQL 고정
        jdbc-url: 'jdbc:postgresql://127.0.0.1/postgres'
        username: 'postgres'
        password: 'postgres'
      schema-filter: 'public'           # 다른 스키마가 포함되지 않도록 풀네임 설정
      table-filter: '%test%'            # 모든 테이블 사용 시 '%'
      column-filter: '%'                # 특수한 경우가 아니면 변경 금지
      local-port: 7070                  # 로컬 환경 서버 포트
      destination-path: "file:${generator.base-path}/test-backend-service"  # 프로젝트 생성 폴더
```

#### bootRun 이후
1. http://localhost:8080/swagger 접속
2. `/project` API를 사용하여 프로젝트 생성
3. 해당 프로젝트는 `..`(상위 폴더)에 생성되거나 `generator.project[n].destination-path`를 변경하여 위치 변경이 가능함

