package org.boot.generator.spring.meta;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenExportedKey {
	private String table;
    private String column;
    private String subTable;
    private String subColumn;
    private short seq;
}