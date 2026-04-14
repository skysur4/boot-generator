package ${package}.${classPackage}.domain;

import ${package}.${classPackage}.domain.${className}CreateRequest;
<#if fields?has_content>
<#list fields as f><#if f.id && f.type?upper_case == "UUID">
import java.util.UUID;
</#if></#list>
</#if>
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
public class ${className}UpdateRequest extends ${className}CreateRequest {
<#if fields?has_content>
<#list fields as f>
    <#if f.id>
    @Schema(description = "${f.comment!}")
    private ${f.type} ${f.name};
    </#if>
</#list>
</#if>
}