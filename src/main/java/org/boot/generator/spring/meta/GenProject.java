package org.boot.generator.spring.meta;

import com.google.common.collect.Lists;
import lombok.*;

import java.util.List;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenProject {
    private String name;
    private String architecture;
    private String dbFramework;
    private List<GenSchema> schemas;
}
