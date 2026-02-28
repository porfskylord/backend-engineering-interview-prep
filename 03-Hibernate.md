# HIBERNATE

## Hibernate Basics

**#. What is Hibernate and why do we use it?**

Hibernate is an Object-Relational Mapping (ORM) framework for Java. It maps Java objects to database tables and vice versa, eliminating the need to write tedious JDBC code. The main benefits are that you work with objects instead of SQL queries, it handles database portability - you can switch databases with minimal code changes, it provides caching mechanisms for performance, manages relationships between objects automatically, and handles lazy loading. Hibernate implements the JPA specification, so it's the standard ORM solution for Java. It significantly reduces boilerplate code and lets developers focus on business logic rather than database plumbing.

**#. What's the difference between Hibernate and JPA?**

JPA (Java Persistence API) is a specification - it's just interfaces and annotations that define how ORM should work in Java. Hibernate is an implementation of JPA - it's an actual framework that provides the functionality. Other JPA implementations include EclipseLink and OpenJPA. When you use JPA annotations like @Entity, @Id, you're using the standard. When you use Hibernate-specific features like @Formula or Criteria API beyond JPA, you're tightly coupled to Hibernate. Best practice is to stick to JPA interfaces and annotations as much as possible for portability, and use Hibernate-specific features only when necessary.

**#. Explain the Hibernate architecture.**

Hibernate architecture has several key components. At the top is the SessionFactory - a thread-safe, heavyweight object created once per database. It creates Session objects. Session is the main interface for persistence operations - it's a single-threaded, short-lived object representing one unit of work. Transaction manages database transactions. Query and Criteria are used for querying. The Configuration object is used to configure Hibernate and create SessionFactory. Behind the scenes, Hibernate uses JDBC to interact with the database, Connection Pool for managing connections, and Transaction Manager for handling transactions. Understanding this helps in proper resource management and troubleshooting.

**#. What is SessionFactory and Session?**

SessionFactory is an immutable, thread-safe factory for creating Session objects. It's heavyweight - creating it is expensive, so you create one per database and reuse it throughout the application. It holds configuration information, mapping metadata, and connection pool. Session represents a single unit of work with the database. It's lightweight, not thread-safe, and should be created for each transaction and then closed. All CRUD operations go through Session - save, update, delete, get, load, etc. Think of SessionFactory as a factory and Session as a single conversation with the database. Always close Session after use.

**#. Explain the difference between Session.get() and Session.load().**

Both retrieve an object by ID, but they differ in behavior. get() hits the database immediately and returns the actual object or null if not found. load() returns a proxy object without hitting the database immediately - it uses lazy loading. The database is hit only when you access properties of the object. If the object doesn't exist, get() returns null, but load() throws ObjectNotFoundException when you try to access the proxy. Use get() when you're not sure the object exists and you need to check for null. Use load() when you're sure the object exists and want to benefit from lazy loading.

**#. What are the different states of a Hibernate entity?**

Hibernate entities have three states. **Transient** - the object is created with 'new' but not associated with any Session or database row. It has no database representation. **Persistent** - the object is associated with a Session and has a database row. Any changes to the object are automatically synchronized with the database when the Session is flushed. You get persistent objects from get(), load(), or by calling save() or persist() on transient objects. **Detached** - the object was persistent but the Session is closed. It still has a database representation, but changes aren't automatically synchronized. You can reattach it with merge() or update(). Understanding states is crucial for managing entities correctly.

**#. Explain the difference between save(), persist(), and merge().**

save() inserts a new row and returns the generated identifier. It can be called on transient objects and returns the ID immediately. persist() also inserts but doesn't return the ID - it's void. It's from JPA specification. The difference is subtle - persist() guarantees the object is persistent within the transaction but may not execute INSERT immediately. save() executes INSERT and returns ID. merge() is for detached objects - it copies the state to a persistent object and returns that persistent object. The original detached object remains detached. Use save/persist for new objects, merge for detached objects you want to update.

**#. What is the difference between update() and merge()?**

update() reattaches a detached object to the Session. If an object with the same ID already exists in the Session, it throws an exception. It assumes the object is detached and tries to update the database row. merge() is smarter - it checks if the object exists in the Session. If yes, it copies the state to the existing persistent object. If no, it loads from database and updates. merge() returns the persistent object, while update() is void. update() is faster but riskier - use it when you're sure the object is detached and not in Session. merge() is safer but slower - it always checks and may load from database.

**#. Explain Hibernate caching.**

Hibernate has two levels of caching. **First-level cache** is at Session level - it's enabled by default and mandatory. All objects loaded in a Session are cached there. When you get the same object twice in a Session, the second call doesn't hit the database. The cache is cleared when Session is closed. **Second-level cache** is at SessionFactory level - it's optional and shared across Sessions. It caches entities, collections, and query results across the application. Providers include EhCache, Infinispan, Hazelcast. Configure which entities are cacheable with @Cache annotation. Second-level cache significantly improves performance by reducing database hits, but adds complexity with cache invalidation.

**#. What is lazy loading and eager loading?**

Lazy loading means associated objects are not loaded from the database until you explicitly access them. Eager loading means they're loaded immediately with the parent object. For example, with @OneToMany(fetch = FetchType.LAZY), the collection isn't loaded until you call a method on it. With FetchType.EAGER, it's loaded with the parent. Lazy loading improves performance by loading only what's needed, but can cause LazyInitializationException if you access lazy associations after Session is closed. Eager loading can cause performance problems by loading too much data. Default is LAZY for collections, EAGER for single associations. Generally prefer LAZY and use JOIN FETCH in queries when needed.

**#. What is the N+1 query problem in Hibernate?**

The N+1 problem happens with lazy loading. You query for N parent entities, then when you access a lazy collection on each, Hibernate fires one query per parent - resulting in N+1 queries total. For example, loading 100 departments and then accessing each department's employees causes 101 queries - one for departments and 100 for employees. Solutions include using JOIN FETCH in HQL/JPQL to load associations in one query, using @BatchSize to fetch multiple associations in one query, using @Fetch(FetchMode.SUBSELECT) to fetch all in a subquery, or switching to EAGER fetch (though this has its own issues). JOIN FETCH is usually the best solution.

**#. Explain HQL (Hibernate Query Language).**

HQL is an object-oriented query language similar to SQL but works with entities and properties instead of tables and columns. For example, "FROM User WHERE age > 18" instead of "SELECT * FROM users WHERE age > 18". HQL is database-independent - Hibernate translates it to the appropriate SQL dialect. It supports joins, aggregations, subqueries, and most SQL features. You can use named parameters (:name) or positional parameters (?1). HQL returns objects, not result sets. It's the recommended way to query in Hibernate. For complex queries, you might use Criteria API or native SQL, but HQL covers most use cases and maintains database independence.

**#. What is Criteria API?**

Criteria API is a programmatic, type-safe way to build queries. Instead of writing string queries, you build queries using Java objects and methods. For example: CriteriaBuilder cb = session.getCriteriaBuilder(); CriteriaQuery<User> query = cb.createQuery(User.class); Root<User> root = query.from(User.class); query.select(root).where(cb.equal(root.get("email"), email)). Benefits include compile-time checking, IDE support with auto-completion, dynamic query building, and no string concatenation. It's more verbose than HQL but safer for dynamic queries. JPA provides a standard Criteria API, while Hibernate has its own legacy Criteria API (now deprecated). Use JPA Criteria for new code.

**#. What is the difference between HQL and native SQL?**

HQL works with entities and properties, while native SQL works with tables and columns. HQL is database-independent - Hibernate translates it to the specific database dialect. Native SQL is database-specific. HQL returns objects, native SQL returns arrays or maps (though you can map to objects). Use HQL when possible for portability and object-oriented approach. Use native SQL for complex queries, database-specific features like stored procedures or window functions, or performance optimization with database-specific syntax. You execute native SQL with session.createNativeQuery(). Always prefer HQL/JPQL unless you specifically need native SQL features.

**#. Explain dirty checking in Hibernate.**

Dirty checking is Hibernate's automatic detection of changes to persistent objects. When you load an object and modify it, you don't need to explicitly call update(). Hibernate automatically tracks changes and updates the database when the Session is flushed or committed. It maintains a snapshot of the original state and compares current state to the snapshot. Only changed fields are updated. This is powerful and convenient but has performance implications - Hibernate checks all persistent objects during flush. You can optimize by making entities immutable with @Immutable when they don't change, or by managing flush manually. Understanding dirty checking helps avoid unexpected updates.

## Hibernate Mappings & Relationships

**#. How do you map a class to a database table in Hibernate?**

You use @Entity annotation on the class to mark it as a Hibernate entity. By default, the table name is the class name, but you can customize it with @Table(name="custom_table_name"). Each entity needs a primary key marked with @Id. Fields automatically map to columns with the same name, but you can customize with @Column(name="custom_column"). For example: @Entity @Table(name="users") public class User { @Id @GeneratedValue private Long id; @Column(name="email_address") private String email; }. You can also specify schema, uniqueConstraints, and indexes in @Table. This declarative mapping is cleaner than XML configuration.

**#. Explain @Column annotation and its attributes.**

@Column provides fine-grained control over column mapping. Key attributes include name for custom column name, nullable for allowing nulls (default true), unique for unique constraint, length for string length (default 255), precision and scale for decimals, insertable and updatable to control whether the column is included in INSERT/UPDATE statements, and columnDefinition for custom SQL type. For example: @Column(name="email", nullable=false, unique=true, length=100). You can also specify table if mapping to a different table. These attributes help ensure proper database schema and validation. Not specifying @Column means using default behavior, which is often fine.

**#. What are the different types of associations in Hibernate?**

Hibernate supports four association types. **@OneToOne** - one entity is associated with exactly one other entity, like User and UserProfile. **@OneToMany** - one entity is associated with many others, like Department has many Employees. **@ManyToOne** - the inverse of OneToMany, many entities associate with one. **@ManyToMany** - entities on both sides can associate with multiple entities on the other side, like Students and Courses. Each can be unidirectional (one side knows about the relationship) or bidirectional (both sides know). The owning side determines which table has the foreign key. Understanding relationships is crucial for proper entity design and query optimization.

**#. How do you implement @OneToOne relationship?**

There are two approaches. First, unidirectional: @OneToOne @JoinColumn(name="profile_id") private UserProfile profile. The User table has profile_id foreign key. Second, bidirectional: User has @OneToOne(mappedBy="user") private UserProfile profile, and UserProfile has @OneToOne @JoinColumn(name="user_id") private User user. The mappedBy indicates UserProfile is the owning side. You can also use shared primary key where both entities have the same ID: @OneToOne @MapsId private User user. Choose based on whether you need bidirectional navigation. Remember, @OneToOne with EAGER fetch can cause performance issues - consider LAZY.

**#. Explain @OneToMany and @ManyToOne relationship.**

@OneToMany represents a collection on one side and @ManyToOne on the other. For example, Department has many Employees. In Department: @OneToMany(mappedBy="department") private List<Employee> employees. In Employee: @ManyToOne @JoinColumn(name="department_id") private Department department. The @ManyToOne side is the owner - Employee table has department_id foreign key. mappedBy on @OneToMany indicates it's the inverse side. Always use @ManyToOne side for queries and updates as it's more efficient. OneToMany with EAGER loading can cause performance issues. Use fetch = FetchType.LAZY and load with JOIN FETCH when needed.

**#. How do you implement @ManyToMany relationship?**

@ManyToMany requires a join table with foreign keys to both entities. For example, Student and Course. In Student: @ManyToMany @JoinTable(name="student_course", joinColumns=@JoinColumn(name="student_id"), inverseJoinColumns=@JoinColumn(name="course_id")) private Set<Course> courses. In Course: @ManyToMany(mappedBy="courses") private Set<Student> students. The join table student_course has student_id and course_id. Use Set instead of List to avoid duplicate entries. For bidirectional, one side uses mappedBy. If you need additional attributes in the join table (like enrollment date), you must create a separate entity for the join table with @ManyToOne relationships to both sides.

**#. What is cascading and what are cascade types?**

Cascading propagates operations from parent to child entities. Cascade types include PERSIST (save parent saves children), MERGE (merge parent merges children), REMOVE (delete parent deletes children), REFRESH (reload parent reloads children), DETACH (detach parent detaches children), and ALL (all of above). Specify with cascade attribute: @OneToMany(cascade = CascadeType.ALL). Use cascading carefully, especially REMOVE - deleting a Department shouldn't delete Employees in most cases. Common usage is CASCADE.PERSIST and CASCADE.MERGE for composition relationships where the child doesn't exist independently. For example, Order and OrderItems - deleting Order should delete OrderItems, so use CASCADE.ALL.

**#. Explain orphan removal.**

Orphan removal automatically deletes child entities when they're removed from the parent's collection. Set with orphanRemoval=true: @OneToMany(orphanRemoval=true). When you remove an item from the collection and commit, Hibernate deletes that child from database. For example, if you remove an OrderItem from Order's items collection, the OrderItem is deleted from database. It's different from CASCADE.REMOVE - orphan removal deletes children when removed from collection, CASCADE.REMOVE deletes children when parent is deleted. Use orphan removal for strong composition where children don't exist independently. Combine with CASCADE.ALL for full lifecycle management.

**#. What is @JoinColumn and @JoinTable?**

@JoinColumn specifies the foreign key column for @ManyToOne, @OneToOne, or the owning side of @OneToMany. Attributes include name for column name, referencedColumnName for the referenced column (usually primary key), nullable, unique, and others. For example: @ManyToOne @JoinColumn(name="department_id", nullable=false). @JoinTable specifies the join table for @ManyToMany relationships. Attributes include name for table name, joinColumns for foreign keys to owning side, and inverseJoinColumns for foreign keys to inverse side. For example: @JoinTable(name="student_course", joinColumns=@JoinColumn(name="student_id"), inverseJoinColumns=@JoinColumn(name="course_id")). These give precise control over table structure.

**#. Explain fetch strategies - SELECT, JOIN, SUBSELECT, BATCH.**

These are Hibernate-specific fetch strategies. SELECT (default) fires a separate SELECT for each association - can cause N+1 problem. JOIN fetches associations with an outer join in the initial query - efficient but can load unnecessary data. SUBSELECT fetches associations with a SUBSELECT for all instances at once - efficient for collections. BATCH fetches associations in batches - instead of N queries, fires N/batch_size queries. Specify with @Fetch annotation: @Fetch(FetchMode.JOIN) or @BatchSize(size=10). JOIN is efficient for single object queries. SUBSELECT and BATCH are efficient when loading multiple parent objects. Choose based on access patterns and data size.

**#. What is @Embeddable and @Embedded?**

@Embeddable marks a class whose instances are stored as part of an owning entity, not as a separate table. For example, Address class with street, city, zipCode. @Embedded in the owning entity includes the embeddable class: @Embedded private Address address. The User table will have columns like street, city, zipCode. You can customize column names with @AttributeOverrides. For example: @Embedded @AttributeOverrides({@AttributeOverride(name="street", column=@Column(name="home_street"))}) private Address homeAddress. Embeddable is useful for grouping related fields that don't need their own table. It promotes reusability and object-oriented design without relationship overhead.

**#. Explain @ElementCollection.**

@ElementCollection maps a collection of basic types or embeddables. For example, a User with multiple phone numbers: @ElementCollection private List<String> phoneNumbers. Hibernate creates a separate table (user_phone_numbers) with user_id and phone_number columns. For embeddables: @ElementCollection private List<Address> addresses. The table includes columns for all embeddable fields plus foreign key to User. Unlike @OneToMany, these aren't entities - they're value types that don't exist independently. Element collections are always EAGER by default, so specify fetch=FetchType.LAZY for large collections. Use when you have simple value collections without complex relationships.

**#. What is composite key and how do you implement it?**

A composite key uses multiple columns as primary key. Two approaches in Hibernate: @IdClass or @EmbeddedId. With @IdClass, mark entity with @IdClass(CompositeId.class) and multiple @Id fields. CompositeId must be serializable, have equals/hashCode, and same fields. With @EmbeddedId, create an embeddable class with @Embeddable and the key fields, then use @EmbeddedId in entity. For example: @EmbeddedId private OrderId id where OrderId has orderId and productId. @EmbeddedId is cleaner as it encapsulates the key. Composite keys are common in legacy databases or many-to-many join tables with additional attributes.

**#. Explain inheritance mapping strategies in Hibernate.**

Hibernate supports three inheritance strategies. **SINGLE_TABLE** (default) - all classes in hierarchy stored in one table with a discriminator column to identify type. Pros: simple, fast. Cons: nullable columns, large table. **JOINED** - each class has its own table, joined by foreign key. Pros: normalized, no nullable columns. Cons: joins required, slower. **TABLE_PER_CLASS** - each concrete class has its own table with all inherited fields. Pros: no joins, no discriminator. Cons: unions required for polymorphic queries, denormalized. Specify with @Inheritance(strategy=InheritanceType.SINGLE_TABLE) and @DiscriminatorColumn. Choose based on hierarchy depth, query patterns, and normalization requirements. SINGLE_TABLE is often the best for performance.

**#. What is @MappedSuperclass?**

@MappedSuperclass marks a class whose mappings are inherited by subclasses, but the class itself is not an entity and has no table. It's useful for common fields like id, createdDate, modifiedDate. For example: @MappedSuperclass public abstract class BaseEntity { @Id @GeneratedValue private Long id; private LocalDateTime created; }. Then entities extend it: @Entity public class User extends BaseEntity. User table has id and created columns. Unlike inheritance mapping with @Inheritance, @MappedSuperclass doesn't support polymorphic queries - you can't query for BaseEntity. Use it for sharing common fields across entities without inheritance relationships in the database.

## Hibernate Advanced Topics

**#. What is Hibernate transaction management?**

Hibernate doesn't manage transactions itself - it integrates with transaction managers. For standalone applications, use RESOURCE_LOCAL transactions: Transaction tx = session.beginTransaction(); try { // work; tx.commit(); } catch (Exception e) { tx.rollback(); }. For Java EE or Spring, use JTA or Spring transaction management. Always use transactions even for read operations - they define clear boundaries. Set isolation level with @Transactional(isolation=...) in Spring. Configure in hibernate.cfg.xml with hibernate.connection.isolation. Transaction management ensures ACID properties. Without transactions, auto-commit mode executes each statement independently, which is inefficient and can cause inconsistencies.

**#. Explain optimistic vs pessimistic locking.**

**Optimistic locking** assumes conflicts are rare. It doesn't lock database rows but detects conflicts at commit time using a version field. Add @Version field (usually Long or Integer): @Version private Long version. Hibernate checks if version changed since read - if yes, throws OptimisticLockException and rolls back. **Pessimistic locking** locks rows immediately when reading to prevent others from modifying. Use with LockMode: session.get(User.class, id, LockMode.PESSIMISTIC_WRITE). This locks the row until transaction ends. Use optimistic for low contention, pessimistic for high contention or critical updates. Pessimistic locking can cause deadlocks and reduced concurrency.

**#. What is @Version annotation?**

@Version enables optimistic locking by adding a version field that's automatically incremented on each update. The field can be Long, Integer, Short, or Timestamp. For example: @Version private Long version. When Hibernate updates an entity, it increments version and adds version check to UPDATE statement: UPDATE users SET name=?, version=version+1 WHERE id=? AND version=?. If no rows are updated (version mismatch), OptimisticLockException is thrown. This prevents lost updates when two transactions read the same row and both try to update it. Always use @Version for entities that can be updated concurrently. Don't manually set the version - Hibernate manages it.

**#. Explain Hibernate validation.**

Hibernate Validator is the reference implementation of Bean Validation (JSR-303/380). You annotate entity fields with constraints: @NotNull, @NotEmpty, @Size, @Email, @Min, @Max, @Pattern, etc. For example: @NotNull @Email @Column(unique=true) private String email. Validation happens automatically before insert/update if validator is on classpath. You can validate manually: ValidatorFactory factory = Validation.buildDefaultValidatorFactory(); Validator validator = factory.getValidator(); Set<ConstraintViolation<User>> violations = validator.validate(user). If violations exist, throw exception. In Spring Boot with JPA, validation is automatic with @Valid. Custom validators can be created with @Constraint and ConstraintValidator.

**#. What is Hibernate Envers?**

Hibernate Envers provides auditing and versioning of entities. It automatically tracks changes and maintains history. Annotate entities with @Audited: @Entity @Audited public class User. Envers creates audit tables (user_AUD) storing revisions. Each change creates a new revision with revision number and timestamp. Query history: AuditReader reader = AuditReaderFactory.get(session); User historical = reader.find(User.class, id, revisionNumber). You can get all revisions, changes between revisions, or state at specific time. Configure which fields to audit with @NotAudited. Envers is powerful for compliance, debugging, and undo functionality. It adds overhead but is invaluable when you need history.

**#. Explain Hibernate filters.**

Filters allow applying criteria to all queries dynamically. Define filter with @FilterDef: @FilterDef(name="activeOnly", parameters=@ParamDef(name="active", type="boolean")). Apply to entity: @Filter(name="activeOnly", condition="active = :active"). Enable in Session: session.enableFilter("activeOnly").setParameter("active", true). Now all queries automatically filter by active status. Disable with session.disableFilter(). Filters are session-scoped - different sessions can have different filters. Use cases include soft deletes, multi-tenancy (filter by tenant), or conditional visibility. Filters apply transparently without changing queries. More powerful than @Where annotation which is static.

**#. What is @Formula annotation?**

@Formula defines a computed property based on an SQL expression rather than a physical column. The value is calculated by the database, not stored. For example: @Formula("(SELECT COUNT(*) FROM orders o WHERE o.user_id = id)") private int orderCount. This executes a subquery to calculate order count for each user. The property is read-only and calculated on every load. Use it for derived values, denormalized data, or aggregations. Be cautious of performance - the formula executes for each entity. For frequently accessed formulas, consider storing the computed value. @Formula is Hibernate-specific, not JPA standard.

**#. Explain second-level cache providers and configuration.**

Second-level cache providers include EhCache (most popular, feature-rich), Infinispan (distributed, Red Hat), Hazelcast (distributed), and Caffeine (high performance, simple). To configure: add provider dependency, enable in properties: hibernate.cache.use_second_level_cache=true, hibernate.cache.region.factory_class=..., specify cache strategy: @Cache(usage=CacheConcurrencyStrategy.READ_WRITE). Strategies include READ_ONLY (immutable data), READ_WRITE (supports updates, transactional), NONSTRICT_READ_WRITE (minimal synchronization), and TRANSACTIONAL (JTA transactions). Configure cache regions for entities, collections, and queries. Monitor cache hit rates and tune configuration. Second-level cache dramatically improves performance but adds complexity with invalidation and consistency.

**#. What is query cache in Hibernate?**

Query cache stores query results, not just entities. Enable with hibernate.cache.use_query_cache=true. Make queries cacheable: query.setCacheable(true). When you execute the query again with same parameters, results come from cache. Query cache stores IDs of matching entities, then uses second-level cache to retrieve entities (or database if not in cache). It's useful for frequently executed queries with stable results. However, it's invalidated whenever any entity of the queried type is modified, which can make it ineffective for frequently updated entities. Use for relatively static data. Specify cache region: query.setCacheRegion("queryRegion") for fine-grained control.

**#. Explain batch processing in Hibernate.**

Batch processing optimizes bulk operations by grouping multiple statements. Configure batch size: hibernate.jdbc.batch_size=20. When saving many entities, Hibernate groups 20 INSERTs into one batch, reducing round trips. For updates: session.save(entity); if (i % 20 == 0) { session.flush(); session.clear(); }. Flush executes batched statements, clear releases memory. For bulk updates: query.executeUpdate() bypasses first-level cache and executes one UPDATE/DELETE for many rows. For example: "UPDATE User SET status = :status WHERE ...". Use StatelessSession for really large imports - it doesn't maintain first-level cache. Batch processing is crucial for performance with large datasets - it can be 10-100x faster.

**#. What is StatelessSession?**

StatelessSession is a lightweight session without first-level cache, dirty checking, or cascading. Operations: insert(), update(), delete() - explicit, no auto-detection. No lazy loading - associations must be fetched explicitly. Use for batch processing or bulk imports where you don't need Hibernate's object management features. For example, importing 1 million rows - StatelessSession uses constant memory while Session would maintain all objects in memory. Get it from sessionFactory.openStatelessSession(). It's faster and uses less memory but loses convenience features. Use when performance is critical and object management overhead isn't needed.

**#. Explain Hibernate Interceptors.**

Interceptors allow intercepting entity operations like save, update, delete. Implement Interceptor or extend EmptyInterceptor and override methods: onSave(), onFlushDirty(), onDelete(), onLoad(), findDirty(), etc. For example, auto-setting audit fields: public boolean onFlushDirty(Object entity, Serializable id, Object[] currentState, Object[] previousState, String[] propertyNames, Type[] types) { if (entity instanceof Auditable) { setModifiedDate(currentState, propertyNames); return true; } return false; }. Set interceptor on SessionFactory or Session. Use for cross-cutting concerns like auditing, logging, security. More powerful than entity listeners but tied to Hibernate, not JPA standard.

**#. What are entity listeners and lifecycle callbacks?**

JPA provides lifecycle callbacks with annotations: @PrePersist (before save), @PostPersist (after save), @PreUpdate (before update), @PostUpdate (after update), @PreRemove (before delete), @PostRemove (after delete), @PostLoad (after load). Use in entity: @PrePersist public void prePersist() { createdDate = LocalDateTime.now(); }. Or create separate listener: @EntityListeners(AuditListener.class). Listener class has methods with these annotations. Entity listeners are JPA standard, more portable than Hibernate interceptors. Use for auditing, validation, or any logic that should execute on entity lifecycle events. They're simpler than interceptors for common use cases.

**#. Explain Hibernate custom types.**

Custom types allow mapping unconventional data types or customizing standard type behavior. Implement UserType interface with methods nullSafeGet() (read from ResultSet), nullSafeSet() (write to PreparedStatement), deepCopy(), equals(), and others. Register with @Type annotation: @Type(type="com.example.MyCustomType") private MyClass myField. Use cases include encrypting data, mapping JSON to POJO, handling legacy encodings, or storing enums as strings. For simple cases, use @Converter (JPA 2.1) instead: @Converter public class MyConverter implements AttributeConverter<MyClass, String>. Converters are simpler and JPA standard. Use UserType only for complex requirements.

**#. What is Hibernate Bytecode Enhancement?**

Bytecode enhancement modifies entity bytecode at build or runtime to add features. Benefits include lazy loading without proxies (directly initialize fields), inline dirty checking (faster than reflection), association management (automatically maintain bidirectional relationships), and extended lazy loading (lazy individual fields). Enable with build plugin or runtime enhancement. Configure: hibernate.enhancer.enableLazyInitialization=true. Enhancement makes entities smarter - they manage their own state changes. It improves performance and allows lazy loading even with getters returning final fields. However, it adds complexity and tooling dependency. Not commonly used but valuable for performance-critical applications.

## Hibernate Best Practices & Troubleshooting

**#. What are common Hibernate performance issues and solutions?**

Common issues: N+1 queries - use JOIN FETCH or batch fetching. Cartesian products from multiple collections - use @BatchSize or separate queries. Large result sets - use pagination with setFirstResult() and setMaxResults(). Inefficient queries - analyze with hibernate.show_sql=true and hibernate.format_sql=true, check generated SQL. Missing indexes - ensure foreign keys and frequently queried columns are indexed. Session not closed - causes connection leaks. Over-eager fetching - use LAZY and fetch only what's needed. Too many objects in first-level cache - flush() and clear() periodically. No second-level cache for static data - enable for reference data. No batch processing for bulk operations - use batch mode or bulk HQL.

**#. What is LazyInitializationException and how to handle it?**

LazyInitializationException occurs when accessing a lazy-loaded association after the Session is closed. For example, loading a User, closing Session, then accessing user.getOrders() - the orders weren't loaded and Session is gone. Solutions: eager fetch the association with JOIN FETCH if you know you'll need it. Keep Session open (Open Session in View pattern) - not recommended, can cause issues. Initialize associations explicitly before closing Session: Hibernate.initialize(user.getOrders()). Use DTO projections instead of entities. Make fetch EAGER (not recommended, loads unnecessary data). Restructure code to access within transaction. Best solution depends on architecture - prefer explicit fetching or DTOs.

**#. Explain best practices for using Hibernate Session.**

Always use one Session per transaction - create, use, close. Never share Session across threads - it's not thread-safe. Close Session in finally block or use try-with-resources. Flush and clear periodically for batch operations to prevent memory issues. Use appropriate flush mode - AUTO (default), COMMIT, or MANUAL. Don't keep Session open for entire request (Open Session in View) if possible - it can cause performance issues. Retrieve Session from SessionFactory for each transaction. In Spring, use @Transactional and let Spring manage Session lifecycle. Avoid stateful sessions in web tier. Always handle exceptions and rollback transactions on error. Proper Session management prevents leaks and ensures consistency.

**#. How do you debug Hibernate issues?**

Enable SQL logging: hibernate.show_sql=true, hibernate.format_sql=true, hibernate.use_sql_comments=true. This shows generated SQL, formatted and with comments indicating which query it's for. Log bind parameters: logging.level.org.hibernate.type.descriptor.sql=trace. This shows actual values. Use Hibernate statistics: hibernate.generate_statistics=true, log org.hibernate.stat. Analyze slow queries and cache hit rates. Use profiler like JProfiler or YourKit to identify slow operations. Check connection pool usage. For lazy loading issues, check when associations are accessed. For performance issues, examine N+1 queries, missing indexes, or cartesian products. Use database query analyzer to optimize SQL. Hibernate logging and statistics reveal most issues.

**#. What are common Hibernate pitfalls to avoid?**

Bidirectional relationships without proper management - always set both sides. Not using @Transactional for updates - dirty checking won't work. Comparing entities with == instead of equals() - proxies won't match. Using mutable collections in entities - use Set/List from java.util, not custom implementations. Not overriding equals/hashCode for entities in collections - especially problematic with Set. Using inappropriate fetch strategies - EAGER fetching everything or LAZY causing N+1. Calling getter in equals/hashCode - triggers lazy loading. Not handling LazyInitializationException properly. Forgetting to close Session - causes connection leaks. Using Integer/Long for IDs without considering equality. Over-using second-level cache - causing stale data. These are common mistakes that cause subtle bugs.
