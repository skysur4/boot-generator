package org.boot.generator.spring.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.Collections;
import java.util.Objects;
import java.util.stream.Collectors;

public class GeneratorUtils {

    public static String toBasePackage(String... inputs) {
        return Arrays.stream(String.join("-", inputs).split("-"))
                .collect(Collectors.collectingAndThen(
                        Collectors.toList(),
                        list -> {
                            Collections.reverse(list);
                            return String.join(".", list);
                        }
                ));
    }

    public static String toBasePath(String... inputs) {
        return Arrays.stream(String.join("-", inputs).split("-"))
                .collect(Collectors.collectingAndThen(
                        Collectors.toList(),
                        list -> {
                            Collections.reverse(list);
                            return String.join("/", list);
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

    public static String toPackagePath(String input) {
        String camel = toCamel(input);
        return camel.toLowerCase();
    }

    /**
     *
     * @param root 기본 경로
     * @param fileName 생성될 파일명
     * @param content 파일 내용
     */
    public static void writeFile(Path root, String fileName, String content) throws IOException {
        Files.createDirectories(root);

        Path file = root.resolve(fileName);
        Files.writeString(file, content);
    }

    /**
     *
     * @param root 기본 경로
     * @param layer 하위 경로
     * @param fileName 생성될 파일명
     * @param content 파일 내용
     */
    public static void writeFile(Path root, String layer, String fileName, String content) throws IOException {
        Path dir = root.resolve(layer);

        writeFile(dir, fileName, content);
    }

    public static void copyRawFiles(File[] files, Path tar) throws IOException, URISyntaxException {
        Files.createDirectories(tar);

        for(File file : files){
            if(file.isDirectory()){
                Path newFolder = tar.resolve(file.getName());
                copyRawFiles(Objects.requireNonNull(file.listFiles()), newFolder);
            } else {
                Path newPath = tar.resolve(file.getName());
                Files.copy(new FileInputStream(file), newPath, StandardCopyOption.REPLACE_EXISTING);
            }
        }
    }
}
