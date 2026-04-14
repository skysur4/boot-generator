package ${package}.${classPackage}.domain;

import ${package}.common.annotation.Search;
import ${package}.common.annotation.SearchOrder;
import ${package}.common.enums.CompareOperator;
import ${package}.common.model.SearchRequest;

import io.swagger.v3.oas.annotations.Parameter;
import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class ${className}SearchRequest extends SearchRequest {
    public ${className}SearchRequest(Integer pageNumber, Integer pageSize, String orders) {
        super(pageNumber, pageSize, orders);
    }
<#if fields?has_content>
<#list fields as f>
    <#if f?is_first>
    @SearchOrder(order = 1)
    </#if>
    <#if f.id>
    <#elseif f.imported || f.exported>
    <#elseif f.type?upper_case == "UUID">
    <#else>
    @Search
    @Parameter(description = "${f.comment!}")
    private ${f.type} ${f.name};

    </#if>
</#list>
</#if>
}