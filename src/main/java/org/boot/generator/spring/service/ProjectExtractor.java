package org.boot.generator.spring.service;

import com.google.common.collect.Lists;
import com.zaxxer.hikari.HikariConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.boot.generator.spring.converter.Db2JavaTypeConverter;
import org.boot.generator.spring.meta.*;
import org.boot.generator.spring.properties.ProjectProperties;
import org.postgresql.Driver;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.sql.*;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class ProjectExtractor {

    private final ProjectProperties projectProperties;

    public List<GenProject> extractProject() throws Exception {
        List<GenProject> projectList = Lists.newArrayList();

        /* 프로젝트 추출 */
        for(ProjectProperties.ProjectConfig projectConfig : projectProperties.getProject()){
            log.info("# Extracting project {}...", projectConfig.getName());

            GenProject.GenProjectBuilder project = GenProject.builder();
            project.name(projectConfig.getName())
                    .architecture(projectConfig.getPattern())
                    .dbFramework(projectConfig.getOrm());

            HikariConfig hikariConfig = projectConfig.getHikariConfig();

            /* 스키마 추출 */
            try (Connection conn = getConnection(hikariConfig)) {

                DatabaseMetaData metaData = conn.getMetaData();

                /** 일반적으로 스키마는 public 또는 다른 이름의 하나만 사용하도록 되어있지만, 확장성을 위해 추출은 멀티가 가능하도록 설정함
                 * TABLE_SCHEM String => schema name
                 * TABLE_CATALOG String => catalog name (may be null)
                 */
                List<GenSchema> schemaList = Lists.newArrayList();
                try (ResultSet schemas = metaData.getSchemas(null, projectConfig.getSchemaFilter())) {

                    while (schemas.next()) {
                        String schemaName = schemas.getString("TABLE_SCHEM");

                        GenSchema genSchema = new GenSchema(schemaName);

                        /** Get all tables
                         * TABLE_CAT String => table catalog (may be null)
                         * TABLE_SCHEM String => table schema (may be null)
                         * TABLE_NAME String => table name
                         * TABLE_TYPE String => table type. Typical types are "TABLE", "VIEW", "SYSTEM TABLE", "GLOBAL TEMPORARY", "LOCAL TEMPORARY", "ALIAS", "SYNONYM".
                         * REMARKS String => explanatory comment on the table (may be null)
                         * TYPE_CAT String => the types catalog (may be null)
                         * TYPE_SCHEM String => the types schema (may be null)
                         * TYPE_NAME String => type name (may be null)
                         * SELF_REFERENCING_COL_NAME String => name of the designated "identifier" column of a typed table (may be null)
                         * REF_GENERATION String => specifies how values in SELF_REFERENCING_COL_NAME are created. Values are "SYSTEM", "USER", "DERIVED". (may be null)
                         */
                        try (ResultSet tables = metaData.getTables(null, schemaName, projectConfig.getTableFilter(), new String[]{"TABLE"})) {

                            while (tables.next()) {
                                String tableName = tables.getString("TABLE_NAME");
                                List<GenColumn> columnList = Lists.newArrayList();
                                List<GenPrimaryKey> primaryKeyList = Lists.newArrayList();
                                List<GenForeignKey> foreignKeyList = Lists.newArrayList();
                                List<GenIndex> indexList = Lists.newArrayList();

                                GenTable.GenTableBuilder table = GenTable.builder();
                                table.name(tables.getString("TABLE_NAME"))
                                        .remarks(tables.getString("REMARKS"));

                                /** Get columns
                                 * TABLE_NAME String => table name
                                 * COLUMN_NAME String => column name
                                 * DATA_TYPE int => SQL type from java.sql.Types
                                 * TYPE_NAME String => Data source dependent type name, for a UDT the type name is fully qualified
                                 * COLUMN_SIZE int => column size.
                                 * DECIMAL_DIGITS int => the number of fractional digits. Null is returned for data types where DECIMAL_DIGITS is not applicable.
                                 * NUM_PREC_RADIX int => Radix (typically either 10 or 2)
                                 * REMARKS String => comment describing column (may be null)
                                 * COLUMN_DEF String => default value for the column, which should be interpreted as a string when the value is enclosed in single quotes (may be null)
                                 * ORDINAL_POSITION int => index of column in table (starting at 1)
                                 * NULLABLE int => is NULL allowed.
                                 * IS_NULLABLE String => ISO rules are used to determine the nullability for a column.
                                 * YES --- if the column can include NULLs
                                 * NO --- if the column cannot include NULLs
                                 * IS_AUTOINCREMENT String => Indicates whether this column is auto incremented
                                 * YES --- if the column is auto incremented
                                 * NO --- if the column is not auto incremented
                                 */
                                try (ResultSet columns = metaData.getColumns(null, schemaName, tableName, projectConfig.getColumnFilter())) {
                                    while (columns.next()) {
                                        GenColumn.GenColumnBuilder column = GenColumn.builder();

                                        column.table(columns.getString("TABLE_NAME"))
                                                .name(columns.getString("COLUMN_NAME"))
                                                .type(columns.getString("TYPE_NAME"))
                                                .javaType(Db2JavaTypeConverter.getJavaType(columns.getString("TYPE_NAME")))
                                                .size(columns.getInt("COLUMN_SIZE"))
                                                .digit(columns.getInt("DECIMAL_DIGITS"))
                                                .radix(columns.getInt("NUM_PREC_RADIX"))
                                                .nullable(columns.getBoolean("NULLABLE"))   //columns.getInt("NULLABLE") == DatabaseMetaData.columnNullable
                                                .autoincrement(columns.getString("IS_AUTOINCREMENT"))
                                                .defaultValue(columns.getString("COLUMN_DEF"))
                                                .remarks(columns.getString("REMARKS"))
                                                .seq(columns.getInt("ORDINAL_POSITION"));

                                        columnList.add(column.build());
                                    }
                                }
                                table.columns(columnList);

                                /** Get pk
                                 * TABLE_NAME String => table name
                                 * COLUMN_NAME String => column name
                                 * KEY_SEQ short => sequence number within primary key( a value of 1 represents the first column of the primary key, a value of 2 would represent the second column within the primary key).
                                 * PK_NAME String => primary key name (may be null)
                                 */
                                try (ResultSet primaryKeys = metaData.getPrimaryKeys(null, schemaName, tableName)) {
                                    while (primaryKeys.next()) {
                                        GenPrimaryKey.GenPrimaryKeyBuilder primaryKey = GenPrimaryKey.builder();

                                        primaryKey.table(primaryKeys.getString("TABLE_NAME"))
                                                .name(primaryKeys.getString("PK_NAME"))
                                                .column(primaryKeys.getString("COLUMN_NAME"))
                                                .seq(primaryKeys.getShort("KEY_SEQ"));

                                        primaryKeyList.add(primaryKey.build());
                                    }
                                }
                                table.primaryKeys(primaryKeyList);

                                /** Get fk
                                 Retrieves a description of the primary key columns that are referenced by the given table's foreign key columns (the primary keys imported by a table). They are ordered by PKTABLE_CAT, PKTABLE_SCHEM, PKTABLE_NAME, and KEY_SEQ.
                                 Each primary key column description has the following columns:
                                 PKTABLE_NAME String => primary key table name being imported
                                 PKCOLUMN_NAME String => primary key column name being imported
                                 FKTABLE_NAME String => foreign key table name
                                 FKCOLUMN_NAME String => foreign key column name
                                 KEY_SEQ short => sequence number within a foreign key( a value of 1 represents the first column of the foreign key, a value of 2 would represent the second column within the foreign key).
                                 **/
                                try (ResultSet importedKeys = metaData.getImportedKeys(null, schemaName, tableName)) {
                                    while (importedKeys.next()) {
                                        GenForeignKey.GenForeignKeyBuilder foreignKey = GenForeignKey.builder();

                                        foreignKey.table(importedKeys.getString("FKTABLE_NAME"))
                                                .column(importedKeys.getString("FKCOLUMN_NAME"))
                                                .refTable(importedKeys.getString("PKTABLE_NAME"))
                                                .refColumn(importedKeys.getString("PKCOLUMN_NAME"))
                                                .seq(importedKeys.getShort("KEY_SEQ"));

                                        foreignKeyList.add(foreignKey.build());
                                    }
                                }
                                table.foreignKeys(foreignKeyList);

                                /** get indices
                                 * TABLE_NAME String => table name
                                 * NON_UNIQUE boolean => Can index values be non-unique. false when TYPE is tableIndexStatistic
                                 * INDEX_NAME String => index name; null when TYPE is tableIndexStatistic
                                 * ORDINAL_POSITION short => column sequence number within index; zero when TYPE is tableIndexStatistic
                                 * COLUMN_NAME String => column name; null when TYPE is tableIndexStatistic
                                 */
                                try (ResultSet indicesInfo = metaData.getIndexInfo(null, schemaName, tableName, false, false)) {
                                    while (indicesInfo.next()) {
                                        GenIndex.GenIndexBuilder index = GenIndex.builder();

                                        index.table(indicesInfo.getString("TABLE_NAME"))
                                                .name(indicesInfo.getString("INDEX_NAME"))
                                                .column(indicesInfo.getString("COLUMN_NAME"))
                                                .unique(!indicesInfo.getBoolean("NON_UNIQUE"))
                                                .seq(indicesInfo.getShort("ORDINAL_POSITION"));

                                        indexList.add(index.build());
                                    }
                                }
                                table.indices(indexList);

                                genSchema.addTable(table.build());

                            }// tables.next()
                        }

                        schemaList.add(genSchema);

                    }// schemas.next()
                }

                project.schemas(schemaList);

            }// hikariConfig

            projectList.add(project.build());

        }// projectConfig

        return projectList;
    }

    public Connection getConnection(HikariConfig config) throws SQLException {
        // HikariConfig를 생성자에 전달하여 DataSource를 초기화합니다.
        return DriverManager.getConnection(config.getJdbcUrl(), config.getUsername(), config.getPassword());
    }
}
