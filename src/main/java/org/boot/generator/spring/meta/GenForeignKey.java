package org.boot.generator.spring.meta;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenForeignKey {
	private String table;
    private String column;
    private String refTable;
    private String refColumn;
    private short seq;
}