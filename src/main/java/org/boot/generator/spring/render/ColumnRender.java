package org.boot.generator.spring.render;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class ColumnRender {
    private String name;
    private String columnName;
    private Class<?> type;
    private boolean id;
}
