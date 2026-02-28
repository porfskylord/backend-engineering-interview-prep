# SPRING BOOT

## Spring Boot Basics

**\#. What is Spring Boot and why was it created?**

Spring Boot is a framework built on top of Spring that makes it easier to create production-ready applications quickly. It was created to simplify Spring application development by providing auto-configuration, embedded servers, and starter dependencies. The main goal was to reduce the boilerplate configuration that traditional Spring applications required. With Spring Boot, you can create stand-alone applications that "just run" without needing complex XML configurations or deploying to external servers. It follows an opinionated approach with sensible defaults while still allowing customization.

**\#. What are the advantages of Spring Boot over traditional Spring?**

Spring Boot has several advantages. First, auto-configuration automatically configures your application based on the dependencies you've added. Second, embedded servers like Tomcat or Jetty are included, so you don't need external server setup. Third, starter dependencies bundle commonly used dependencies together. Fourth, it provides production-ready features like health checks, metrics, and externalized configuration out of the box. Fifth, minimal or no XML configuration is needed \- you can use Java-based or annotation-based configuration. Overall, it significantly reduces development time and simplifies deployment.

**\#. Explain the concept of auto-configuration in Spring Boot.**

Auto-configuration is Spring Boot's intelligent way of automatically configuring your application based on the jars present in the classpath. For example, if H2 database jar is in classpath, it automatically configures an in-memory database. If Spring Data JPA is present, it configures JPA repositories. It uses @Conditional annotations to determine what to configure. You can see which auto-configurations are applied using the \--debug flag or actuator. If you want to exclude certain auto-configurations, you can use exclude attribute in @SpringBootApplication or use properties.

**\#. What is the @SpringBootApplication annotation?**

@SpringBootApplication is a convenience annotation that combines three annotations: @Configuration marks the class as a configuration class, @EnableAutoConfiguration enables Spring Boot's auto-configuration, and @ComponentScan scans for components in the current package and sub-packages. It's typically placed on the main class of your application. You can customize its behavior with attributes like exclude to exclude certain auto-configurations or scanBasePackages to specify which packages to scan.

**\#. What are Spring Boot starters?**

Starters are pre-configured dependency descriptors that make it easy to add common functionalities. For example, spring-boot-starter-web includes everything needed for web applications \- Spring MVC, Tomcat, JSON libraries, etc. spring-boot-starter-data-jpa includes JPA, Hibernate, and database drivers. They follow naming convention spring-boot-starter-\*. Benefits include consistent dependency versions, reduced configuration, and quick setup. You just add the starter to your pom.xml or build.gradle, and you're ready to go. Common starters include starter-test, starter-security, starter-actuator.

**\#. What is the difference between @Component, @Service, @Repository, and @Controller?**

These are all stereotype annotations that mark classes as Spring beans. @Component is the generic annotation for any Spring-managed component. @Service is used for service layer classes that contain business logic \- it's semantically clearer. @Repository is used for DAO layer classes that access the database \- it also provides exception translation. @Controller is used for MVC controllers that handle web requests. Functionally, they're similar, but they provide semantic meaning and enable specific behaviors like exception translation for @Repository. Using the right one makes code more readable and maintainable.

**\#. Explain dependency injection in Spring.**

Dependency injection is a design pattern where objects don't create their dependencies but receive them from an external source \- the Spring container. Instead of using 'new' keyword, you declare dependencies and Spring provides them. There are three types: constructor injection where dependencies are passed through constructor, setter injection through setter methods, and field injection using @Autowired on fields. Constructor injection is preferred because it makes dependencies explicit and supports immutability. DI promotes loose coupling, easier testing with mocks, and better code organization.

**\#. What is Inversion of Control? How does Spring implement it?**

IoC is a broader principle where the control of object creation and lifecycle is transferred from the application to a container. In traditional programming, our code controls the flow. With IoC, the framework takes control. Spring implements IoC through its IoC Container (the ApplicationContext), which manages beans and their dependencies. When we ask the container for a bean, it wires up all required dependencies and returns a fully configured object.

**\#. What is a Spring Bean?**

A Spring Bean is simply an object that is instantiated, assembled, and managed by the Spring IoC container. Beans are the fundamental building blocks of a Spring application. They are defined in the Spring configuration (either XML, Java config, or through annotations) and the container creates and wires them together based on the configuration metadata.

**\#. What is the Spring ApplicationContext?**

ApplicationContext is the central interface in Spring that represents the IoC container. It's responsible for instantiating, configuring, and assembling beans. It reads configuration metadata (XML, annotations, or Java config), manages the complete lifecycle of beans, and provides additional enterprise features like internationalization, event publication, resource loading, and more. ClassPathXmlApplicationContext and AnnotationConfigApplicationContext are common implementations.

**\#. What's the difference between @Autowired, @Inject, and @Resource?**

@Autowired is Spring-specific and injects by type. You can use it on constructors, setters, or fields. @Inject is from JSR-330 standard and also injects by type \- it's functionally similar to @Autowired but not Spring-specific. @Resource is from JSR-250 and injects by name first, then by type if name match isn't found. It's commonly used when you have multiple beans of the same type. I prefer @Autowired for Spring applications because it's more widely used and has additional features like required attribute.

**\#. Explain the Spring Bean lifecycle.**

The Spring Bean lifecycle has several phases. First, the bean is instantiated by the container. Then properties are populated through dependency injection. Next, if the bean implements BeanNameAware, setBeanName() is called. Then BeanFactoryAware and ApplicationContextAware methods are called if implemented. After that, @PostConstruct method or InitializingBean's afterPropertiesSet() is called for initialization. The bean is now ready to use. When the container shuts down, @PreDestroy or DisposableBean's destroy() method is called for cleanup. Understanding this helps with initialization and cleanup logic.

**\#. What are Bean scopes in Spring?**

Bean scopes define the lifecycle and visibility of a bean within the container. The main scopes are:Singleton (default): One instance per Spring container. All requests for that bean return the same object.Prototype: A new instance is created every time the bean is requested.Request: (Web-aware) A single instance per HTTP request. Valid only in a web-aware Spring context.Session: (Web-aware) A single instance per HTTP session.Application: (Web-aware) One instance per ServletContext.WebSocket: (Web-aware) One instance per WebSocket.

**\#. What is the difference between singleton and prototype scope?**

Singleton scope means Spring creates one instance of the bean per container and reuses it for all requests. It's the default scope. Prototype scope creates a new instance every time the bean is requested. With singleton, Spring manages the complete lifecycle including destruction. With prototype, Spring only creates and injects the bean but doesn't manage destruction \- you're responsible for cleanup. Singleton is more memory-efficient and suitable for stateless beans. Prototype is suitable for stateful beans where each usage needs independent state.

**\#. Explain application.properties and application.yml.**

These are configuration files for Spring Boot applications. application.properties uses key-value format like server.port=8080. application.yml uses YAML format which is more readable and supports hierarchical structure. Spring Boot automatically loads these files from classpath or config directory. You can have profile-specific files like application-dev.properties. Properties can be accessed using @Value annotation or @ConfigurationProperties. YAML is preferred for complex configurations due to better readability. Spring Boot also supports environment variables and command-line arguments which override file properties.

**\#. What is Spring Boot Actuator?**

Actuator provides production-ready features for monitoring and managing your application. It exposes endpoints that give information about application health, metrics, environment properties, thread dumps, etc. Common endpoints include /actuator/health for health checks, /actuator/metrics for various metrics, /actuator/info for custom application info, /actuator/env for environment properties. Many endpoints are disabled by default for security. You can enable them in properties and secure them using Spring Security. It's essential for production monitoring and troubleshooting.

**\#. How do you create a REST API in Spring Boot?**

To create a REST API, you use @RestController annotation on your controller class. This combines @Controller and @ResponseBody, automatically serializing return values to JSON. Use @RequestMapping or specific annotations like @GetMapping, @PostMapping, @PutMapping, @DeleteMapping for different HTTP methods. Use @PathVariable for path parameters and @RequestBody for request body. For example: @GetMapping("/users/{id}") public User getUser(@PathVariable Long id). Spring Boot's auto-configuration handles JSON conversion using Jackson. You can customize responses using ResponseEntity for HTTP status codes and headers.

**\#. What is @RequestMapping and its variants?**

@RequestMapping is a general annotation for mapping HTTP requests to handler methods. You can specify the HTTP method using the method attribute. Its variants are more specific: @GetMapping for HTTP GET, @PostMapping for POST, @PutMapping for PUT, @DeleteMapping for DELETE, and @PatchMapping for PATCH. These variants are cleaner and more readable. For example, @GetMapping("/users") is equivalent to @RequestMapping(value="/users", method=RequestMethod.GET). You can use them at class level for base path and method level for specific paths.

**\#. Explain @PathVariable and @RequestParam.**

@PathVariable extracts values from the URI path. For example, in @GetMapping("/users/{id}"), you'd use @PathVariable Long id to get the id from the path. @RequestParam extracts values from query parameters. For example, @GetMapping("/users?status=active") would use @RequestParam String status. PathVariable is part of RESTful URLs and is typically required. RequestParam is for optional filtering or additional parameters. You can make RequestParam optional using required=false and provide a default value using defaultValue.

**\#. What is @RequestBody and @ResponseBody?**

@RequestBody binds the HTTP request body to a method parameter. Spring automatically deserializes JSON/XML to a Java object using message converters. It's used with POST, PUT methods to receive data. @ResponseBody indicates that the method return value should be serialized directly to the HTTP response body. With @RestController, @ResponseBody is implicit on all methods. These annotations enable automatic JSON conversion, making REST API development easy without manual parsing or serialization.

**\#. How do you handle exceptions in Spring Boot REST APIs?**

There are several approaches. First, @ExceptionHandler on controller methods handles exceptions for that controller. Second, @ControllerAdvice creates a global exception handler for all controllers. You can use @ResponseStatus to specify HTTP status codes for exceptions. Third, implement ResponseEntityExceptionHandler for more control over error responses. Fourth, create custom exception classes and handle them specifically. For REST APIs, I typically use @ControllerAdvice with @ExceptionHandler methods that return ResponseEntity with proper status codes and error messages in a consistent format.

**\#. What is ResponseEntity and when do you use it?**

ResponseEntity represents the entire HTTP response including status code, headers, and body. It gives you full control over the response. You'd use it when you need to customize the HTTP status code or add headers. For example, ResponseEntity.ok(user) returns 200 with user object, ResponseEntity.notFound().build() returns 404, ResponseEntity.created(uri).body(user) returns 201 with location header. Without ResponseEntity, Spring uses default status codes. It's especially useful in REST APIs where proper HTTP semantics matter.

**\#. Explain the difference between @Component and @Configuration.**

@Component is a generic stereotype annotation marking a class as a Spring bean. The class itself becomes a bean. @Configuration is a specialized @Component that indicates the class contains @Bean methods \- it's a source of bean definitions. Methods annotated with @Bean in a @Configuration class return objects that Spring registers as beans. The key difference is @Configuration classes are processed specially \- they use CGLIB proxying to ensure @Bean methods return the same singleton instance when called multiple times. Use @Configuration for defining beans, @Component for regular managed classes.

**\#. What is the difference between @Controller and @RestController?**

@Controller is used to mark a class as a Spring MVC controller. It typically returns a view name, and data can be passed to the view using a Model object. To return data directly (like JSON), you need to annotate handler methods with @ResponseBody.

@RestController is a convenience annotation that combines @Controller and @ResponseBody. It's designed for RESTful web services where every method returns a domain object instead of a view. It eliminates the need to put @ResponseBody on every method.

## Spring Data JPA

**\#. What is Spring Data JPA?**

Spring Data JPA is a part of Spring Data that makes it easy to implement JPA-based repositories. It reduces boilerplate code by providing repository interfaces with built-in methods for common database operations. You just define an interface extending JpaRepository or CrudRepository, and Spring automatically implements it at runtime. It provides query derivation from method names, @Query for custom queries, pagination, sorting, and auditing features. It sits on top of JPA implementations like Hibernate, simplifying data access layer development significantly.

**\#. Explain the repository hierarchy in Spring Data JPA.**

The hierarchy starts with Repository as the marker interface. CrudRepository extends it and provides CRUD methods like save, findById, delete, etc. PagingAndSortingRepository extends CrudRepository adding pagination and sorting capabilities. JpaRepository extends PagingAndSortingRepository adding JPA-specific methods like flush, saveAndFlush, deleteInBatch, etc. For most cases, extending JpaRepository is sufficient as it provides all functionality. You can also extend Repository directly and selectively expose only needed methods for a minimal interface.

**\#. What is the @Entity annotation?**

@Entity marks a class as a JPA entity, meaning it will be mapped to a database table. The class should have a no-argument constructor and should not be final. By default, the table name is the class name, but you can customize it with @Table(name="custom\_name"). Each entity must have a primary key marked with @Id. Fields become columns by default, but you can customize with @Column. Entities support relationships with @OneToOne, @OneToMany, @ManyToOne, @ManyToMany. The entity's lifecycle is managed by the EntityManager.

**\#. Explain @Id and different ID generation strategies.**

@Id marks a field as the primary key. For ID generation, you use @GeneratedValue with different strategies. GenerationType.AUTO lets JPA choose the strategy \- it's database-independent. GenerationType.IDENTITY uses database auto-increment \- good for MySQL but doesn't work with batch inserts. GenerationType.SEQUENCE uses database sequences \- good for PostgreSQL and Oracle, supports batch inserts. GenerationType.TABLE uses a separate table to generate IDs \- database-independent but less efficient. You can also use @SequenceGenerator or @TableGenerator for more control. IDENTITY is simplest for single inserts, SEQUENCE is better for performance.

**\#. What are the different types of relationships in JPA?**

JPA supports four relationship types. @OneToOne where one entity is associated with one other entity, like User and UserProfile. @OneToMany where one entity is associated with many others, like Department and Employees. @ManyToOne is the inverse of OneToMany, like many Employees belong to one Department. @ManyToMany where entities on both sides can be associated with multiple entities on the other side, like Students and Courses with a junction table. Each can be unidirectional or bidirectional, and you specify ownership with mappedBy attribute.

**\#. Explain bidirectional relationships and mappedBy.**

A bidirectional relationship has references on both sides \- both entities know about each other. For example, Department has a list of Employees, and Employee has a reference to Department. Only one side can be the owner of the relationship \- the side that doesn't have mappedBy. The mappedBy attribute goes on the inverse side and references the field name on the owning side. For OneToMany/ManyToOne, the Many side is typically the owner because that's where the foreign key exists. The owner side controls the relationship persistence.

**\#. What is cascading in JPA?**

Cascading defines which operations should be propagated from parent to child entities. You specify it with cascade attribute in relationship annotations. CascadeType.PERSIST means when you save the parent, children are saved too. CascadeType.MERGE propagates updates. CascadeType.REMOVE deletes children when parent is deleted. CascadeType.REFRESH reloads children with parent. CascadeType.DETACH detaches children. CascadeType.ALL applies all types. Use cascading carefully \- especially REMOVE can delete more data than intended. It's useful for managing related entities together.

**\#. Explain fetch types \- LAZY vs EAGER.**

FetchType determines when related entities are loaded. EAGER loads the association immediately with the parent entity \- data is available right away. LAZY loads the association only when explicitly accessed \- improves performance by avoiding unnecessary queries. For example, with @OneToMany(fetch \= FetchType.LAZY), the collection isn't loaded until you call a method on it. LAZY is default for \*ToMany relationships, EAGER for \*ToOne. I prefer LAZY for most cases to avoid N+1 query problems and use JOIN FETCH in queries when needed.

**\#. What is the N+1 query problem and how do you solve it?**

The N+1 problem occurs with LAZY loading when you query N parent entities, and each access to a child collection triggers an additional query \- resulting in 1 \+ N queries total. For example, fetching 10 departments and then accessing each one's employees causes 11 queries. Solutions include using JOIN FETCH in JPQL to load associations in one query, using @EntityGraph to define fetch plans, using batch fetching with @BatchSize, or switching to EAGER (though this has other issues). JOIN FETCH is usually the best solution.

**\#. What is @Query annotation?**

@Query lets you write custom JPQL or native SQL queries on repository methods. For example, @Query("SELECT u FROM User u WHERE u.email \= ?1") User findByEmail(String email). You can use named parameters with :paramName or positional parameters with ?1, ?2. Add nativeQuery=true for SQL instead of JPQL. It's useful when query derivation from method name becomes too complex or when you need optimization. You can also use @Modifying with @Query for UPDATE or DELETE queries, and you must mark the method or class with @Transactional.

**\#. Explain query methods and naming conventions.**

Spring Data JPA can derive queries from method names following conventions. Start with find, get, or query, followed by By, then property names with conditions. For example, findByLastName(String lastName), findByAgeGreaterThan(int age), findByFirstNameAndLastName(String first, String last). Keywords include LessThan, GreaterThan, Between, Like, In, IsNull, OrderBy, etc. You can combine multiple properties with And/Or. It's concise for simple queries. For complex queries, use @Query instead. The method name must follow specific patterns, or it won't work.

**\#. What is the difference between CrudRepository and JpaRepository?**

CrudRepository provides basic CRUD operations like save, findById, findAll, delete, count, etc. JpaRepository extends it and adds JPA-specific and pagination functionality. Additional methods include flush to synchronize with database, saveAndFlush for saving and flushing immediately, deleteInBatch for batch deletion, getOne for lazy loading by ID. JpaRepository also extends PagingAndSortingRepository, so it has pagination and sorting. For most Spring Boot applications, JpaRepository is the better choice because it provides more functionality out of the box.

**\#. How do you implement pagination and sorting?**

For pagination, use PagingAndSortingRepository or JpaRepository and pass Pageable parameter to methods. Create Pageable using PageRequest.of(pageNumber, pageSize) or with sorting: PageRequest.of(page, size, Sort.by("fieldName")). Methods return Page or Slice objects containing the results and metadata. For sorting alone, pass Sort parameter: Sort.by("lastName").ascending(). In REST APIs, you can use @PageableDefault for default values. Pagination reduces memory usage and improves response time for large datasets. Spring also provides page navigation information out of the box.

**\#. What is @Transactional annotation?**

@Transactional manages transactions declaratively. It ensures that database operations within the method execute in a transaction \- either all succeed or all fail. You can use it at class level for all methods or method level for specific methods. Attributes include propagation for transaction propagation behavior, isolation for isolation level, readOnly for optimization on read-only operations, timeout for transaction timeout, and rollbackFor to specify which exceptions trigger rollback. By default, it rolls back on RuntimeException but not checked exceptions. Service layer methods typically use @Transactional.

**\#. Explain transaction propagation types.**

Propagation defines how transactions relate to each other. REQUIRED (default) joins the existing transaction or creates new one if none exists. REQUIRES\_NEW always creates a new transaction, suspending the existing one. MANDATORY requires an existing transaction or throws exception. SUPPORTS joins if transaction exists, executes non-transactionally otherwise. NOT\_SUPPORTED always executes non-transactionally, suspending existing transaction. NEVER executes non-transactionally and throws exception if transaction exists. NESTED creates a nested transaction within existing transaction. Most commonly, you'd use REQUIRED for normal cases and REQUIRES\_NEW when you need independent transactions.

## Spring MVC & Web

**\#. Explain the Spring MVC architecture.**

Spring MVC follows the Model-View-Controller pattern. When a request comes in, the DispatcherServlet (front controller) receives it. It consults HandlerMapping to find the appropriate controller. The controller processes the request, interacts with the service layer and model, and returns a ModelAndView or data. For REST APIs, @ResponseBody serializes the result to JSON. For traditional MVC, ViewResolver resolves the view name to an actual view template. The view renders with the model data and returns the response. This separation of concerns makes the application maintainable and testable.

**\#. What is DispatcherServlet?**

DispatcherServlet is the front controller in Spring MVC that handles all incoming HTTP requests. It's the entry point for the web application. When a request arrives, DispatcherServlet delegates to HandlerMapping to determine which controller should handle it, calls the controller, processes the result, and sends the response. In Spring Boot, DispatcherServlet is auto-configured and mapped to / by default. You rarely need to configure it manually. It centralizes request handling and coordinates between different components like controllers, view resolvers, and interceptors.

**\#. What are interceptors in Spring?**

Interceptors are similar to servlet filters but are Spring-specific and more powerful. They intercept requests before they reach the controller (preHandle), after handler execution but before view rendering (postHandle), and after completion (afterCompletion). You implement HandlerInterceptor or extend HandlerInterceptorAdapter. Use cases include logging, authentication checks, performance monitoring, and modifying request/response. You register them in WebMvcConfigurer's addInterceptors method. Unlike filters that work at servlet level, interceptors work at Spring MVC level and have access to handler and model.

**\#. What is CORS and how do you enable it in Spring Boot?**

CORS (Cross-Origin Resource Sharing) is a security feature that controls how web pages from one domain can access resources from another domain. Browsers block cross-origin requests by default for security. To enable CORS in Spring Boot, you can use @CrossOrigin annotation on controllers or specific methods, specifying allowed origins, methods, and headers. For global configuration, implement WebMvcConfigurer and override addCorsMappings method. You can configure allowed origins, methods, headers, credentials, and max age. Proper CORS configuration is essential for SPAs accessing your API from different domains.

**\#. Explain content negotiation in Spring.**

Content negotiation allows the same URL to return different representations based on the client's preference. Spring MVC supports negotiation based on Accept header, URL path extension, or query parameter. For example, /api/users with Accept: application/json returns JSON, while Accept: application/xml returns XML. Spring uses HttpMessageConverters to handle serialization \- Jackson for JSON, JAXB for XML. You can customize content negotiation in WebMvcConfigurer. It's useful for APIs that need to support multiple formats or versions.

**\#. What is @ControllerAdvice?**

@ControllerAdvice is a specialization of @Component for global exception handling and model attribute population. Methods in @ControllerAdvice classes apply to all controllers or specific ones using attributes like basePackages or annotations. You use @ExceptionHandler methods to handle exceptions globally instead of in each controller. You can use @ModelAttribute to add attributes to the model for all requests. @InitBinder configures data binding globally. It's essential for consistent error handling across your application and reducing code duplication.

**\#. How do you validate request data in Spring?**

Spring supports JSR-303/JSR-380 Bean Validation. First, add validation starter dependency. Then annotate entity fields with constraints like @NotNull, @NotEmpty, @Email, @Min, @Max, @Pattern, etc. In controller methods, use @Valid or @Validated on @RequestBody or method parameters. Spring validates the object and throws MethodArgumentNotValidException if validation fails. You handle this in @ControllerAdvice to return appropriate error responses. You can create custom validators by implementing ConstraintValidator. Validation ensures data integrity and provides clear error messages to clients.

**\#. What is @Validated vs @Valid?**

@Valid is from JSR-303 standard and triggers validation on the annotated element. @Validated is Spring-specific and extends @Valid with additional features. Both trigger validation, but @Validated supports validation groups \- you can define different validation rules for different scenarios. For example, have different validations for create vs update operations by defining groups and specifying them with @Validated(CreateGroup.class). @Validated can be used at class level, while @Valid is typically on method parameters. For simple validation, @Valid is sufficient. Use @Validated for complex scenarios requiring groups.

**\#. Explain file upload in Spring Boot.**

To handle file uploads, use MultipartFile as a parameter in your controller method. Annotate it with @RequestParam or @RequestPart. For example: @PostMapping("/upload") public String upload(@RequestParam("file") MultipartFile file). Configure multipart properties like max file size and request size in application.properties with spring.servlet.multipart.max-file-size and max-request-size. You can then save the file using file.transferTo(destination) or process it as needed. For multiple files, use MultipartFile\[\]. Spring Boot auto-configures multipart support using Apache Commons FileUpload or Servlet 3.0.

**\#. How do you implement file download in Spring Boot?**

For file download, return ResponseEntity with InputStreamResource or ByteArrayResource. Set Content-Disposition header to "attachment; filename=..." to trigger download. Set Content-Type appropriately based on file type. For example: HttpHeaders headers \= new HttpHeaders(); headers.add("Content-Disposition", "attachment; filename=file.pdf"); return ResponseEntity.ok().headers(headers).contentType(MediaType.APPLICATION\_PDF).body(resource). For large files, use InputStreamResource for streaming instead of loading entire file in memory. This approach works well for serving files from database or file system.

**\#. What is Spring Boot DevTools?**

DevTools provides features that improve development experience. Key features include automatic restart when code changes (faster than full restart), LiveReload to refresh browser automatically, property defaults optimized for development like disabling template caching, and remote development tools. It's automatically disabled in production. To use it, just add spring-boot-devtools dependency. The automatic restart feature monitors classpath changes and restarts only the application context, not the JVM, making it much faster. It significantly speeds up the development cycle by eliminating manual restarts.

**\#. Explain different ways to configure Spring Boot applications.**

Spring Boot supports multiple configuration sources with precedence order. From highest to lowest: command-line arguments, Java system properties, OS environment variables, application-{profile}.properties from outside jar, application-{profile}.properties inside jar, application.properties outside jar, application.properties inside jar, and @PropertySource annotations. You can also use YAML files. For sensitive data, use environment variables or external property files. For different environments, use profiles with application-dev.properties, application-prod.properties. This flexibility allows easy configuration management across environments without code changes.

**\#. What are Spring profiles?**

Profiles allow you to segregate application configuration and make it available only in certain environments. You define beans or properties for specific profiles using @Profile annotation or profile-specific property files like application-dev.properties. Activate profiles using spring.profiles.active property through command line, environment variable, or application.properties. You can have multiple active profiles. Use cases include different database configurations for dev/test/prod, feature flags, or environment-specific beans. Profiles make it easy to maintain different configurations without changing code.

**\#. How do you externalize configuration in Spring Boot?**

Externalization means keeping configuration outside your code. Spring Boot supports several approaches: property files (application.properties/yml) in various locations, environment variables, command-line arguments, cloud config servers, and YAML files. For sensitive data like passwords, use environment variables or external vaults. Use @Value for simple properties or @ConfigurationProperties for type-safe hierarchical properties bound to POJOs. Spring Cloud Config Server can centralize configuration for microservices. Externalization enables changing configuration without rebuilding, important for different environments and operational flexibility.

**\#. What is @ConfigurationProperties?**

@ConfigurationProperties binds external properties to a strongly-typed bean. Instead of multiple @Value annotations, you create a class with fields matching property names and annotate it with @ConfigurationProperties(prefix="app"). Enable it with @EnableConfigurationProperties or @ConfigurationPropertiesScan. For example, properties like app.name, app.version bind to fields name and version. Benefits include type safety, validation support with JSR-303 annotations, IDE auto-completion, and better organization. It's the preferred way for complex hierarchical configuration. You can inject this bean anywhere you need the configuration.

## Spring Security

**\#. What is Spring Security?**

Spring Security is a powerful and highly customizable authentication and authorization framework. It provides comprehensive security services for Java applications, especially Spring-based ones. It handles authentication (verifying who you are), authorization (verifying what you can do), and protection against common attacks like CSRF, session fixation, clickjacking, etc. Spring Security is implemented using servlet filters. In Spring Boot, adding spring-boot-starter-security dependency auto-configures basic security with form-based login and HTTP basic authentication. You customize it by extending WebSecurityConfigurerAdapter or using SecurityFilterChain beans.

**\#. Explain authentication vs authorization.**

Authentication is verifying the identity of a user \- confirming who they claim to be. It typically involves credentials like username/password, tokens, or certificates. Once authenticated, you know who the user is. Authorization is verifying what an authenticated user is allowed to do \- checking permissions and roles. For example, authentication confirms you're user "john", authorization determines if "john" can access admin resources. Authentication happens first, then authorization. In Spring Security, authentication is handled by AuthenticationManager, authorization by AccessDecisionManager or method security annotations.

**\#. How does Spring Security work internally?**

Spring Security uses a chain of servlet filters. When a request comes in, it passes through multiple filters like SecurityContextPersistenceFilter (restores authentication from session), UsernamePasswordAuthenticationFilter (processes login), ExceptionTranslationFilter (handles security exceptions), and FilterSecurityInterceptor (enforces authorization rules). The SecurityContextHolder stores the current authentication. When you log in, an Authentication object is created, validated by AuthenticationManager using AuthenticationProviders, and stored in SecurityContext. For subsequent requests, authentication is retrieved from session and available via SecurityContextHolder throughout the request.

**\#. What is UserDetailsService?**

UserDetailsService is an interface with one method: loadUserByUsername(String username). It's used to retrieve user-related data during authentication. You implement it to load user details from your database or other source. It returns a UserDetails object containing username, password, and authorities (roles/permissions). Spring Security uses this to verify credentials during login. For example, you might inject UserRepository and query the database. It separates user loading logic from authentication logic. In Spring Boot, you provide a bean implementing UserDetailsService, and Spring Security automatically uses it.

**\#. Explain password encoding in Spring Security.**

Spring Security requires passwords to be encoded for security. The PasswordEncoder interface handles encoding and matching. Common implementations include BCryptPasswordEncoder (recommended \- uses bcrypt hashing with salt), Pbkdf2PasswordEncoder, SCryptPasswordEncoder, and the deprecated StandardPasswordEncoder. You define a PasswordEncoder bean, and Spring Security uses it to encode passwords during registration and verify them during login. Never store plain text passwords. BCrypt is preferred because it's slow (making brute force attacks harder) and automatically handles salts. You can configure strength factor to balance security and performance.

**\#. What is JWT and how do you implement it in Spring Boot?**

JWT (JSON Web Token) is a compact, self-contained way to securely transmit information between parties as a JSON object. It's commonly used for stateless authentication in REST APIs. A JWT has three parts: header (algorithm and type), payload (claims like user ID and expiration), and signature. In Spring Boot, you'd create a filter that intercepts requests, extracts and validates the JWT from the Authorization header, and sets authentication in SecurityContext. You use libraries like jjwt to create and parse JWTs. When a user logs in, you return a JWT. For subsequent requests, the client sends the JWT, and you validate it without database lookup, making it stateless.

**\#. Explain method-level security.**

Method-level security secures individual methods using annotations. First, enable it with @EnableMethodSecurity (Spring Security 6+) or @EnableGlobalMethodSecurity (earlier versions). Then use annotations like @PreAuthorize before method execution, @PostAuthorize after execution, @Secured for simple role checks, or @RolesAllowed (JSR-250). For example: @PreAuthorize("hasRole('ADMIN')") or @PreAuthorize("\#username \== authentication.principal.username") for more complex expressions using SpEL. It's more flexible than URL-based security because you can secure at service layer and use complex conditions. It's useful for fine-grained authorization control.

**\#. What is @PreAuthorize and @PostAuthorize?**

@PreAuthorize evaluates an expression before method execution \- if false, the method isn't called and AccessDeniedException is thrown. For example: @PreAuthorize("hasRole('ADMIN')") or @PreAuthorize("@securityService.canAccess(\#id, authentication)"). @PostAuthorize evaluates after method execution and can access the return value with "returnObject". For example: @PostAuthorize("returnObject.owner \== authentication.principal.username"). PreAuthorize is more common for checking permissions before operation. PostAuthorize is useful when permission depends on the result. Both use SpEL expressions, giving great flexibility for complex authorization logic.

**\#. How do you implement CORS and CSRF in Spring Security?**

For CORS, configure it in security configuration: http.cors().configurationSource(request \-\> corsConfig) where corsConfig defines allowed origins, methods, headers. Or use @CrossOrigin on controllers. For production, be specific about allowed origins rather than "\*". For CSRF (Cross-Site Request Forgery), Spring Security enables it by default for session-based authentication. It requires a CSRF token for state-changing operations. For REST APIs with JWT (stateless), disable CSRF with http.csrf().disable() since there's no session. For traditional web apps with sessions, keep CSRF enabled and include the token in forms or AJAX requests.

**\#. What is SecurityContextHolder?**

SecurityContextHolder stores the security context of the current thread. It contains the Authentication object representing the currently authenticated user. You access it using SecurityContextHolder.getContext().getAuthentication(). From Authentication, you can get the principal (usually UserDetails), credentials, and authorities. By default, it uses ThreadLocal storage, so each thread has its own security context. This is how Spring Security makes authentication available throughout the request processing. When a request completes, the security context is cleared. In async methods or new threads, you need to manually propagate the security context.

**\#. Explain OAuth2 and how Spring Security supports it.**

OAuth2 is an authorization framework that enables applications to obtain limited access to user accounts on another service. It defines roles: Resource Owner (user), Client (your app), Authorization Server (issues tokens), and Resource Server (hosts protected resources). Spring Security OAuth2 supports both authorization server and resource server implementations. As a client, Spring Security simplifies OAuth2 login with providers like Google or GitHub. As a resource server, it validates JWT tokens from authorization servers. In Spring Boot, you configure OAuth2 in application.properties with client registration details. It's the standard for secure delegated access.

**\#. What is the difference between @Secured and @PreAuthorize?**

@Secured is a simpler annotation that only checks roles. It doesn't support SpEL expressions. For example: @Secured("ROLE\_ADMIN") or @Secured({"ROLE\_ADMIN", "ROLE\_USER"}) for multiple roles. @PreAuthorize is more powerful \- it supports SpEL expressions, allowing complex conditions. You can combine multiple conditions, access method parameters, call custom security methods, etc. For example: @PreAuthorize("hasRole('ADMIN') and \#user.age \>= 18"). PreAuthorize is preferred because of its flexibility. Use @Secured only if you have simple role checks and want JSR-250 compliance.

**\#. How do you customize the login page in Spring Security?**

By default, Spring Security generates a login page. To customize, configure it in SecurityFilterChain: http.formLogin().loginPage("/custom-login").loginProcessingUrl("/authenticate").defaultSuccessUrl("/dashboard").failureUrl("/login?error=true"). Create a controller mapping for "/custom-login" returning your custom view. In your HTML, create a form posting to loginProcessingUrl with username and password fields. You can also customize by implementing AuthenticationSuccessHandler for complex post-login logic or AuthenticationFailureHandler for custom error handling. For REST APIs, you might disable form login entirely and use JWT or OAuth2 instead.

**\#. Explain remember-me functionality.**

Remember-me allows users to be authenticated automatically across sessions. Spring Security supports two implementations: simple hash-based (cookie contains username, expiration time, and hash) and persistent token-based (more secure, uses database to store tokens). Configure with http.rememberMe().key("uniqueKey").tokenValiditySeconds(604800). The default uses UserDetailsService to reload user details. When enabled, a remember-me cookie is set after successful login if the user checks the remember-me option. On subsequent visits, if the session expires but the cookie is valid, the user is automatically authenticated. Be cautious with security implications \- use persistent tokens and HTTPS in production.

**\#. What are Spring Security filters?**

Spring Security uses a filter chain to process security. Key filters include SecurityContextPersistenceFilter (loads/stores security context from session), LogoutFilter (handles logout), UsernamePasswordAuthenticationFilter (processes login form submissions), BasicAuthenticationFilter (processes HTTP basic authentication), ExceptionTranslationFilter (handles security exceptions), and FilterSecurityInterceptor (enforces authorization rules). You can add custom filters using http.addFilterBefore(), addFilterAfter(), or addFilterAt(). Understanding filter order is important \- authentication filters come before authorization filters. The filter chain is configured through SecurityFilterChain beans, giving complete control over security processing.

## Spring Boot Testing

**\#. How do you test Spring Boot applications?**

Spring Boot provides excellent testing support. Use spring-boot-starter-test which includes JUnit, Mockito, AssertJ, Hamcrest, and Spring Test. For unit tests, use JUnit with Mockito for mocking dependencies \- no Spring context needed. For integration tests, use @SpringBootTest to load full application context. @WebMvcTest loads only web layer for controller tests. @DataJpaTest loads only JPA components for repository tests. @MockBean replaces beans with mocks in context. TestRestTemplate or MockMvc for testing REST endpoints. Write unit tests for business logic, integration tests for workflows, and end-to-end tests for critical paths.

**\#. What is @SpringBootTest?**

@SpringBootTest loads the complete Spring application context for integration testing. It starts the embedded server by default (can be disabled with webEnvironment). Use it when you need to test interactions between components or full application behavior. You can inject any bean and test them together. It's slower than unit tests because it loads the full context. You can customize the test by providing specific configuration classes or properties. Use it for integration tests but avoid for simple unit tests. Combine with @AutoConfigureMockMvc for MockMvc injection or with @TestRestTemplate for REST API testing.

**\#. Explain @WebMvcTest.**

@WebMvcTest is a sliced test annotation that loads only the web layer \- controllers, @ControllerAdvice, filters, interceptors, etc. It doesn't load service or repository layers, making tests fast. Use @MockBean to mock dependencies like services. It auto-configures MockMvc which you inject to test controllers. For example: mockMvc.perform(get("/users/1")).andExpect(status().isOk()).andExpect(jsonPath("$.name").value("John")). It's perfect for testing controller logic, request mapping, validation, and exception handling without loading the entire application. Much faster than @SpringBootTest for controller tests.

**\#. What is @DataJpaTest?**

@DataJpaTest is a sliced test for JPA repositories. It loads only JPA components like entities, repositories, and EntityManager. It configures an in-memory database by default (like H2), enables Hibernate logging, and disables auto-configuration of non-JPA components. It's transactional \- each test rolls back by default. Use it to test repository methods, custom queries, and database interactions. For example, test that a custom findByEmail method works correctly. You can inject TestEntityManager for test data setup. It's much faster than full context tests and focuses on data access layer.

**\#. How do you mock dependencies in tests?**

Use Mockito for mocking. In Spring Boot tests, use @MockBean to replace a Spring bean with a mock in the application context. For pure unit tests without Spring, use @Mock or Mockito.mock(). Define behavior with when().thenReturn(). For example: when(userService.findById(1L)).thenReturn(user). Verify method calls with verify(). Use @InjectMocks to inject mocks into the tested object. ArgumentCaptor captures arguments passed to mocked methods. For partial mocking, use @Spy. Mocking isolates the unit under test from dependencies, making tests faster and more focused. Always mock external dependencies like databases or REST clients.

**\#. What is MockMvc?**

MockMvc provides a powerful way to test Spring MVC controllers without starting a real HTTP server. You perform requests and assert on responses. For example: mockMvc.perform(get("/api/users")).andExpect(status().isOk()).andExpect(content().contentType(MediaType.APPLICATION\_JSON)).andExpect(jsonPath("$\[0\].name").value("John")). You can test all aspects: status codes, headers, body content, and more. It supports all HTTP methods, request parameters, headers, and content. Use it with @WebMvcTest or @AutoConfigureMockMvc. It's faster than actual HTTP requests and provides detailed assertions. Essential for controller testing.

**\#. How do you test REST APIs in Spring Boot?**

For testing REST APIs, use TestRestTemplate or RestAssured. TestRestTemplate is provided by Spring Boot and works well with @SpringBootTest. You make actual HTTP calls: ResponseEntity\<User\> response \= restTemplate.getForEntity("/api/users/1", User.class). Assert on status, headers, and body. RestAssured provides a more fluent API: given().when().get("/api/users/1").then().statusCode(200).body("name", equalTo("John")). For unit-level controller testing, use MockMvc with @WebMvcTest. For integration testing with full context, use TestRestTemplate. Always test different scenarios: success cases, validation errors, not found, unauthorized, etc.

**\#. What is @TestConfiguration?**

@TestConfiguration is used to define additional beans or override existing beans specifically for tests. It's not picked up by component scanning but must be imported explicitly or used as a nested class within a test. Use it when you need test-specific beans or want to customize auto-configuration for tests. For example, you might provide a different DataSource configuration or mock certain beans. It's useful for sharing test configuration across multiple test classes. Unlike @Configuration, @TestConfiguration won't be picked up by production component scanning, keeping test configuration isolated.

**\#. How do you test asynchronous code?**

For testing @Async methods, first make sure async is enabled with @EnableAsync in test configuration. The method should run on a separate thread. Use CompletableFuture or similar to wait for results. For example: CompletableFuture\<String\> future \= service.asyncMethod(); String result \= future.get(5, TimeUnit.SECONDS). You can use await() from Awaitility library for cleaner syntax. For testing scheduled tasks, use @Scheduled, trigger them manually in tests, or use a testing scheduler. Mock the AsyncExecutor if needed. Testing async code is tricky \- ensure you wait for completion and handle timeouts properly to avoid flaky tests.

**\#. What are test slices in Spring Boot?**

Test slices are pre-configured annotations that load only a portion of the application context, making tests faster and more focused. Common slices include @WebMvcTest (web layer), @DataJpaTest (JPA layer), @RestClientTest (REST clients), @JsonTest (JSON serialization), @WebFluxTest (reactive web layer), @JdbcTest (JDBC), and @DataMongoTest (MongoDB). Each loads only relevant components and auto-configures appropriate tools like MockMvc or TestEntityManager. Use slices instead of @SpringBootTest when testing specific layers. They reduce context loading time and prevent test interference. Combine with mocks for dependencies outside the slice.

## Spring Boot Advanced Topics

**\#. What is Spring Boot caching?**

Spring Boot provides caching abstraction that works with various cache providers. Enable it with @EnableCaching and annotate methods with @Cacheable (caches return value), @CachePut (updates cache), @CacheEvict (removes from cache), or @Caching (combines multiple operations). Specify cache names and keys. For example: @Cacheable(value="users", key="\#id"). By default, it uses ConcurrentHashMap. For production, use Redis, EhCache, or Hazelcast by adding their dependencies \- Spring Boot auto-configures them. Caching improves performance by avoiding repeated expensive operations like database queries or API calls. Configure TTL and eviction policies based on requirements.

**\#. Explain Spring Boot events.**

Spring provides an event-driven programming model. You can publish and listen to application events. Define custom events extending ApplicationEvent, publish them using ApplicationEventPublisher.publishEvent(), and listen with @EventListener methods. Spring Boot has built-in events like ApplicationReadyEvent, ApplicationStartedEvent, ApplicationFailedEvent. Events enable loose coupling \- publishers don't know about listeners. Listeners execute in the same thread by default, but you can make them async with @Async. Use events for cross-cutting concerns, decoupling modules, or notifications. They're useful for auditing, notifications, or triggering workflows without tight coupling.

**\#. What is Spring Boot Validation and Bean Validation?**

Bean Validation (JSR-303/380) provides constraint annotations to validate data. Common constraints: @NotNull, @NotEmpty, @NotBlank, @Size, @Min, @Max, @Email, @Pattern, @Past, @Future. Apply them to entity fields or method parameters. In Spring Boot, trigger validation with @Valid or @Validated. Create custom validators by implementing ConstraintValidator. Validation messages can be customized in messages.properties. Spring Boot automatically configures the validator if javax.validation dependency is present. Validation happens before method execution, and ConstraintViolationException is thrown if invalid. Use @ControllerAdvice to handle validation exceptions globally and return proper error responses.

**\#. How do you implement scheduling in Spring Boot?**

Enable scheduling with @EnableScheduling on a configuration class. Annotate methods with @Scheduled for periodic execution. Options include fixedRate (executes every N milliseconds regardless of previous execution), fixedDelay (waits N milliseconds after previous completion), cron (uses cron expression for complex scheduling), and initialDelay. For example: @Scheduled(cron="0 0 2 \* \* ?") runs daily at 2 AM. By default, scheduled tasks run on a single thread. For parallel execution, configure a TaskScheduler bean with thread pool. Use it for batch jobs, data cleanup, sending reports, cache refreshing, etc. Monitor scheduled tasks and handle exceptions properly.

**\#. What is Spring Boot Actuator and its important endpoints?**

Actuator provides production-ready features for monitoring and managing applications. Important endpoints include /actuator/health for health status (can be customized with health indicators), /actuator/metrics for various metrics, /actuator/info for custom application info, /actuator/env for environment properties, /actuator/loggers for viewing/changing log levels at runtime, /actuator/httptrace for recent HTTP requests, /actuator/threaddump for thread information, /actuator/heapdump for heap dump. Most are disabled by default for security. Enable them in application.properties with management.endpoints.web.exposure.include. Secure endpoints with Spring Security. Essential for production monitoring.

**\#. How do you implement health checks?**

Spring Boot Actuator provides the /actuator/health endpoint. By default, it shows basic status. Implement custom health indicators by extending AbstractHealthIndicator or implementing HealthIndicator. Override doHealthCheck() method to check specific component health like database, external API, disk space, etc. Return Health.up() or Health.down() with details. Configure health endpoint with management.endpoint.health properties. You can aggregate health from multiple indicators. Health status can be UP, DOWN, OUT\_OF\_SERVICE, or UNKNOWN. Load balancers and monitoring systems use this endpoint to determine if the instance should receive traffic. It's critical for production deployments.

**\#. Explain Spring Boot properties binding.**

Spring Boot binds external properties to Java objects using @ConfigurationProperties. Properties are bound by name \- nested properties map to object hierarchies. For example, app.name and app.version bind to fields in an @ConfigurationProperties(prefix="app") class. Supports relaxed binding \- app.my-property, app.myProperty, and APP\_MY\_PROPERTY all map to myProperty field. Supports JSR-303 validation. Lists and maps are supported. Use constructor binding with @ConstructorBinding for immutable configuration objects. Enable with @EnableConfigurationProperties. It's type-safe, IDE-friendly with auto-completion, and encourages well-organized configuration. Preferred over @Value for complex configuration.

**\#. What is Spring Boot Logging?**

Spring Boot uses Commons Logging for internal logging but supports various logging frameworks. Default is Logback with slf4j API. Configure logging in application.properties: logging.level.root=INFO, logging.level.com.myapp=DEBUG sets levels. logging.file.name specifies log file. logging.pattern.console customizes log format. You can use different logging frameworks by excluding spring-boot-starter-logging and including the desired starter. Use logger in code: Logger logger \= LoggerFactory.getLogger(MyClass.class); logger.info("Message"). Configure Logback with logback-spring.xml for advanced configuration like rolling files, different appenders, or profile-specific configuration. Proper logging is essential for troubleshooting production issues.

**\#. How do you handle application properties encryption?**

For sensitive data like passwords, don't store plain text. Options include environment variables \- reference them in properties with ${ENV\_VAR}. Use Spring Cloud Config Server with encryption support \- encrypt values with {cipher} prefix. Use Jasypt Spring Boot for encryption within application.properties. Use external secret management like HashiCorp Vault, AWS Secrets Manager, or Azure Key Vault \- Spring Cloud provides integrations. Use config files outside the jar with restricted permissions. In Kubernetes, use Secrets. Never commit sensitive data to version control. Production systems should use proper secret management solutions rather than encrypted properties.

**\#. Explain Spring Boot custom banner.**

The banner is the ASCII art displayed when Spring Boot starts. Customize it by adding banner.txt in resources directory. You can use placeholders like ${application.version}, ${spring-boot.version}, ${application.formatted-version}. Disable with spring.main.banner-mode=off. Change location with spring.banner.location. You can also programmatically set a banner using SpringApplication.setBanner(). You can use colors with AnsiOutput if the console supports it. For image banners, use banner.gif, banner.jpg, or banner.png. While fun, custom banners should be kept simple in production to avoid cluttering logs.

**\#. What are Spring Boot conditional annotations?**

Spring Boot provides conditional annotations to conditionally create beans based on various criteria. @ConditionalOnClass creates bean only if specified class is present. @ConditionalOnMissingBean creates bean only if no bean of type exists. @ConditionalOnProperty creates bean based on property value. @ConditionalOnWebApplication creates bean only in web applications. @ConditionalOnExpression evaluates SpEL expression. These enable auto-configuration magic \- beans are created only when appropriate. You can create custom conditions by implementing Condition interface. They're essential for creating flexible, reusable configuration and libraries that adapt to the environment.

**\#. How do you implement internationalization (i18n)?**

Spring Boot supports internationalization through MessageSource. Create properties files like messages.properties, messages\_fr.properties, messages\_es.properties in resources. In controllers, inject MessageSource and call getMessage(key, args, locale). For web applications, configure LocaleResolver to determine user locale from Accept-Language header, cookie, or session. Use LocaleChangeInterceptor to change locale via request parameter. In Thymeleaf templates, use \#{key} syntax. For REST APIs, check Accept-Language header in @ControllerAdvice and resolve locale. Store translated messages in properties files. Support for multiple locales makes applications accessible to global users.

**\#. What is Spring Boot WebSocket support?**

Spring Boot provides WebSocket support for full-duplex communication between client and server. Enable with @EnableWebSocket and configure endpoints. Implement WebSocketHandler or use STOMP over WebSocket for higher-level messaging. Configure with WebSocketConfigurer: registry.addHandler(handler, "/ws"). For STOMP, use @EnableWebSocketMessageBroker and @MessageMapping for handling messages, @SendTo for broadcasting. WebSockets maintain persistent connection, enabling real-time features like chat, notifications, live updates, collaborative editing. Useful when you need server to push data to clients. For simpler use cases, consider Server-Sent Events or polling.

**\#. Explain Spring Boot async processing.**

Enable async processing with @EnableAsync. Annotate methods with @Async to run them asynchronously. Methods can return void, Future, CompletableFuture, or ListenableFuture. Configure executor with AsyncConfigurer: @Override public Executor getAsyncExecutor() { return new ThreadPoolTaskExecutor(); }. Customize pool size, queue capacity, thread name prefix. Handle exceptions with AsyncUncaughtExceptionHandler. Async processing improves responsiveness \- user doesn't wait for long operations. Use for sending emails, generating reports, calling external APIs. Be careful with transaction propagation \- async method runs in different thread. Monitor thread pool usage to avoid exhausting resources.

**\#. What is Spring Boot CommandLineRunner and ApplicationRunner?**

Both interfaces execute code after Spring Boot application has started. CommandLineRunner receives raw string arguments: public void run(String... args). ApplicationRunner receives ApplicationArguments which provides better access to arguments: public void run(ApplicationArguments args). Use them for initialization tasks like data loading, cache warming, starting scheduled jobs, or running startup scripts. Implement the interface in a @Component or return a bean. You can have multiple runners \- control order with @Order annotation. If any runner throws exception, application startup fails. Use ApplicationRunner for more structured argument access, CommandLineRunner for simple cases.

## Spring Boot & Microservices

**\#. What are microservices?**

Microservices is an architectural style where an application is composed of small, independent services that communicate over network. Each service is focused on a specific business capability, can be developed and deployed independently, and may use different technologies. Benefits include scalability (scale services independently), resilience (failure in one service doesn't bring down entire system), faster development (small teams can work independently), and technology diversity. Challenges include complexity in service communication, distributed data management, testing, deployment, and monitoring. Spring Boot with Spring Cloud provides excellent support for building microservices.

**\#. What is Spring Cloud?**

Spring Cloud provides tools for building common patterns in distributed systems and microservices. Key components include Service Discovery (Eureka, Consul), Client-side Load Balancing (Ribbon, Spring Cloud LoadBalancer), Circuit Breakers (Resilience4j, Hystrix \- deprecated), API Gateway (Spring Cloud Gateway), Distributed Configuration (Spring Cloud Config), Distributed Tracing (Sleuth with Zipkin), and more. It builds on Spring Boot, providing auto-configuration for Netflix OSS, HashiCorp, and other cloud technologies. It simplifies microservices development by providing battle-tested solutions for common challenges.

**\#. Explain service discovery with Eureka.**

Eureka is a service registry where microservices register themselves and discover other services. Eureka Server is the registry \- create one with @EnableEurekaServer. Eureka Client (microservices) register with server using spring-cloud-starter-netflix-eureka-client and application name in spring.application.name. Clients periodically send heartbeats. When one service needs to call another, it queries Eureka for available instances rather than hardcoding URLs. This enables dynamic service discovery \- services can be added/removed without configuration changes. Eureka Server can run in clustered mode for high availability. It's essential for dynamic microservices environments where service instances change frequently.

**\#. What is API Gateway and why is it needed?**

An API Gateway is a single entry point for all clients. It routes requests to appropriate microservices, aggregates responses, and provides cross-cutting concerns like authentication, rate limiting, logging, and SSL termination. Spring Cloud Gateway is the reactive gateway solution. Without a gateway, clients need to know about all service endpoints and handle concerns like authentication repeatedly. Gateway simplifies client code and centralizes common functionality. You define routes with predicates (match requests) and filters (modify requests/responses). For example, route requests to /users/\*\* to user-service. Gateway is crucial for microservices architecture \- it provides abstraction and control.

**\#. Explain circuit breaker pattern.**

Circuit breaker prevents cascading failures in distributed systems. It monitors calls to a service \- if failure rate exceeds threshold, the circuit "opens" and further calls fail immediately without actually calling the service, returning a fallback response. After a timeout, it enters "half-open" state, allowing some calls through to test if service has recovered. If successful, circuit "closes" and normal operation resumes. Resilience4j is the recommended library. Use @CircuitBreaker annotation on methods. Configure failure rate threshold, wait duration, and sliding window. It improves system resilience by failing fast and preventing thread exhaustion when downstream services are unavailable.

**\#. What is distributed tracing?**

In microservices, a single request may flow through multiple services, making debugging difficult. Distributed tracing tracks requests across services. Spring Cloud Sleuth adds trace and span IDs to logs. A trace represents the entire journey of a request. A span represents work done by a single service. Sleuth automatically propagates these IDs through HTTP headers and messaging. Integrate with Zipkin for visualization \- you can see request flow, identify slow services, and troubleshoot errors. Configure with spring-cloud-starter-sleuth and spring-cloud-sleuth-zipkin. Distributed tracing is essential for monitoring and debugging microservices \- it provides visibility into complex request flows.

**\#. How do you handle distributed configuration?**

Spring Cloud Config provides centralized configuration for distributed systems. Config Server stores configuration in Git repository (or other backends). Microservices (Config Clients) fetch configuration from server on startup. Benefits include centralized management, version control, environment-specific configuration, and ability to refresh configuration without restarting services (with @RefreshScope). Setup: create Config Server with @EnableConfigServer, point it to Git repo. Clients include spring-cloud-starter-config and configure spring.cloud.config.uri. You can encrypt sensitive properties. Dynamic refresh using /actuator/refresh endpoint. Centralized configuration is crucial for managing many microservices consistently.

**\#. What is Spring Cloud LoadBalancer?**

Spring Cloud LoadBalancer is a client-side load balancing solution that replaced Netflix Ribbon. It integrates with service discovery \- when calling a service, LoadBalancer selects an instance from the available instances. Use @LoadBalanced on RestTemplate or WebClient.Builder to enable load balancing. It uses the service name instead of URL: restTemplate.getForObject("[http://USER-SERVICE/users/1](http://USER-SERVICE/users/1)", User.class). Default algorithm is round-robin, but you can customize. It can health check instances and avoid unhealthy ones. Client-side load balancing reduces dependency on network load balancers and enables more sophisticated routing strategies.

**\#. Explain database per service pattern.**

In microservices, each service should have its own database \- not shared with other services. This enables true independence \- services can choose their database technology, scale independently, and change schema without affecting others. Challenges include data consistency across services (use Saga pattern or eventual consistency), implementing queries that span multiple services (use API composition or CQRS), and managing distributed transactions. You can't use foreign keys across services. While it adds complexity, it's essential for service autonomy and scalability. Use patterns like Event Sourcing or CQRS to manage challenges.

**\#. What is the Saga pattern?**

Saga pattern manages distributed transactions across microservices. Instead of ACID transactions, it uses a sequence of local transactions with compensating transactions for rollback. Two types: Choreography (each service publishes events and listens to others \- no central coordinator) and Orchestration (central coordinator tells services what to do). If a step fails, compensating transactions undo previous steps. For example, order placement saga: reserve inventory, charge customer, ship order. If shipping fails, refund customer and release inventory. Sagas are eventually consistent, not immediately consistent. They're essential for maintaining data consistency in microservices without distributed transactions.
