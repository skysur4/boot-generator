package org.boot.generator.spring.meta;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenIndex {
	private String table;
    private String name;
    private String column;
    private Boolean unique;
    private short seq;
}
