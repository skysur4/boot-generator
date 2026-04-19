package ${package}.${classPackage}.domain;

import io.swagger.v3.oas.annotations.media.Schema;

import ${package}.common.model.BaseResponse;
<#if compositeKey>
import ${package}.${classPackage}.entity.${className}Id;
</#if>
<#if fields?has_content>
<#list fields as f><#if f.type?upper_case == "UUID">
import java.util.UUID;
</#if></#list>
</#if>
<#if fkFields?has_content>
<#list fkFields as fk>
import ${package}.${fk.refEntityPackage}.domain.${fk.refEntity}Response;
</#list>
</#if>
<#if ekFields?has_content>
<#list ekFields as ek>
import ${package}.${ek.subEntityPackage}.domain.${ek.subEntity}Response;
</#list>

import java.util.Set;
</#if>

import lombok.Getter;

@Getter
public class ${className}Response extends BaseResponse {
    // primary key
<#if fields?has_content>
<#list fields as f>
    <#if f.id>
    @Schema(description = "${f.comment!}")
    private ${f.type} ${f.name};

    </#if>
</#list>
</#if>
    // fields
<#if fields?has_content>
<#list fields as f>
    <#if f.id>
    <#elseif f.imported || f.exported>
    <#else>
    @Schema(description = "${f.comment!}")
    private ${f.type} ${f.name};

    </#if>
</#list>
</#if>

    //join parent table
<#if fkFields?has_content>
<#list fkFields as fk>
    @Schema(description = "${fk.refEntity} 정보")
    private ${fk.refEntity}Response ${fk.refEntityName};

</#list>
</#if>

}