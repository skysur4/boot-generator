package ${package}.${classPackage}.controller;

import ${package}.${classPackage}.entity.${className};
import ${package}.${classPackage}.service.${className}Service;
import ${package}.${classPackage}.domain.${className}CreateRequest;
import ${package}.${classPackage}.domain.${className}Response;
import ${package}.${classPackage}.domain.${className}SearchRequest;
import ${package}.${classPackage}.domain.${className}UpdateRequest;
import ${package}.common.controller.BaseRestController;
import ${package}.common.model.PageableResponse;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;

import lombok.RequiredArgsConstructor;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

import java.util.List;

@Tag(name = "${className} API", description = "${className} 정보를 관리합니다")
@RestController
@RequestMapping("/${classPackage}")
@RequiredArgsConstructor
public class ${className}RestController extends BaseRestController {

    private final ${className}Service service;

    @Operation(summary = "${className} 목록/페이지 조회", description = "페이지 사이즈가 0이면 전체 목록을 조회한다")
    @GetMapping
    public PageableResponse<${className}Response> get(${className}SearchRequest request) {
        Specification<${className}> specifications = request.specification();
        Pageable pageable = request.pageable();

        return service.find(specifications, pageable);
    }

    @Operation(summary = "${className} 상세 조회", description = "상세 데이터를 조회한다")
    @GetMapping("/{uId}")
    public ${className}Response get(@PathVariable long uId) {
        return service.find(uId);
    }

    @Operation(summary = "${className} 등록", description = "데이터를 등록한다")
    @PostMapping
    public ResponseEntity<Boolean> create(@RequestBody ${className}CreateRequest request) {
        service.create(request);

        return ResponseEntity.ok(true);
    }

    @Operation(summary = "${className} 수정", description = "데이터를 수정한다")
    @PutMapping
    public ResponseEntity<Boolean> update(@RequestBody ${className}UpdateRequest request) {
        service.modify(request);

        return ResponseEntity.ok(true);
    }

    @Operation(summary = "${className} 저장", description = "데이터를 저장한다")
    @PatchMapping
    public ResponseEntity<Boolean> save(@RequestBody ${className}UpdateRequest request) {
        service.save(request);

        return ResponseEntity.ok(true);
    }

    @Operation(summary = "${className} 목록 삭제", description = "데이터 다수를 삭제한다")
    @DeleteMapping
    public ResponseEntity<Boolean> delete(List<Long> uIds) {
        service.remove(uIds);

        return ResponseEntity.ok(true);
    }

    @Operation(summary = "${className} 삭제", description = "데이터 하나를 삭제한다")
    @DeleteMapping("/{uId}")
    public ResponseEntity<Boolean> delete(@PathVariable long uId) {
        service.remove(uId);

        return ResponseEntity.ok(true);
    }
}