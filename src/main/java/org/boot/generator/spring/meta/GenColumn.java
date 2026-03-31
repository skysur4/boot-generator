package org.boot.generator.spring.meta;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenColumn {
	private String table;
    private String name;
    private String type;
    private Class<?> javaType;
    private int size;
    private int digit;
    private int radix;
    private Boolean nullable;
    private String autoincrement;
    private String defaultValue;
    private String remarks;
    private int seq;
}
