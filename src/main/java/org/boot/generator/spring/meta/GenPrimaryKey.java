package org.boot.generator.spring.meta;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenPrimaryKey {
	private String table;
    private String name;
    private String column;
    private short seq;
}
