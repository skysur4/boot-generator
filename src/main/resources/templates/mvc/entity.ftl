package ${package}.${classPackage}.entity;

import jakarta.persistence.*;
import lombok.Getter;
import ${package}.common.entity.BaseEntity;
<#if compositeKey>
import ${package}.${classPackage}.entity.${className}Id;
</#if>
<#if fields?has_content>
<#list fields as f><#if f.type?upper_case == "UUID">
import java.util.UUID;
import com.fasterxml.uuid.Generators;
</#if></#list>
</#if>
<#if fkFields?has_content>
<#list fkFields as fk>
import ${package}.${fk.refEntityPackage}.entity.${fk.refEntity};
</#list>
</#if>
<#if ekFields?has_content>
import java.util.Set;
<#list ekFields as ek>
import ${package}.${ek.subEntityPackage}.entity.${ek.subEntity};
</#list>
</#if>

@Getter
@Entity
@Table(name = "${table}")
<#if compositeKey>
//@IdClass(${className}Id.class)
</#if>
public class ${className} extends BaseEntity {
    // primary keys
<#if compositeKey>
    @EmbeddedId
    private ${className}Id id;

<#else>
    <#if fields?has_content>
    <#list fields as f>
        <#if f.id>
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "${f.column}", updatable = false)
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
    @Column(name = "${f.column}")
    private ${f.type} ${f.name};

    </#if>
</#list>
</#if>
<#if fkFields?has_content>
    //join parent table
<#list fkFields as fk>
    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("${fk.name}")
    @JoinColumn(name = "${fk.column}", referencedColumnName = "${fk.refColumn}")
    private ${fk.refEntity} ${fk.refEntityName};

</#list>
</#if>
<#if ekFields?has_content>
    /** join child table
      * !!! handle with caution !!!
<#list ekFields as ek>
    @OneToMany
    private Set<${ek.subEntity}Info> ${ek.subEntityName}s;

</#list>
    **/
</#if>

}