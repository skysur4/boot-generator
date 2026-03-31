package org.boot.generator.spring.util;

import java.util.Arrays;
import java.util.Collections;
import java.util.stream.Collectors;

public class GeneratorUtils {

    public static String toBasePackage(String input) {
        return Arrays.stream(input.split("-"))
                .collect(Collectors.collectingAndThen(
                        Collectors.toList(),
                        list -> {
                            Collections.reverse(list);
                            return String.join(".", list);
                        }
                ));
    }

    public static String toCamel(String input) {
        StringBuilder result = new StringBuilder();
        boolean upper = false;

        for (char c : input.toCharArray()) {
            if (c == '_') {
                upper = true;
            } else {
                result.append(upper ? Character.toUpperCase(c) : c);
                upper = false;
            }
        }
        return result.toString();
    }

    public static String toPascal(String input) {
        String camel = toCamel(input);
        return Character.toUpperCase(camel.charAt(0)) + camel.substring(1);
    }
}
