package ${package}.${classPackage}.domain;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.Setter;

<#if compositeKey>
import ${package}.${classPackage}.entity.${f.className}Id;
        </#if>
        <#if fields?has_content>
        <#list fields as f><#if f.type?upper_case == "UUID">
import java.util.UUID;
import com.fasterxml.uuid.Generators;
</#if></#list>
        </#if>
        <#if fkFields?has_content>
        <#list fkFields as fk>
import ${package}.${fk.refEntityPackage}.domain.${fk.refEntity}Response;
        </#list>
        </#if>
        <#if ekFields?has_content>
import java.util.List;
<#list ekFields as ek>
import ${package}.${ek.subEntityPackage}.domain.${ek.subEntity}Response;
</#list>
</#if>

@Getter
@Setter
public class ${className}Response {
<#if fields?has_content>
<#list fields as f>
    <#if f.id>
    <#elseif f.imported || f.exported>
    <#elseif f.type?upper_case == "UUID">
    @Schema(description = "${f.comment!}", hidden = true)
    private ${f.type} ${f.name} = Generators.timeBasedEpochGenerator().generate();

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