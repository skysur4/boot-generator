package ${package}.common.annotation;

import static java.lang.annotation.ElementType.FIELD;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;


import ${package}.common.enums.CompareOperator;
import jakarta.persistence.criteria.Predicate.BooleanOperator;

@Retention(RetentionPolicy.RUNTIME)
@Target(value = { FIELD })
public @interface Search {

	/**
	 * 조회 조건 연결자
	 * @return AND / OR
	 */
	BooleanOperator logic() default BooleanOperator.AND;

	/**
	 * 조회 조건 비교자
	 * @return eq / neq / like / gt / gte / lt / lte / in / jsonb_contains / from (date) / to (date)
	 */
    CompareOperator comparer() default CompareOperator.EQUAL;

    /**
     * 테이블 컬럼명 (필드명과 다를 시 사용)
     * @return String
     */
    String alias() default "";
}