package org.boot.generator.spring.converter;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

public class Db2JavaTypeConverter {
    private static final Map<String, Class<?>> typeMap = new HashMap<>();
    static {
        // Numeric types
        typeMap.put("int2", Short.class);          // SMALLINT
        typeMap.put("smallint", Short.class);      // SMALLINT
        typeMap.put("int4", Integer.class);        // INTEGER
        typeMap.put("integer", Integer.class);     // INTEGER
        typeMap.put("int8", Long.class);           // BIGINT
        typeMap.put("bigint", Long.class);         // BIGINT
        typeMap.put("serial", Integer.class);      // SERIAL
        typeMap.put("bigserial", Long.class);      // BIGSERIAL
        typeMap.put("numeric", BigDecimal.class);  // NUMERIC/DECIMAL
        typeMap.put("decimal", BigDecimal.class);
        typeMap.put("float4", Float.class);        // REAL
        typeMap.put("float8", Double.class);       // DOUBLE PRECISION

        // Boolean
        typeMap.put("bool", Boolean.class);

        // Character types
        typeMap.put("char", String.class);
        typeMap.put("varchar", String.class);
        typeMap.put("text", String.class);
        typeMap.put("character varying", String.class);

        // Date/Time types
        typeMap.put("date", LocalDate.class);
        typeMap.put("time", LocalTime.class);
        typeMap.put("timestamp", LocalDateTime.class);
        typeMap.put("timestamptz", LocalDateTime.class); // with timezone
        typeMap.put("timestamp without time zone", LocalDateTime.class); // without timezone

        // Binary
        typeMap.put("bytea", byte[].class);

        // UUID
        typeMap.put("uuid", UUID.class);

        // Money
        typeMap.put("money", BigDecimal.class);
    }

    public static Class<?> getJavaType(String postgresType) {
        return typeMap.getOrDefault(postgresType.toLowerCase(), String.class);
    }
}
