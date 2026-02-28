# Java Persistence API

## JPA Basics

**#. What is JPA and why was it introduced?**

JPA (Java Persistence API) is a specification for object-relational mapping in Java. It was introduced as part of Java EE 5 (2006) to standardize ORM across different providers. Before JPA, you had proprietary solutions like Hibernate, TopLink, EclipseLink - each with different APIs. JPA provides a common set of interfaces and annotations so you can switch between implementations without changing application code. It defines how to declare persistent entities, perform CRUD operations, query data, and manage transactions. Implementations include Hibernate (most popular), EclipseLink (reference implementation), and OpenJPA. JPA promotes portability and allows leveraging community knowledge. It's now the de facto standard for persistence in Java.

**#. What's the difference between JPA and Hibernate?**

JPA is a specification - it's a set of interfaces and annotations defined by Java EE. Hibernate is an implementation of JPA - it provides the actual functionality. When you use @Entity, @Id, EntityManager - you're using JPA. When you use SessionFactory, Session.get(), or HQL - you're using Hibernate-specific features. Other JPA implementations include EclipseLink and OpenJPA. Best practice is to use JPA interfaces when possible for portability. Use Hibernate-specific features only when JPA doesn't provide what you need. For example, Hibernate's Criteria API or second-level cache configuration are beyond JPA. Most applications can stick to JPA and achieve portability across implementations.

**#. What is EntityManager and its relationship to Hibernate Session?**

EntityManager is the JPA interface for interacting with persistence context. It provides methods like persist(), merge(), remove(), find(), createQuery(). In Hibernate implementation, EntityManager wraps a Session - they're nearly equivalent. You can unwrap EntityManager to get Session: session = entityManager.unwrap(Session.class). EntityManager is the standard JPA way, Session is Hibernate-specific. EntityManager methods like persist() and merge() map to Session methods. Both manage persistent entities and synchronize with database. Use EntityManager in new code for portability. Session offers some Hibernate-specific features not in JPA like replicate() or evict().

**#. Explain persistence context.**

Persistence context is a set of managed entity instances. It's like a cache of entities within a transaction. When you load an entity, it enters the persistence context. EntityManager manages this context - it tracks changes to entities and synchronizes with database at flush time. Within one persistence context, there's only one instance per database row - if you load the same row twice, you get the same Java object. This ensures consistency. Persistence context scope can be transaction-scoped (default, cleared at transaction end) or extended (spans multiple transactions). Understanding persistence context is crucial - it's where entities are managed, dirty checking happens, and changes are tracked.

**#. What are the entity lifecycle states in JPA?**

JPA entities have four states. **New/Transient** - created with 'new' but not in persistence context. Not associated with database. **Managed/Persistent** - in persistence context and has database representation. Changes are tracked and synchronized at flush. Get managed entities from find(), persist(), or merge(). **Detached** - was managed but persistence context closed. Still has database representation but changes aren't tracked. **Removed** - marked for deletion, will be deleted at flush. Transitions: persist() makes transient→managed, merge() makes detached→managed (returns new managed instance), remove() makes managed→removed, detach() makes managed→detached, clear() detaches all. Understanding states prevents bugs with entity tracking.

**#. Explain the difference between persist() and merge().**

persist() makes a transient entity managed - it inserts a new row. Call it on new entities. If the entity already exists (same ID), it throws EntityExistsException. The original object becomes managed. merge() copies state from detached entity to managed entity and returns the managed one. If no managed instance exists, it loads from database or creates new. The original detached object remains detached - you must use the returned object. Use persist() for new entities, merge() for detached entities you want to update. merge() is safer for updates because it handles both new and existing entities, but persist() is clearer for inserts and more efficient.

**#. What is the difference between find() and getReference()?**

find() loads the entity immediately and returns the actual object or null if not found. It hits the database right away. getReference() returns a proxy without hitting the database immediately - it's lazy. The database is accessed when you call a method on the proxy. If entity doesn't exist, find() returns null, but getReference() throws EntityNotFoundException when you access the proxy. Use find() when you're not sure the entity exists and need to check for null. Use getReference() when you know it exists and want to benefit from lazy loading, like setting a foreign key reference without loading the entire entity.

**#. Explain JPQL (Java Persistence Query Language).**

JPQL is JPA's query language, similar to SQL but operates on entities and properties instead of tables and columns. For example, "SELECT u FROM User u WHERE u.age > :age" instead of "SELECT * FROM users WHERE age > ?". JPQL is database-independent - JPA provider translates to appropriate SQL dialect. It supports joins, aggregations, subqueries, ordering, grouping - most SQL features. Use named parameters (:name) or positional (?1). JPQL returns entities or projections. Create queries with EntityManager: Query query = em.createQuery("SELECT u FROM User u"). JPQL is the standard way to query in JPA. It's portable and works with entities, making it more object-oriented than SQL.

**#. What are named queries?**

Named queries are pre-defined queries declared using @NamedQuery annotation on entities. For example: @Entity @NamedQuery(name="User.findByEmail", query="SELECT u FROM User u WHERE u.email = :email"). Use them with: em.createNamedQuery("User.findByEmail", User.class).setParameter("email", email). Benefits include compile-time syntax checking (at deployment time), centralized query management, and potential performance optimization as providers can prepare queries at startup. Use @NamedQueries to declare multiple queries. For native SQL, use @NamedNativeQuery. Named queries make queries reusable and easier to maintain than embedded query strings. They're especially useful for complex, frequently used queries.

**#. Explain Criteria API in JPA.**

Criteria API is a programmatic, type-safe way to build queries. Instead of string queries, you build using Java objects. Example: CriteriaBuilder cb = em.getCriteriaBuilder(); CriteriaQuery<User> cq = cb.createQuery(User.class); Root<User> user = cq.from(User.class); cq.select(user).where(cb.equal(user.get("email"), email)). Benefits include compile-time checking, IDE support, and dynamic query building. It's verbose but safer than string concatenation for dynamic queries. Use Criteria for complex, dynamic queries where conditions vary at runtime. For simple, static queries, JPQL is cleaner. Criteria API is part of JPA standard, making it portable across providers.

**#. What is the EntityManagerFactory?**

EntityManagerFactory creates EntityManager instances. It's expensive to create - typically one per application. It's thread-safe and represents the database configuration. In standalone apps, create with Persistence.createEntityManagerFactory("persistence-unit-name"). In Spring/Java EE, it's managed by container. EntityManagerFactory reads persistence.xml, establishes connection pool, and prepares metadata. EntityManagers created from it are lightweight. Always close EntityManagerFactory on application shutdown. In Spring Boot, EntityManagerFactory is auto-configured based on JPA configuration. Think of it as a factory for creating database conversations (EntityManagers). Proper management ensures efficient resource usage.

**#. Explain persistence.xml.**

persistence.xml is the JPA configuration file, located in META-INF directory. It defines persistence units - logical groups of entities with configuration. Key elements: persistence-unit name, provider (like org.hibernate.jpa.HibernatePersistenceProvider), data source (jta-data-source or non-jta-data-source), entities (class elements), properties (like hibernate.hbm2ddl.auto, hibernate.show_sql). In Spring Boot, persistence.xml is optional - you configure via application.properties. In Java EE, it's required. Multiple persistence units are allowed for multiple databases. Properties configure provider-specific behavior. It's the central configuration for JPA applications, though modern frameworks like Spring Boot minimize its use.

**#. What are entity relationships in JPA?**

JPA supports four relationship types. **@OneToOne** - one entity maps to exactly one other, like User and UserProfile. **@OneToMany** - one entity maps to many others, like Department and Employees. **@ManyToOne** - inverse of OneToMany, many map to one. **@ManyToMany** - entities on both sides map to multiple on other side, like Students and Courses. Each can be unidirectional (one side knows about relationship) or bidirectional (both know). Owning side has @JoinColumn or @JoinTable. Inverse side has mappedBy. Relationships can be eager or lazy. Proper relationship modeling is crucial - it affects database design, query performance, and data integrity.

**#. Explain cascade types in JPA.**

Cascade operations propagate from parent to child entities. Types: **PERSIST** - persisting parent persists children. **MERGE** - merging parent merges children. **REMOVE** - removing parent removes children. **REFRESH** - refreshing parent refreshes children. **DETACH** - detaching parent detaches children. **ALL** - all of above. Specify with cascade attribute: @OneToMany(cascade = CascadeType.ALL). Use carefully, especially REMOVE - it can delete more than expected. Typically cascade PERSIST and MERGE for composition relationships where children don't exist independently. For example, Order→OrderItems cascade ALL, but Department→Employees don't cascade REMOVE. Cascading simplifies code but requires understanding of entity relationships.

**#. What is fetch type - LAZY vs EAGER?**

Fetch type determines when related entities are loaded. **LAZY** loads associations only when explicitly accessed - improves performance by loading only what's needed. **EAGER** loads associations immediately with parent - data is readily available. For *ToOne (@ManyToOne, @OneToOne), default is EAGER. For *ToMany (@OneToMany, @ManyToMany), default is LAZY. Specify with fetch attribute: @OneToMany(fetch = FetchType.LAZY). LAZY can cause LazyInitializationException if accessed after persistence context closes. EAGER can cause N+1 problems and load unnecessary data. Best practice: use LAZY for most associations and explicitly fetch when needed using JOIN FETCH in JPQL. This gives you control.

## JPA Annotations

**#. What is @Entity annotation?**

@Entity marks a class as a JPA entity - a persistent domain object mapped to database table. Requirements: entity must have no-arg constructor (can be private), must not be final, and must have primary key with @Id. By default, table name is class name, but customize with @Table. Entity becomes managed by EntityManager. You can query entities with JPQL using entity name. Fields are automatically persisted unless marked @Transient. Entity is the core of JPA - without it, the class is just a POJO. Most business domain objects in JPA applications are entities. They encapsulate data and are synchronized with database by persistence provider.

**#. Explain @Table annotation.**

@Table provides table-specific information for an entity. Attributes: **name** - table name (default is entity name), **schema** - database schema, **catalog** - database catalog, **uniqueConstraints** - unique constraints beyond just column uniqueness, **indexes** - define indexes for performance. Example: @Table(name="users", schema="public", uniqueConstraints={@UniqueConstraint(columnNames={"email"})}, indexes={@Index(columnList="lastName")}). Most commonly, you just specify name. Schema and catalog are useful in multi-schema databases. uniqueConstraints and indexes help with database design and performance. In Spring Boot, schema auto-generation uses this information to create proper DDL.

**#. What is @Id and primary key generation strategies?**

@Id marks the primary key field. JPA requires every entity to have an identifier. For generation, use @GeneratedValue with strategies: **AUTO** - provider chooses appropriate strategy based on database (default). **IDENTITY** - database auto-increment, good for MySQL. **SEQUENCE** - database sequence, good for PostgreSQL/Oracle, supports batch inserts. **TABLE** - uses separate table for ID generation, database-independent but less efficient. Example: @Id @GeneratedValue(strategy = GenerationType.IDENTITY). For custom generation, implement IdentifierGenerator. For natural keys (like SSN), just use @Id without @GeneratedValue. Choose strategy based on database capabilities and performance requirements.

**#. Explain @Column annotation and its attributes.**

@Column defines column mapping for a field. Attributes: **name** - column name (default is field name), **unique** - unique constraint, **nullable** - allow nulls (default true), **insertable** - include in INSERT (default true), **updatable** - include in UPDATE (default true), **length** - for strings (default 255), **precision** and **scale** - for decimals, **columnDefinition** - custom SQL type. Example: @Column(name="email_address", nullable=false, unique=true, length=100). These attributes control database schema and validation. Not using @Column means default behavior. For complex types, columnDefinition allows custom definitions. These map Java types to SQL types appropriately.

**#. What is @Transient annotation?**

@Transient marks a field that should NOT be persisted - it's excluded from database mapping. Use for derived values, temporary states, or values that don't need persistence. For example: @Transient private int age; //calculated from birthDate. The field exists in Java object but has no database column. Useful for runtime calculations, caching, or transient state. It's the opposite of persistent fields. Without @Transient, all fields are persistent by default. Similar to Java's transient keyword for serialization, but @Transient is for JPA persistence. Use when you need object state that doesn't belong in database.

**#. Explain @Temporal annotation.**

@Temporal specifies the precision for date/time fields. Values: **DATE** - only date (java.sql.Date), **TIME** - only time (java.sql.Time), **TIMESTAMP** - both date and time (java.sql.Timestamp). Example: @Temporal(TemporalType.DATE) private Date birthDate. Important for java.util.Date and java.util.Calendar because they include time information that you might not want to persist. For java.time API (LocalDate, LocalTime, LocalDateTime), @Temporal is not needed - they're mapped correctly by default. Most modern code uses java.time, but @Temporal is still relevant for legacy code using java.util.Date. It ensures proper SQL type mapping.

**#. What are @Enumerated options?**

@Enumerated specifies how enums are persisted. Two types: **ORDINAL** - stores enum position as integer (0, 1, 2...). **STRING** - stores enum name as string. Example: @Enumerated(EnumType.STRING) private Status status. Default is ORDINAL. NEVER use ORDINAL in production - if you reorder enums, database values become wrong. Always use STRING for safety and readability. Database stores "ACTIVE" instead of 0, making queries and debugging easier. The tradeoff is slightly more storage for strings. You can also create custom mapping using @Converter for more control. Always prefer STRING unless you have specific reasons for ORDINAL.

**#. Explain @Lob annotation.**

@Lob (Large Object) stores large data like images, files, or long text. For character data, it maps to CLOB (Character Large Object). For binary data, it maps to BLOB (Binary Large Object). Example: @Lob private String description; //CLOB or @Lob private byte[] image; //BLOB. LOBs can store gigabytes of data. Be careful with LOBs in entities - they can impact performance if loaded eagerly. Consider storing files externally and only storing file paths. LOBs are useful for documents, images, or large text fields that exceed VARCHAR limits. Some databases have size limits on LOBs. Always consider whether external storage (like S3) is better.

**#. What is @Basic annotation?**

@Basic is the simplest mapping type - it's actually implicit on all fields without other mapping annotations. Explicitly use it to customize fetch type or optional. Attributes: **fetch** - LAZY or EAGER (default EAGER), **optional** - allows null (default true). Example: @Basic(fetch = FetchType.LAZY) private String largeDescription. Makes the field lazy-loaded. Most fields are implicitly @Basic. You rarely need to specify it explicitly. It's useful when you want LAZY loading for large fields to improve performance. Not all providers support lazy basic fields. Hibernate does with bytecode enhancement. For most cases, the implicit @Basic with defaults is sufficient.

**#. Explain embedded objects with @Embeddable and @Embedded.**

@Embeddable marks a class that's embedded in an entity - not a separate entity, no own table. For example, Address class with street, city, zipCode. Use @Embedded in entity: @Embedded private Address address. The User table has street, city, zipCode columns. Benefits include code reusability and object-oriented design without relationship complexity. You can customize column names with @AttributeOverrides: @AttributeOverrides({@AttributeOverride(name="street", column=@Column(name="home_street"))}). Multiple embeddables of same type need overrides to avoid column conflicts. Embeddables can be null. They're value objects, not entities. Perfect for grouping related fields like address, name, money.

**#. What is @ElementCollection?**

@ElementCollection maps collections of basic types or embeddables (not entities). Example: @ElementCollection private List<String> phoneNumbers. JPA creates a separate table (user_phone_numbers) with foreign key to User and phone_number column. For embeddables: @ElementCollection private Set<Address> addresses creates table with foreign key plus columns for all Address fields. Unlike @OneToMany, elements aren't entities - they're value types with no independent existence. Default fetch is LAZY. Use @CollectionTable to customize table name. Element collections are simpler than entity relationships when you don't need entities. Useful for lists of strings, enums, or simple embeddables.

**#. Explain composite primary keys with @IdClass and @EmbeddedId.**

Composite keys use multiple columns as primary key. Two approaches: **@IdClass** - mark entity with @IdClass(CompositeKey.class) and multiple @Id fields. CompositeKey is separate class with same fields, implements Serializable, has equals/hashCode. **@EmbeddedId** - create @Embeddable key class and use @EmbeddedId in entity. Example: @EmbeddedId private OrderId id where OrderId has orderId and productId. @EmbeddedId is cleaner - encapsulates key in one field. Both work similarly but @EmbeddedId is preferred for cleaner API. Use in legacy databases or junction tables with additional attributes. EntityManager methods accept the composite key object.

**#. What is @MapsId annotation?**

@MapsId is used when entity's primary key is also a foreign key to another entity. Common in @OneToOne relationships with shared primary key. Example: User has @Id Long id. UserProfile has @Id Long id and @OneToOne @MapsId private User user. UserProfile uses User's ID as its own - no separate ID generation. The @MapsId indicates that user relationship maps to the id field. Benefits: enforces one-to-one constraint and saves database space. Downsides: entities are more tightly coupled. Use when you have true one-to-one relationship and want to share primary key. It's more efficient than separate foreign key column.

**#. Explain @JoinColumn annotation.**

@JoinColumn specifies the foreign key column for relationships. Attributes: **name** - foreign key column name, **referencedColumnName** - referenced column in target table (usually primary key), **nullable**, **unique**, **insertable**, **updatable**. Example: @ManyToOne @JoinColumn(name="department_id", nullable=false) private Department department. The employee table has department_id foreign key. Without @JoinColumn, JPA uses default name (field_id). Use on owning side of relationship. For bidirectional relationships, @JoinColumn is on @ManyToOne side or @OneToOne owning side. It gives precise control over foreign key column definition. Essential for matching existing database schema or customizing column names.

**#. What is @JoinTable annotation?**

@JoinTable defines the join table for @ManyToMany relationships. Attributes: **name** - join table name, **joinColumns** - foreign keys to owning side, **inverseJoinColumns** - foreign keys to inverse side. Example: @ManyToMany @JoinTable(name="student_course", joinColumns=@JoinColumn(name="student_id"), inverseJoinColumns=@JoinColumn(name="course_id")). Creates student_course table with student_id and course_id. Use on owning side. Without @JoinTable, JPA creates default table with default names. Use @JoinTable for control over join table structure. You can also add unique constraints and indexes. For many-to-many with additional attributes, create explicit entity for join table instead.

## JPA Querying

**#. How do you create and execute JPQL queries?**

Create queries using EntityManager: TypedQuery<User> query = em.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class). Set parameters: query.setParameter("email", "john@example.com"). Execute: User user = query.getSingleResult() for single result, List<User> users = query.getResultList() for list. For updates/deletes: int updated = query.executeUpdate(). Use TypedQuery for type safety. For dynamic queries, build query string programmatically, but be careful of SQL injection - always use parameters, never concatenate user input. Set pagination with setFirstResult() and setMaxResults(). JPQL is case-sensitive for entity and property names but not for JPQL keywords.

**#. What's the difference between getSingleResult() and getResultList()?**

getSingleResult() expects exactly one result and returns that object. If no results, throws NoResultException. If multiple results, throws NonUniqueResultException. Use when you're certain query returns exactly one row, like finding by unique email. getResultList() returns a list of results - it can be empty, have one element, or many. Never throws exceptions for 0 or multiple results. Use for queries that might return any number of results. For optional single results, use getResultList() and check if empty to avoid exception handling: List<User> list = query.getResultList(); User user = list.isEmpty() ? null : list.get(0). This is cleaner than catching NoResultException.

**#. Explain JPQL joins.**

JPQL supports various joins. **Inner join**: "SELECT u FROM User u JOIN u.department d WHERE d.name = :name". **Left outer join**: "SELECT u FROM User u LEFT JOIN u.orders o". **Fetch join** (to avoid N+1): "SELECT u FROM User u JOIN FETCH u.orders". Fetch join loads associations eagerly in one query. You can join on relationships or explicit on conditions. Example: "SELECT u FROM User u JOIN Department d ON u.departmentId = d.id". Use JOIN FETCH to avoid lazy loading issues. Be careful with multiple fetch joins on collections - can cause cartesian product. You can alias joined entities for conditions or selections. Joins are essential for efficient querying across relationships.

**#. What is the difference between JOIN and JOIN FETCH?**

Regular JOIN just joins tables for filtering or selection but doesn't load associations - entities use lazy loading. JOIN FETCH joins and also loads the associations eagerly. Example: "SELECT u FROM User u JOIN u.department d" returns Users but departments are still lazy. "SELECT u FROM User u JOIN FETCH u.department" returns Users with departments loaded. JOIN FETCH solves N+1 problems. Use it when you know you'll access associations to avoid multiple queries. Don't use JOIN FETCH in COUNT queries or with setMaxResults() on collections - can cause issues. JOIN FETCH is optimization for eager loading specific associations without changing entity fetch type globally.

**#. Explain JPQL aggregate functions and grouping.**

JPQL supports SQL aggregates: COUNT, SUM, AVG, MAX, MIN. Example: "SELECT COUNT(u) FROM User u" or "SELECT AVG(u.salary) FROM User u WHERE u.department.name = :dept". Use GROUP BY for grouping: "SELECT u.department.name, COUNT(u) FROM User u GROUP BY u.department.name". Use HAVING for filtering groups: "SELECT d.name, COUNT(u) FROM User u JOIN u.department d GROUP BY d.name HAVING COUNT(u) > 10". Aggregates return primitives or wrapper types, not entities. Use with DTO projections: "SELECT new com.example.DeptStats(d.name, COUNT(u)) FROM User u JOIN u.department d GROUP BY d.name". Aggregates are powerful for reporting and statistics.

**#. What are projection queries and DTOs?**

Projection queries select specific fields instead of entire entities. Example: "SELECT u.firstName, u.lastName FROM User u" returns Object[]. For type safety, use constructor expression with DTO: "SELECT new com.example.UserDTO(u.firstName, u.lastName, u.email) FROM User u". The DTO must have matching constructor: public UserDTO(String firstName, String lastName, String email). This returns List<UserDTO> instead of Object[]. Projections improve performance by selecting only needed columns. They're great for read-only queries, reports, or API responses. DTOs decouple presentation from entities. Spring Data JPA also supports interface projections: define an interface with getters and Spring generates implementation.

**#. Explain native SQL queries in JPA.**

Native SQL queries use actual SQL instead of JPQL: Query query = em.createNativeQuery("SELECT * FROM users WHERE email = ?1", User.class). Pass entity class to map results. Without entity class, returns Object[] arrays. Use when you need database-specific features, complex SQL, or performance optimization. Set parameters positionally (?1, ?2) or named (on some providers). For DML: em.createNativeQuery("UPDATE users SET active = false WHERE ...").executeUpdate(). Use @NamedNativeQuery for reusable native queries. Native queries lose database portability. Always prefer JPQL when possible. Use native SQL only when JPQL is insufficient or for complex reporting queries.

**#. What are query hints?**

Query hints provide database or provider-specific options. Use setHint(): query.setHint("javax.persistence.cache.retrieveMode", CacheRetrieveMode.BYPASS). Common hints: cache retrieval/store mode (control second-level cache), timeout, flush mode, read-only queries. Hibernate hints include fetch size, comment (adds SQL comment), cacheable (enable query cache). Example: query.setHint("org.hibernate.cacheable", true). Hints are key-value pairs. Not all providers support all hints - check provider documentation. Use hints for performance tuning, cache control, or provider-specific features. They're an escape hatch for advanced scenarios when standard API is insufficient.

**#. Explain Criteria API root, predicates, and paths.**

In Criteria API: **Root** represents the entity being queried - starting point. **CriteriaQuery** defines what to query. **Predicate** represents filter conditions. **Path** represents attributes accessed via get(). Example: CriteriaBuilder cb = em.getCriteriaBuilder(); CriteriaQuery<User> cq = cb.createQuery(User.class); Root<User> user = cq.from(User.class); Predicate emailEquals = cb.equal(user.get("email"), "john@example.com"); cq.select(user).where(emailEquals). For multiple predicates, combine with cb.and() or cb.or(). Access nested properties: user.get("department").get("name"). Criteria API is verbose but type-safe and great for dynamic queries. MetaModel classes make it even more type-safe: user.get(User_.email).

**#. How do you implement dynamic queries with Criteria API?**

Criteria API excels at dynamic queries. Build conditionally: CriteriaBuilder cb = em.getCriteriaBuilder(); CriteriaQuery<User> cq = cb.createQuery(User.class); Root<User> user = cq.from(User.class); List<Predicate> predicates = new ArrayList<>(); if (email != null) predicates.add(cb.equal(user.get("email"), email)); if (minAge != null) predicates.add(cb.ge(user.get("age"), minAge)); cq.where(cb.and(predicates.toArray(new Predicate[0]))). This builds a query based on which parameters are provided. Much cleaner than string concatenation. Use for search forms where users can fill any combination of fields. Criteria API makes dynamic queries safe from SQL injection and type-safe.

## JPA Transactions & Advanced Topics

**#. What is JPA transaction management?**

JPA doesn't manage transactions itself - it integrates with transaction managers. In Java SE, use resource-local transactions: EntityTransaction tx = em.getTransaction(); tx.begin(); try { // work; tx.commit(); } catch (Exception e) { tx.rollback(); }. In Java EE/Spring, use JTA or Spring transactions. Annotate methods with @Transactional and container manages transactions. Transactions define ACID boundaries - all operations succeed or all fail. Always use transactions even for reads for consistency. Set isolation level in @Transactional or properties. Proper transaction management ensures data integrity and proper EntityManager behavior like dirty checking and flush.

**#. Explain transaction propagation in JPA.**

Transaction propagation (mostly Spring feature) defines how methods interact with existing transactions. **REQUIRED** (default) - join existing transaction or create new. **REQUIRES_NEW** - always create new transaction, suspend existing. **MANDATORY** - require existing transaction or throw exception. **SUPPORTS** - join if exists, execute non-transactionally otherwise. **NOT_SUPPORTED** - always non-transactional, suspend existing. **NEVER** - non-transactional, throw exception if transaction exists. **NESTED** - nested transaction within existing. Specify with @Transactional(propagation = Propagation.REQUIRES_NEW). Most commonly use REQUIRED. Use REQUIRES_NEW when you need independent transaction (like audit logging that shouldn't roll back with main transaction). Understanding propagation prevents unexpected behavior in service layers.

**#. What is optimistic locking in JPA?**

Optimistic locking prevents lost updates without locking database rows. Use @Version on a field (Long, Integer, Timestamp): @Version private Long version. JPA automatically increments version on update and includes it in WHERE clause: UPDATE user SET name=?, version=? WHERE id=? AND version=?. If version doesn't match (someone else updated), throws OptimisticLockException and transaction rolls back. Use for entities that are read frequently but updated rarely. It has no performance impact on reads and allows high concurrency. All users can read simultaneously - conflicts only detected at write time. Always use @Version for entities in web applications to prevent lost updates from concurrent users.

**#. What is pessimistic locking in JPA?**

Pessimistic locking locks database rows immediately when reading. Use with LockModeType: User user = em.find(User.class, id, LockModeType.PESSIMISTIC_WRITE). This executes SELECT ... FOR UPDATE, locking the row until transaction ends. Other transactions wait. Types: **PESSIMISTIC_READ** - shared lock, prevents writes but allows reads. **PESSIMISTIC_WRITE** - exclusive lock, prevents reads and writes. **PESSIMISTIC_FORCE_INCREMENT** - locks and increments version. Use for high contention or when you must prevent concurrent modifications. Downsides: reduces concurrency, can cause deadlocks. Use timeout: em.find(User.class, id, LockModeType.PESSIMISTIC_WRITE, Collections.singletonMap("javax.persistence.lock.timeout", 5000)). Prefer optimistic locking unless you have specific need.

**#. Explain EntityManager flush modes.**

Flush synchronizes persistence context with database. Flush modes: **AUTO** (default) - flush before query execution if changes might affect query results, and before commit. **COMMIT** - flush only on commit. Set with em.setFlushMode(FlushModeType.COMMIT). AUTO is safer - ensures queries see recent changes. COMMIT is slightly more efficient but queries might not see recent entity changes in persistence context. For example, save a user and then JPQL query for users might not include the new user if not flushed. Usually stick with AUTO. Manual flush with em.flush() when you need to execute SQL immediately, like after batch operations or to get generated IDs.

**#. What are JPA callback methods and lifecycle events?**

Lifecycle callbacks execute at specific entity lifecycle points. Annotations: @PrePersist (before insert), @PostPersist (after insert), @PreUpdate (before update), @PostUpdate (after update), @PreRemove (before delete), @PostRemove (after delete), @PostLoad (after loading). Use in entity: @PrePersist public void prePersist() { this.createdDate = LocalDateTime.now(); } or in separate listener: @EntityListeners(AuditListener.class). Listener class: public class AuditListener { @PrePersist public void prePersist(Object entity) {...} }. Use for auditing, validation, derived values, logging. They're declarative and cleaner than coding in service layer. Multiple listeners can be applied. Callbacks can't use EntityManager operations on same entity.

**#. What is the difference between EntityManager's remove() and clear()?**

remove(entity) marks specific entity for deletion - it enters Removed state and will be deleted from database at flush/commit. The entity must be managed. Example: User user = em.find(User.class, id); em.remove(user). The user is deleted. clear() detaches ALL entities in persistence context - the persistence context is cleared. Entities become detached. No database changes occur. Example: em.clear() after batch processing to free memory. Use remove() to delete specific entities. Use clear() to detach all entities for memory management or when starting fresh. clear() is like closing and reopening persistence context without actually closing EntityManager.

**#. Explain second-level cache in JPA.**

Second-level cache is SessionFactory/EntityManagerFactory-level cache shared across EntityManagers. Configure in persistence.xml: javax.persistence.sharedCache.mode (NONE, ENABLE_SELECTIVE, DISABLE_SELECTIVE, ALL) and cache provider. Enable per entity: @Cacheable @Cache(usage = CacheConcurrencyStrategy.READ_WRITE). Cache stores entities, collections, and query results. Strategies: READ_ONLY (immutable), READ_WRITE (supports updates), NONSTRICT_READ_WRITE (minimal synchronization), TRANSACTIONAL (JTA). First-level cache (persistence context) is checked first, then second-level, then database. Query cache requires second-level cache. Second-level cache dramatically improves performance but adds complexity with invalidation and consistency. Monitor cache hit rates and tune.

**#. What is bean validation in JPA?**

Bean Validation (JSR-303/380) integrates with JPA for automatic validation. Annotate fields: @NotNull, @Size, @Email, @Pattern, @Min, @Max, etc. Example: @NotNull @Email private String email; @Size(min=2, max=50) private String name. JPA automatically validates on persist/update if validator is on classpath. Throws ConstraintViolationException if invalid. Validation groups allow different rules for different scenarios: @NotNull(groups=CreateGroup.class). Specify group in persist: validator.validate(user, CreateGroup.class). Custom validators with @Constraint and ConstraintValidator. Bean Validation ensures data integrity before database, provides clear error messages, and reduces database constraint violations.

**#. What are JPA best practices?**

Key practices: Always use @Version for optimistic locking. Use LAZY fetch type by default and JOIN FETCH when needed. Close EntityManager after use. Use TypedQuery for type safety. Prefer JPQL over native SQL. Use projections/DTOs for read-only queries. Enable second-level cache for read-mostly data. Monitor and fix N+1 query problems. Use batch processing for bulk operations. Always use transactions. Use named queries for reusable queries. Implement equals/hashCode properly for entities in collections. Use @Transactional at service layer. Don't access lazy associations after closing EntityManager. Use pagination for large result sets. Log and analyze SQL. Keep entities simple - move complex logic to services. These practices ensure performant, maintainable JPA applications.
