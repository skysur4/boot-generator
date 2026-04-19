package ${package}.common.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.NoRepositoryBean;
import jakarta.persistence.PersistenceException;

import java.io.Serializable;
import java.util.List;

@NoRepositoryBean
public interface BaseRepository<T, ID extends Serializable> extends JpaRepository<T, ID>, JpaSpecificationExecutor<T> {
	<S extends T> S insert(S entity) throws PersistenceException;
	<S extends T> S update(S entity) throws PersistenceException;

	<R> List<R> list(Sort sort,
						Class<R> dtoClass) throws PersistenceException;

	<R> List<R> list(Specification<T> spec,
						Sort sort,
						Class<R> dtoClass) throws PersistenceException;

	<R> Page<R> page(Pageable pageable,
						Class<R> dtoClass) throws PersistenceException;

	<R> Page<R> page(Specification<T> spec,
						Pageable pageable,
						Class<R> dtoClass) throws PersistenceException;

    <R> R retrieve(ID id, Class<R> dtoClass) throws PersistenceException;
}