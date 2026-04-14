package org.boot.generator.spring.meta;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

import java.util.List;

@ToString
@Builder
@Getter
@AllArgsConstructor
public class GenTable {
    private final String name;
    private final String remarks;
    private List<GenColumn> columns;
    private List<GenPrimaryKey> primaryKeys;
    private List<GenForeignKey> foreignKeys;
    private List<GenExportedKey> exportedKeys;
    private List<GenIndex> indices;
}
