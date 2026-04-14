package ${package}.common.util;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.data.domain.Page;
import lombok.extern.slf4j.Slf4j;

import java.util.List;

@Slf4j
public class SimpleObjectMapper extends ObjectMapper {
	private final ObjectMapper objectMapper;

	public SimpleObjectMapper() {
		ObjectMapper objectMapper = new ObjectMapper();

        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
		objectMapper.disable(SerializationFeature.FAIL_ON_EMPTY_BEANS);
		objectMapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		objectMapper.configure(DeserializationFeature.FAIL_ON_NULL_FOR_PRIMITIVES, false);
		objectMapper.configure(DeserializationFeature.FAIL_ON_INVALID_SUBTYPE, false);
		objectMapper.configure(DeserializationFeature.FAIL_ON_SUBTYPE_CLASS_NOT_REGISTERED, false);

		this.objectMapper = objectMapper;
	}

	public <E, D> D map(E item, Class<D> clazz) {
	    return this.objectMapper.convertValue(item, clazz);
	}

	public <E, D> Page<D> map(Page<E> page, Class<D> clazz) {
		return page.map(item -> this.objectMapper.convertValue(item, clazz));
	}

	public <E, D> List<D> map(List<E> list, Class<D> clazz) {
		return list.stream().map(item -> this.objectMapper.convertValue(item, clazz)).toList();
	}

}