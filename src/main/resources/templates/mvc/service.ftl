package ${package}.${classPackage}.service;

import ${package}.${classPackage}.entity.${className};
import ${package}.${classPackage}.entity.${className}Info;
<#if compositeKey>
import ${package}.${classPackage}.entity.${className}Id;
</#if>
import ${package}.common.service.BaseService;
import ${package}.${classPackage}.repository.${className}Repository;

import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class ${className}Service extends BaseService {

    private final ${className}Repository repository;

    @Transactional(readOnly = true)
    public List<${className}Info> list(Specification<${className}> spec, Sort sort) throws Exception {
        return repository.list(spec, sort, ${className}Info.class);

    }

    @Transactional(readOnly = true)
    public Page<${className}Info> page(Specification<${className}> spec, Pageable pageable) throws Exception {
        return repository.page(spec, pageable, ${className}Info.class);

    }

    @Transactional(readOnly = true)
<#if compositeKey>
    public ${className}Info retrieve(${className}Id id) throws Exception {
<#else>
    public ${className}Info retrieve(Long id) throws Exception {
</#if>
        return repository.retrieve(id, ${className}Info.class);
    }

    @Transactional
    public HttpStatus create(${className} ${classCamel}) throws Exception {
        repository.insert(${classCamel});

        return ${classCamel}.getStatus();
    }

    @Transactional
    public HttpStatus modify(${className} ${classCamel}) throws Exception {
        repository.update(${classCamel});

        return ${classCamel}.getStatus();
    }

    @Transactional
    public HttpStatus merge(${className} ${classCamel}) throws Exception {
        repository.save(${classCamel});

        return ${classCamel}.getStatus();
    }

    @Transactional
<#if compositeKey>
    public void remove(Set<${className}Id> ids) throws Exception {
<#else>
    public void remove(Set<Long> ids) throws Exception {
</#if>
        repository.deleteAllByIdInBatch(ids);
    }

    @Transactional
<#if compositeKey>
    public void remove(${className}Id id) throws Exception {
<#else>
    public void remove(Long id) throws Exception {
</#if>
        repository.deleteById(id);
    }

}