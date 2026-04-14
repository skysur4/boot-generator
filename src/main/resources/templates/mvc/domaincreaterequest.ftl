package ${package}.${classPackage}.domain;

import io.swagger.v3.oas.annotations.media.Schema;
<#if fields?has_content>
<#list fields as f><#if f.type?upper_case == "UUID">
import java.util.UUID;
import com.fasterxml.uuid.Generators;
</#if></#list>
</#if>

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ${className}CreateRequest {
<#if fields?has_content>
<#list fields as f>
    <#if f.id>
    <#elseif f.imported || f.exported>
    <#elseif f.type?upper_case == "UUID">
    @Schema(description = "${f.comment!}", hidden = true)
    private final ${f.type} ${f.name} = Generators.timeBasedEpochGenerator().generate();

    <#else>
    @Schema(description = "${f.comment!}")
    private ${f.type} ${f.name};

    </#if>
</#list>
</#if>
}