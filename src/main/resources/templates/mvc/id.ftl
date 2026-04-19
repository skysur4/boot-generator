package ${package}.${classPackage}.entity;

import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;
<#if fields?has_content>
<#list fields as f>
<#if f.id && f.type?upper_case == "UUID">
import java.util.UUID;
</#if>
</#list>
</#if>

@Data
@Embeddable
@NoArgsConstructor
@AllArgsConstructor
public class ${className}Id implements Serializable {

<#list fields as f>
    <#if f.id>
    @Column(name = "${f.column}")
    private ${f.type} ${f.name};

    </#if>
</#list>

}