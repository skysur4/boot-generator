package ${package}.${classPackage}.controller;

import ${package}.${classPackage}.entity.${className};
import ${package}.${classPackage}.service.${className}Service;
import ${package}.${classPackage}.domain.${className}CreateRequest;
import ${package}.${classPackage}.domain.${className}Response;
import ${package}.${classPackage}.domain.${className}SearchRequest;
import ${package}.${classPackage}.domain.${className}UpdateRequest;
import ${package}.common.controller.BaseRestController;
import ${package}.common.model.PageableResponse;

import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.jpa.domain.Specification;

import lombok.extern.slf4j.Slf4j;
import lombok.RequiredArgsConstructor;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

<#if compositeKey>
import ${package}.${classPackage}.entity.${className}Id;
</#if>
<#if fields?has_content>
<#list fields as f>
<#if f.id && f.type?upper_case == "UUID">
import java.util.UUID;
</#if>
</#list>
</#if>
import ${package}.${classPackage}.entity.${className}Info;

import java.util.List;
import java.util.Set;

@Slf4j
@Tag(name = "${className} API", description = "${className} 정보를 관리합니다")
@RestController
@RequestMapping("/${classPackage}")
@RequiredArgsConstructor
public class ${className}RestController extends BaseRestController {

    private final ${className}Service service;

    @Operation(summary = "${className} 목록/페이지 조회", description = "페이지 사이즈가 0이면 전체 목록을 조회한다")
    @GetMapping
    public ResponseEntity<PageableResponse<${className}Response>> get(${className}SearchRequest request) {

        try {
            Specification<${className}> specifications = request.specification();

            PageableResponse<${className}Response> pageableResponse;
            if(request.isPageable()){
                Page<${className}Info> page = service.page(specifications, request.pageable());
                pageableResponse = PageableResponse.from(page, ${className}Response.class);

            } else {
                List<${className}Info> list = service.list(specifications, request.sort());
                pageableResponse = PageableResponse.from(list, ${className}Response.class);

            }

            return ResponseEntity.ok(pageableResponse);

        } catch (Exception e){
            log.error("Error while searching {}: {}", request, e.getMessage());

            return ResponseEntity.internalServerError().build();
        }


    }

    @Operation(summary = "${className} 상세 조회", description = "상세 데이터를 조회한다")
<#if compositeKey>
    @GetMapping("<#if fields?has_content><#list fields?filter(field -> field.id) as f>/{${f.name}}</#list></#if>")
    public ResponseEntity<${className}Response> get(<#if fields?has_content><#list fields?filter(field -> field.id) as f>@PathVariable ${f.type} ${f.name}<#sep>, </#sep></#list></#if>) {
        ${className}Id identifier = new ${className}Id(<#if fields?has_content><#list fields?filter(field -> field.id) as f>${f.name}<#sep>, </#sep></#list></#if>);

<#else>
    @GetMapping("/{identifier}")
    public ResponseEntity<${className}Response> get(@PathVariable long identifier) {

</#if>
        try {
            ${className}Info item = service.retrieve(identifier);

            return ResponseEntity.ok(PageableResponse.from(item, ${className}Response.class));

        } catch (Exception e){
            log.error("Error while getting {}: {}", identifier, e.getMessage());

            return ResponseEntity.internalServerError().build();
        }
    }

    @Operation(summary = "${className} 등록", description = "데이터를 등록한다")
    @PostMapping
    public ResponseEntity<Boolean> create(@RequestBody ${className}CreateRequest request) {
        try {
            ${className} ${classCamel} = converter.map(request, ${className}.class);

            return ResponseEntity.status(service.create(${classCamel})).body(true);

        } catch (Exception e){
            log.error("Error while creating {}: {}", request, e.getMessage());

            return ResponseEntity.internalServerError().body(false);
        }
    }

    @Operation(summary = "${className} 수정", description = "데이터를 수정한다")
    @PutMapping
    public ResponseEntity<Boolean> update(@RequestBody ${className}UpdateRequest request) {
        try {
            ${className} ${classCamel} = converter.map(request, ${className}.class);

            return ResponseEntity.status(service.modify(${classCamel})).body(true);

        } catch (Exception e){
            log.error("Error while modifying {}: {}", request, e.getMessage());

            return ResponseEntity.internalServerError().body(false);
        }
    }

    @Operation(summary = "${className} 저장", description = "데이터를 저장한다")
    @PatchMapping
    public ResponseEntity<Boolean> save(@RequestBody ${className}UpdateRequest request) {
        try {
            ${className} ${classCamel} = converter.map(request, ${className}.class);

            return ResponseEntity.status(service.merge(${classCamel})).body(true);

        } catch (Exception e){
            log.error("Error while merging {}: {}", request, e.getMessage());

            return ResponseEntity.internalServerError().body(false);
        }
    }

    @Operation(summary = "${className} 목록 삭제", description = "데이터 다수를 삭제한다")
<#if compositeKey>
    @DeleteMapping
    public ResponseEntity<Boolean> delete(Set<${className}Id> identifiers) {
<#else>
    @DeleteMapping
    public ResponseEntity<Boolean> delete(Set<Long> identifiers) {
</#if>
        try {
            service.remove(identifiers);

            return ResponseEntity.ok(true);
        } catch (Exception e){
            log.error("Error while cleaning {}: {}", identifiers, e.getMessage());

            return ResponseEntity.internalServerError().body(false);
        }
    }

    @Operation(summary = "${className} 삭제", description = "데이터 하나를 삭제한다")
<#if compositeKey>
    @DeleteMapping("<#if fields?has_content><#list fields?filter(field -> field.id) as f>/{${f.name}}</#list></#if>")
    public ResponseEntity<Boolean> delete(<#if fields?has_content><#list fields?filter(field -> field.id) as f>@PathVariable ${f.type} ${f.name}<#sep>, </#sep></#list></#if>) {
            ${className}Id identifier = new ${className}Id(<#if fields?has_content><#list fields?filter(field -> field.id) as f>${f.name}<#sep>, </#sep></#list></#if>);

<#else>
    @DeleteMapping("/{identifier}")
    public ResponseEntity<Boolean> delete(@PathVariable Long identifier) {
</#if>
        try {
            service.remove(identifier);

            return ResponseEntity.ok(true);
        } catch (Exception e){
            log.error("Error while deleting {}: {}", identifier, e.getMessage());

            return ResponseEntity.internalServerError().body(false);
        }
    }
}