package ${package}.${classPackage}.entity;

import ${package}.common.entity.BaseInfo;

<#if fields?has_content>
<#list fields as f><#if f.type?upper_case == "UUID">
import java.util.UUID;
</#if></#list>
</#if>

<#if fkFields?has_content>
<#list fkFields as fk>
import ${package}.${fk.refEntityPackage}.entity.${fk.refEntity}Info;
</#list>
</#if>

<#if ekFields?has_content>
<#list ekFields as ek>
import ${package}.${ek.subEntityPackage}.entity.${ek.subEntity}Info;
</#list>

import java.util.Set;
</#if>

import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class ${className}Info extends BaseInfo {
    // primary key
<#if compositeKey>
    private ${className}IdInfo id;

<#else>
    <#if fields?has_content>
    <#list fields as f>
        <#if f.id>
    private ${f.type} ${f.name};

        </#if>
    </#list>
    </#if>
</#if>
    // fields
<#if fields?has_content>
<#list fields as f>
    <#if f.id>
    <#elseif f.imported || f.exported>
    <#else>
    private ${f.type} ${f.name};

    </#if>
</#list>
</#if>

<#if fkFields?has_content>
    //join parent table
<#list fkFields as fk>
    ${fk.refEntity}Info ${fk.refEntityName};

</#list>
</#if>
<#if ekFields?has_content>
    /** join child table
      * !!! handle with caution !!!
<#list ekFields as ek>
    Set<${ek.subEntity}Info> ${ek.subEntityName};

</#list>
    **/
</#if>
<#if compositeKey>
    public class ${className}IdInfo {
    <#if fields?has_content>
    <#list fields as f>
        <#if f.id>
        private ${f.type} ${f.name};
        </#if>
    </#list>
    </#if>
    }
</#if>
}