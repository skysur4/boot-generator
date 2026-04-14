package ${package}.${classPackage}.entity;

import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode
@Embeddable
public class ${className}Id implements Serializable {

<#list fields as f>
    <#if f.id>
    @Column(name = "${f.column}")
    private ${f.type} ${f.name};
    </#if>
</#list>

}