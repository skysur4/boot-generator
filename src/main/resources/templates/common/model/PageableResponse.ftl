package ${package}.common.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.springframework.data.domain.Page;
import ${package}.common.util.SimpleObjectMapper;

import java.util.List;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class PageableResponse<T> {
    // ---------- getter / setter ----------
    private List<T> content;
	private long totalElements;
	private int totalPages;
	private int currentPage;
	private int pageSize;
	private boolean last;
	private boolean first;

	// ---------- 변환 메서드 ----------
	public static <E, D> PageableResponse<D> from(Page<E> page, Class<D> clazz) {
	    SimpleObjectMapper converter = new SimpleObjectMapper();
		List<D> domains = converter.map(page, clazz).getContent();

		return new PageableResponse<D>(
				domains,
				page.getTotalElements(),
				page.getTotalPages(),
				page.getNumber() + 1,
				page.getSize(),
				page.isLast(),
				page.isFirst()
		);
	}

	// ---------- 변환 메서드 ----------
	public static <E, D> PageableResponse<D> from(List<E> list, Class<D> clazz) {
	    SimpleObjectMapper converter = new SimpleObjectMapper();
        List<D> domains = converter.map(list, clazz);

		return new PageableResponse<D>(
				domains,
				list.size(),
				0,
				0,
				0,
				false,
				false
		);
	}

	// ---------- 변환 메서드 ----------
	public static <E, D> D from(E item, Class<D> clazz) {
		SimpleObjectMapper converter = new SimpleObjectMapper();
		return converter.map(item, clazz);
	}

}