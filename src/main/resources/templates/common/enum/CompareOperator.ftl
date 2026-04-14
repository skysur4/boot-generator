package ${package}.common.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CompareOperator {
    EQUAL("eq")
	, NOT_EQUAL("neq")
	, LIKE("like")
	, GREATER("gt")
	, GREATER_EQUAL("gte")
	, LESSER("lt")
	, LESSER_EQUAL("lte")
	, IN("in")
	, JSONB_CONTAINS("jsonb_contains")
	, FROM("from")
	, TO("to")
    ;

	private String code;

    public static CompareOperator fromValue(String value) {
    	//CriteriaBuilder
        return CompareOperator.valueOf(value);
    }
}