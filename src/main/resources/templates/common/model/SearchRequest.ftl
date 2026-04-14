package ${package}.common.model;

import ${package}.AppConstants;
import ${package}.common.annotation.Search;
import ${package}.common.annotation.SearchOrder;
import ${package}.common.enums.CompareOperator;
import ${package}.common.util.SimpleObjectMapper;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.criteria.Expression;
import jakarta.persistence.criteria.Predicate.BooleanOperator;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Order;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.util.ObjectUtils;
import org.springframework.util.StringUtils;

import java.io.Serializable;
import java.lang.reflect.Field;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.TreeMap;
import java.util.stream.Collectors;

/**
 * Search Data Object
 * JPA 검색 조건 자동화
 * see @Search
 */
@Slf4j
public abstract class SearchRequest implements Serializable {
	private static final Sort DEFAULT_SORT = Sort.by(Sort.Direction.DESC, "updatedAt");
	private static final String DEFAULT_SORT_STRING = "updatedAt:desc";

	@Getter
	@Schema(name = "pageNumber", description = "페이지번호")
	private final int pageNumber;

	@Getter
	@Schema(name = "pageSize", description = "목록갯수")
	private final int pageSize;

    @Getter
	@Schema(name = "orders", description = "정렬", example = "updatedAt:desc")
	private final String orders;

	@Schema(description = "페이징")
	private final Pageable pageable;

	public SearchRequest(int number, int size, String orders) {
		this.pageNumber = number < 1 ? AppConstants.DEFAULT_PAGE_NUMBER : number;
		this.pageSize = size < 1 ? AppConstants.DEFAULT_PAGE_SIZE : size;
        this.orders = orders;

		// 정렬
        Sort sort;
        if(StringUtils.hasText(this.orders)) {
			// frontend Orders
			sort = parseSort();
		} else {
			// parse @SearchOrder
			sort = buildSort();
		}

		// 페이징
		if (this.pageSize > 0) {
			// JPA 계산식에 따른 페이지 수정
			pageable = PageRequest.of(this.pageNumber - 1, this.pageSize, sort);
		} else {
			pageable = Pageable.unpaged(sort);
		}
	}

	// 전체 스펙 생성
	public <T> Specification<T> specification() {
		// 비어있는 Spec 생성
		// Specification<T> specification = Specification.unrestricted(); method를 찾을 수 없다 함. 버전 문제라고 하는데, 일단 넘어감
		Specification<T> specification = (root, query, cb) -> cb.conjunction();

		// 1. Search 스캔
		for (Field field : this.getClass().getDeclaredFields()) {
			if (!field.isAnnotationPresent(Search.class)) continue;

			Search search = field.getAnnotation(Search.class);
			Object value = getFieldValue(field);

			if (ObjectUtils.isEmpty(value)) continue;          // 값이 없으면 건너뛰기

			// 2. 필드 이름을 엔티티 속성으로 변환 (필요 시 별칭 사용)
			String propertyName = field.getName();

			// 2-1. alias가 존재할 경우 사용
			if (StringUtils.hasText(search.alias())) {
				propertyName = search.alias();
			}

			// 3. Comparer 로 Specification 생성
			Specification<T> spec = buildSpec(propertyName, search.comparer(), value);

			// 4. Specification 추가
			specification = BooleanOperator.AND.equals(search.logic()) ? specification.and(spec) : specification.or(spec);
		}

		return specification;
	}

	// 페이징 정보 생성
	public Pageable pageable() {
		return this.pageable;
	}

	// 도메인 정렬 추출
	private Sort buildSort() {
		List<Order> orderList = Lists.newArrayList();
		TreeMap<Integer, Order> orderMap = Maps.newTreeMap();

		// 1. Search 스캔
		for (Field field : this.getClass().getDeclaredFields()) {
			if (!field.isAnnotationPresent(SearchOrder.class)) continue;

			SearchOrder searchOrder = field.getAnnotation(SearchOrder.class);

			// 1. 필드 이름을 엔티티 속성으로 변환 (필요 시 별칭 사용)
			String propertyName = field.getName();

			// 1-1. alias가 존재할 경우 사용
			if (!ObjectUtils.isEmpty(searchOrder.alias())) {
				propertyName = searchOrder.alias();
			}

			if (Sort.Direction.ASC.equals(searchOrder.direction())) {
				orderMap.put(searchOrder.order(), Order.asc(propertyName));
			} else {
				orderMap.put(searchOrder.order(), Order.desc(propertyName));
			}
		}

		// 2. Search 정리
		if(ObjectUtils.isEmpty(orderMap)){
			orderList.addAll(DEFAULT_SORT.toList());
		} else {
			orderList.addAll(orderMap.values());
		}

		return Sort.by(orderList);
	}

	// frontend 정렬 변환
	private Sort parseSort() {
		List<Order> orderList = Lists.newArrayList();

		// Split by comma to get "updatedAt:desc"
		String[] pairs = this.orders.split(",");
		for (String pair : pairs) {
			String[] split = pair.split(":");
			String property = split[0];
			// Determine direction
			Sort.Direction direction = (split.length > 1 && split[1].equalsIgnoreCase("desc"))
					? Sort.Direction.DESC
					: Sort.Direction.ASC;

			orderList.add(new Order(direction, property));
		}
		return Sort.by(orderList);
	}

	// 필드값 추출
	private Object getFieldValue(Field field) {
		try {
			field.setAccessible(true);
			return field.get(this);
		} catch (IllegalAccessException e) {
			throw new RuntimeException(e); // 예외 처리는 필요에 따라 조정
		}
	}

	// 단일 스펙 추출
	private <T> Specification<T> buildSpec(String key, CompareOperator operand, Object value) {
		ObjectMapper objectMapper = new SimpleObjectMapper();

		return (root, query, cb) -> {

			if (CompareOperator.EQUAL.equals(operand)) {
				return cb.equal(root.get(key), value);
			} else if (CompareOperator.NOT_EQUAL.equals(operand)) {
				return cb.notEqual(root.get(key), value);
			} else if (CompareOperator.GREATER.equals(operand)) {
				if (value instanceof Integer) {
					return cb.greaterThan(root.get(key), (Integer) value);

				} else if (value instanceof Long) {
					return cb.greaterThan(root.get(key), (Long) value);

				} else if (value instanceof Float) {
					return cb.greaterThan(root.get(key), (Float) value);

				} else if (value instanceof Double) {
					return cb.greaterThan(root.get(key), (Double) value);

				}
				throw new IllegalAccessError("Unsupported value type!");
			} else if (CompareOperator.LESSER.equals(operand)) {
				if (value instanceof Integer) {
					return cb.lessThan(root.get(key), (Integer) value);

				} else if (value instanceof Long) {
					return cb.lessThan(root.get(key), (Long) value);

				} else if (value instanceof Float) {
					return cb.lessThan(root.get(key), (Float) value);

				} else if (value instanceof Double) {
					return cb.lessThan(root.get(key), (Double) value);

				}
				throw new IllegalAccessError("Unsupported value type!");
			} else if (CompareOperator.GREATER_EQUAL.equals(operand)) {
				if (value instanceof Integer) {
					return cb.greaterThanOrEqualTo(root.get(key), (Integer) value);

				} else if (value instanceof Long) {
					return cb.greaterThanOrEqualTo(root.get(key), (Long) value);

				} else if (value instanceof Float) {
					return cb.greaterThanOrEqualTo(root.get(key), (Float) value);

				} else if (value instanceof Double) {
					return cb.greaterThanOrEqualTo(root.get(key), (Double) value);

				}
				throw new IllegalAccessError("Unsupported value type!");
			} else if (CompareOperator.LESSER_EQUAL.equals(operand)) {
				if (value instanceof Integer) {
					return cb.lessThanOrEqualTo(root.get(key), (Integer) value);

				} else if (value instanceof Long) {
					return cb.lessThanOrEqualTo(root.get(key), (Long) value);

				} else if (value instanceof Float) {
					return cb.lessThanOrEqualTo(root.get(key), (Float) value);

				} else if (value instanceof Double) {
					return cb.lessThanOrEqualTo(root.get(key), (Double) value);

				}
				throw new IllegalAccessError("Unsupported value type!");

			} else if (CompareOperator.LIKE.equals(operand)) {
				return cb.like(root.get(key), "%" + value + "%");

			} else if (CompareOperator.IN.equals(operand)) {
				return root.get(key).in((Collection<?>) value);

			} else if (CompareOperator.JSONB_CONTAINS.equals(operand)) {

				String jsonArray = "";

				// 배열인 경우
				if (value instanceof Collection<?> list) {

					/* 1. 파라미터를 JSON 배열 문자열로 변환 */

                    // enum 타입 배열일 경우
					if (list.stream().findFirst().getClass().isEnum()) {
						jsonArray = list.stream()
								.map(item -> "\"" + ((Enum<?>) item).name() + "\"")
								.collect(Collectors.joining(", ", "[", "]"));

						// enum 외 타입
					} else {
						try {
							jsonArray = objectMapper.writeValueAsString(list);
						} catch (JsonProcessingException e) {
							log.error("Error converting parameter value for JSONB column: {}", key);
						}
					}

				} else {
					/* 1. 파라미터를 JSON 배열 문자열로 변환 */
					if (value instanceof String) {
						jsonArray = "[\"" + value + "\"]";
					} else {
						jsonArray = "[" + value + "]";
					}
				}

				/* 2. jsonb_contains 함수 호출 */
				Expression<Boolean> jsonbContains = cb.function(
						"jsonb_contains",
						Boolean.class,
						root.get(key),
						cb.literal(jsonArray)
				);


				return cb.isTrue(jsonbContains);
			} else if (CompareOperator.FROM.equals(operand)) {
				if (value instanceof LocalDateTime) {
					return cb.greaterThanOrEqualTo(root.get(key), (LocalDateTime) value);

				} else if (value instanceof LocalDate) {
					return cb.greaterThanOrEqualTo(root.get(key), (LocalDate) value);

				}
				throw new IllegalAccessError("Unsupported value type!");
			} else if (CompareOperator.TO.equals(operand)) {
				if (value instanceof LocalDateTime) {
					return cb.lessThanOrEqualTo(root.get(key), (LocalDateTime) value);

				} else if (value instanceof LocalDate) {
					return cb.lessThanOrEqualTo(root.get(key), (LocalDate) value);

				}
				throw new IllegalAccessError("Unsupported value type!");
			}

			throw new IllegalAccessError("Unparsable predicator!");
		};
	}
}