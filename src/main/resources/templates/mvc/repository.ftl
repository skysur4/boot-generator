package ${package}.${classPackage}.repository;

import ${package}.${classPackage}.entity.${className};
import ${package}.common.repository.BaseRepository;
import org.springframework.stereotype.Repository;

@Repository
<#if compositeKey>
public interface ${className}Repository extends BaseRepository<${className}, ${className}Id> {
<#else>
public interface ${className}Repository extends BaseRepository<${className}, Long> {
</#if>

}