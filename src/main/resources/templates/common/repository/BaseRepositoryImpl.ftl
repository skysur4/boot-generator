package ${package}.common.repository;

import ${package}.common.util.SimpleObjectMapper;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.*;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.support.JpaEntityInformation;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
import jakarta.persistence.PersistenceException;

import java.io.Serializable;
import java.util.List;
import java.util.Optional;

public class BaseRepositoryImpl<T, ID extends Serializable> extends SimpleJpaRepository<T, ID> implements BaseRepository<T, ID> {
	private final EntityManager entityManager;
    private SimpleObjectMapper simpleObjectMapper = new SimpleObjectMapper();

	public BaseRepositoryImpl(JpaEntityInformation<T, ?> entityInformation, EntityManager entityManager) {
		super(entityInformation, entityManager);
		this.entityManager = entityManager;
	}

	@Override
	public <S extends T> S insert(S entity) throws PersistenceException {
		entityManager.persist(entity);
		return entity;
	}

	@Override
	public <S extends T> S update(S entity) throws PersistenceException {
		return entityManager.merge(entity);
	}

	@Override
	public <R> List<R> list(Sort sort,
							   Class<R> dtoClass) throws PersistenceException {
		return list(null, sort, dtoClass);
	}

	@Override
	public <R> List<R> list(Specification<T> spec,
							   Sort sort,
							   Class<R> dtoClass) throws PersistenceException {

		//List<T> list = findAll(spec, sort);
		//List<R> result = simpleObjectMapper.map(list, dtoClass);
        //
		//entityManager.clear();
        //
		//return result;

		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<R> query = cb.createQuery(dtoClass);
		Root<T> root = query.from(getDomainClass());

		Predicate predicate = null;
		if (spec != null) {
			predicate = spec.toPredicate(root, query, cb);
		}

		if (predicate != null) {
			query.where(predicate);
		}

		List<Order> orders = sort.stream().map(o -> {
			if (o.isAscending()) {
				return cb.asc(root.get(o.getProperty()));
			} else {
				return cb.desc(root.get(o.getProperty()));
			}
		}).toList();

		query.orderBy(orders);

		// ⚠️ You still need to define projection somewhere
		// This generic version only works if dtoClass == entity (rare)
		// Real use needs customization (see below)

		TypedQuery<R> typedQuery = entityManager.createQuery(query);

		return typedQuery.getResultList();
	}

	@Override
	public <R> Page<R> page(Pageable pageable,
							   Class<R> dtoClass) throws PersistenceException {
		return page(null, pageable, dtoClass);
	}

	@Override
	public <R> Page<R> page(Specification<T> spec,
							   Pageable pageable,
							   Class<R> dtoClass) throws PersistenceException {

		Page<T> list = findAll(spec, pageable);
		Page<R> result = simpleObjectMapper.map(list, dtoClass);

		entityManager.clear();

		return result;
	}

    @Override
    public <R> R retrieve(ID id, Class<R> dtoClass) throws PersistenceException {

		Optional<T> item = findById(id);
		R result = simpleObjectMapper.map(item.orElse(null), dtoClass);

		entityManager.clear();

		return result;
    }
}

/**
	public <R> List<R> list(Specification<T> spec,
							   Sort sort,
							   Class<R> dtoClass) throws PersistenceException {

		CriteriaBuilder cb = entityManager.getCriteriaBuilder();
		CriteriaQuery<R> query = cb.createQuery(dtoClass);
		Root<T> root = query.from(getDomainClass());

		Predicate predicate = null;
		if (spec != null) {
			predicate = spec.toPredicate(root, query, cb);
		}

		if (predicate != null) {
			query.where(predicate);
		}

		List<Order> orders = sort.stream().map(o -> {
			if (o.isAscending()) {
				return cb.asc(root.get(o.getProperty()));
			} else {
				return cb.desc(root.get(o.getProperty()));
			}
		}).toList();

		query.orderBy(orders);

		// ⚠️ You still need to define projection somewhere
		// This generic version only works if dtoClass == entity (rare)
		// Real use needs customization (see below)

		TypedQuery<R> typedQuery = entityManager.createQuery(query);

		return typedQuery.getResultList();
	}
**/