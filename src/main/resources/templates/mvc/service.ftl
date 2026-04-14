package ${package}.${classPackage}.service;

import ${package}.${classPackage}.entity.${className};
import ${package}.${classPackage}.repository.${className}Repository;
import ${package}.${classPackage}.domain.${className}CreateRequest;
import ${package}.${classPackage}.domain.${className}Response;
import ${package}.${classPackage}.domain.${className}UpdateRequest;
import ${package}.common.model.PageableResponse;
import ${package}.common.util.SimpleObjectMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ${className}Service {

    private final ${className}Repository repository;
    private final SimpleObjectMapper converter;

    public PageableResponse<${className}Response> find(Specification<${className}> spec) {
        List<${className}> list = repository.findAll(spec);

        return PageableResponse.from(list, ${className}Response.class);
    }

    public PageableResponse<${className}Response> find(Specification<${className}> spec, Pageable pageable) {
        Page<${className}> page = repository.findAll(spec, pageable);

        return PageableResponse.from(page, ${className}Response.class);
    }

    public ${className}Response find(Long id) {
        Optional<${className}> optional = repository.findById(id);

        return optional.map(member -> converter.map(member, ${className}Response.class)).orElse(null);
    }

    public void create(${className}CreateRequest request) {
        repository.insert(converter.map(request, ${className}.class));
    }

    public void modify(${className}UpdateRequest request) {
        repository.update(converter.map(request, ${className}.class));
    }

    public void save(${className}CreateRequest request) {
        repository.save(converter.map(request, ${className}.class));
    }

    public void remove(List<Long> ids) {
        repository.deleteAllByIdInBatch(ids);
    }

    public void remove(Long id) {
        repository.deleteById(id);
    }

}