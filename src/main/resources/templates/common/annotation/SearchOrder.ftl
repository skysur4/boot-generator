package ${package}.common.annotation;

import static java.lang.annotation.ElementType.FIELD;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import org.springframework.data.domain.Sort;

/**
 * 정렬 순서
 * 다른 필드의 순서와 겹칠 경우 최종 하나만 적용
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(value = { FIELD })
public @interface SearchOrder {

	/**
	 * 정렬 순서
	 * @return ASC / DESC
	 */
	Sort.Direction direction() default Sort.Direction.ASC;

	/**
	 * 정렬 적용 순서
	 * NOTE: 다른 필드의 순서와 겹칠 경우 하나만 적용될 수 있음
	 * @return int
	 */
	int order() default 0;

    /**
     * 테이블 컬럼명 (필드명과 다를 시 사용)
     * @return String
     */
    String alias() default "";
}