package org.boot.generator.spring.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.stream.Collectors;

public class GeneratorUtils {

    public static String toBasePackage(String name) {
        return Arrays.stream(name.split("-"))
                .collect(Collectors.collectingAndThen(
                        Collectors.toList(),
                        list -> {
                            Collections.reverse(list);
                            return String.join(".", list);
                        }
                ));
    }

}
