package org.boot.generator.spring.meta;

import com.google.common.collect.Lists;
import lombok.*;

import java.util.List;

@ToString
@Getter
@RequiredArgsConstructor
public class GenSchema {
    private final String name;

    @Setter
    private List<GenTable> tables = Lists.newArrayList();

    public void addTable(GenTable genTable){
        tables.add(genTable);
    }
}
