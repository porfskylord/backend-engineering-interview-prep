# Java Fundamentals & Advanced Concepts

## Memory Management & JVM

**#. Explain the Java memory model.**

Java memory is divided into several areas. The heap stores objects and is shared among all threads - it's where garbage collection happens. The method area (or Metaspace in Java 8+) stores class structures like metadata, static variables, and constant pool. Each thread has its own stack storing method calls, local variables, and partial results. The program counter keeps track of which instruction to execute. Native method stacks support native methods. Understanding this helps with memory management and performance tuning.

Operating System Memory

-----------------------------------------------

| Heap Memory                                 |

|   └── Young Gen                             |

|   └── Old Gen                              |

|                                              |

| Native Memory (Non-Heap, per thread)                  |

|   └── Metaspace (Method Area implementation)|

|   └── Thread Stacks                        |

|   └── PC Registers                          |

|   └── Native Method Stacks                  |

-----------------------------------------------

**#. What is garbage collection?**

Garbage collection is automatic memory management where the JVM automatically deallocates memory for objects that are no longer reachable. You don't need to explicitly free memory like in C++. The garbage collector identifies objects with no references to them and reclaims their memory. This prevents memory leaks and use-after-free errors. However, it's not perfect - you can still have memory leaks if you unintentionally hold references. Different GC algorithms offer tradeoffs between throughput and pause times.

**#. Explain the different generations in heap memory.**

The heap is divided into Young Generation, Old Generation, and Permanent Generation (Metaspace in Java 8+). Young Generation is for newly created objects and is further divided into Eden space and two Survivor spaces. Minor GC happens here frequently. Objects that survive multiple minor collections are promoted to Old Generation. Old Generation holds long-lived objects and has Major GC which is less frequent but takes longer. This generational approach is efficient because most objects die young.

**#. What's the difference between minor GC and major GC?**

Minor GC occurs in the Young Generation and is fast and frequent. It collects short-lived objects using algorithms like copying collection(Mark-Copy). Most objects die here. Major GC (or Full GC) occurs in the Old Generation and is slower and less frequent using algorithms like Mark-Sweep-Compact. It collects long-lived objects and reclaims more memory but causes longer pauses. A Full GC also collects Young Generation and sometimes Metaspace. Frequent Major GCs indicate memory pressure or tuning problems.

**#. Explain the finalize() method.**

finalize() is a method in Object class that's called by the garbage collector before reclaiming an object's memory. You can override it to perform cleanup like closing files or releasing resources. However, it's deprecated and unreliable - you don't know when or if it'll be called. It's better to use try-with-resources for automatic resource management or implement AutoCloseable and let callers use try-with-resources. The Cleaner API in Java 9+ is an alternative for cleanup actions.

**#. What's the difference between heap and stack memory?**

Stack memory stores method frames with local variables, method parameters, and references to objects in heap. Each thread has its own stack. It's faster, automatically managed, and has fixed size. When a method completes, its stack frame is removed. Heap memory stores objects and instance variables. It's shared among threads, slower than stack, managed by GC, and dynamically sized. Primitives and references are on stack, actual objects are on heap. Stack overflow happens with too many method calls, OutOfMemoryError happens with heap exhaustion.

**#. What causes OutOfMemoryError?**

OutOfMemoryError occurs when the JVM cannot allocate an object because there's insufficient memory. Common causes: heap space exhausted due to memory leaks or insufficient heap size, too many threads exceeding thread stack space, Metaspace filled with too many classes, large arrays exceeding array size limits, or native memory exhaustion. Solutions include increasing heap size with -Xmx, fixing memory leaks, reducing thread count, or optimizing data structures. Analyzing heap dumps helps identify the root cause.

**#. Explain strong, soft, weak, and phantom references.**

Strong references are normal references - objects with strong references won't be garbage collected. Soft references are collected when memory is low - useful for caches. Weak references are collected in the next GC cycle even if memory is sufficient - WeakHashMap uses them. Phantom references are enqueued after finalization but before memory reclamation - used for cleanup actions. Most code uses strong references, but others help with memory-sensitive caches and cleanup tasks.

**#. What are some JVM tuning parameters?**

Key parameters include -Xms for initial heap size, -Xmx for maximum heap size, -Xss for thread stack size, -XX:NewSize for Young Generation size, -XX:MaxNewSize for max Young Generation size, -XX:+UseG1GC or -XX:+UseZGC for choosing GC algorithm, -verbose:gc or -XX:+PrintGCDetails for GC logging. Tuning depends on application characteristics - for throughput-oriented apps, use parallel GC; for low-latency apps, use G1 or ZGC. Monitor GC logs and adjust based on pause times and throughput.

**#. What is memory leak in Java and how to detect it?**

A memory leak in Java is when objects are no longer needed but still have references, preventing garbage collection. Common causes: unclosed resources, static collections that grow unbounded, listeners not removed, ThreadLocal not cleaned up, or inner class references. To detect: use profilers like VisualVM or JProfiler, enable GC logging, analyze heap dumps with tools like Eclipse Memory Analyzer, monitor memory usage trends. Look for growing memory usage, frequent GCs, and objects that should be collected but aren't.

## Fundamentals & OOPs

**#. Can you explain the main principles of Object-Oriented Programming?**

Sure, there are four main principles. First is **Encapsulation** - basically wrapping data and methods together in a class and hiding internal details using access modifiers. Then **Inheritance** where one class can inherit properties from another, promoting code reuse. **Polymorphism** allows objects to take many forms - like method overloading and overriding. And finally **Abstraction** which means hiding complex implementation details and showing only necessary features to the user.

**#. What's the difference between abstract class and interface?**

Well, an abstract class can have both abstract and concrete methods, and it can have instance variables and constructors. You use 'extends' to inherit from it, and a class can only extend one abstract class. On the other hand, an interface before Java 8 could only have abstract methods, but now it can have default and static methods too. A class can implement multiple interfaces using 'implements'. Also, all variables in an interface are public, static, and final by default.

**#. Explain method overloading and method overriding.**

Method overloading is when you have multiple methods with the same name in the same class but different parameters - either different number of parameters or different types. It happens at compile time, so it's also called compile-time polymorphism. Method overriding is when a subclass provides a specific implementation for a method that's already defined in its parent class. The method signature must be exactly the same, and it happens at runtime.

**#. What is the 'super' keyword used for?**

The 'super' keyword is used to refer to the immediate parent class. You can use it to call the parent class constructor using super(), access parent class methods when they're overridden in the child class, or access parent class variables if they're hidden by child class variables with the same name. It's really useful when you want to extend functionality rather than completely replace it.

**#. Can you explain the 'final' keyword in Java?**

The 'final' keyword has different meanings depending on where you use it. When applied to a variable, it makes it a constant - you can't change its value once assigned. For methods, 'final' means the method cannot be overridden by subclasses. And for classes, it means the class cannot be extended or inherited. It's commonly used for creating immutable objects and preventing inheritance when needed.

**#. What's the difference between \== and equals() method?**

The \== operator compares references - it checks if both references point to the same object in memory. The equals() method, by default, also does reference comparison, but it's meant to be overridden to compare the actual content of objects. For example, with String objects, \== checks if they're the same object, while equals() checks if they have the same sequence of characters.

**#. How does the equals() and hashCode() contract work? Why is it important?**

The contract states that if two objects are equal according to their equals() method, they must have the same hashCode(). The reverse is not necessarily true; two objects with the same hash code don't have to be equal. This contract is crucial for hash-based collections like HashMap, HashSet, and Hashtable to function correctly. They use the hash code to find the right bucket to store an object and then use equals() to find the exact object within that bucket. If you override equals(), you must always override hashCode() to obey this contract, otherwise your objects won't work correctly in these collections.

**#. Why is String immutable in Java?**

Strings are immutable for several reasons. First, it enables string pooling which saves memory - if strings are immutable, the JVM can safely reuse them. Second, it's important for security - strings are used in network connections, file paths, etc., and immutability prevents them from being modified. Third, it makes them thread-safe automatically. And fourth, since strings can't change, their hashcode can be cached, making them efficient as HashMap keys.

**#. What's the difference between String, StringBuilder, and StringBuffer?**

String is immutable, so every time you modify it, a new object is created. StringBuilder and StringBuffer are mutable, so they modify the same object. The main difference between StringBuilder and StringBuffer is that StringBuffer is thread-safe because its methods are synchronized, but StringBuilder is not thread-safe. StringBuilder is faster because it doesn't have synchronization overhead. I'd use String for small concatenations, StringBuilder for single-threaded scenarios with lots of modifications, and StringBuffer when thread safety is needed.

**#. Explain the concept of constructor in Java.**

A constructor is a special method that's called when an object is created. It has the same name as the class and no return type, not even void. Constructors are used to initialize object state. Java provides a default no-argument constructor if you don't define any, but once you create a parameterized constructor, you need to explicitly define a no-arg constructor if you need one. You can also have constructor overloading with different parameters.

**#. What is constructor chaining?**

Constructor chaining is when one constructor calls another constructor in the same class or parent class. Within the same class, you use this() to call another constructor, and it must be the first statement. To call a parent class constructor, you use super(), and again it must be the first statement. This is useful for code reuse and reducing redundancy in initialization logic.

**#. Can you explain access modifiers in Java?**

Java has four access modifiers. **Public** means accessible from anywhere. **Private** means accessible only within the same class. **Protected** means accessible within the same package and by subclasses, even if they're in different packages. And the default or package-private (when you don't specify any modifier) means accessible only within the same package. These help in implementing encapsulation and controlling access to class members.

**#. What's the difference between static and instance variables?**

Static variables belong to the class itself and are shared among all instances. There's only one copy regardless of how many objects you create. They're initialized when the class is loaded. Instance variables belong to specific objects, so each object has its own copy. They're initialized when the object is created using the 'new' keyword. Static variables are useful for constants or shared data, while instance variables hold object-specific state.

**#. Explain static methods and their limitations.**

Static methods belong to the class rather than instances. They can be called without creating an object using the class name. However, they have limitations - they can only access static variables and other static methods directly. They cannot use 'this' or 'super' keywords because they're not associated with any instance. They're commonly used for utility functions that don't need object state.

**#. What is a static block and when is it executed?**

A static block is a block of code inside a class that's prefixed with the 'static' keyword. It's executed when the class is first loaded into memory, before any object is created or any static method is called. You can have multiple static blocks, and they execute in the order they appear. They're typically used for complex initialization of static variables or loading native libraries.

**#. What's the difference between composition and inheritance?**

Inheritance represents an "is-a" relationship where a class inherits from another. Composition represents a "has-a" relationship where a class contains instances of other classes. Composition is generally preferred over inheritance because it's more flexible - you can change behavior at runtime by composing different objects. It also avoids the tight coupling that comes with inheritance. The principle is "favor composition over inheritance."

**#. Explain the concept of coupling and cohesion.**

Coupling refers to how dependent classes are on each other. Low coupling is better because changes in one class don't heavily impact others. Cohesion refers to how related the responsibilities within a single class are. High cohesion is better because it means the class has a clear, focused purpose. Good design aims for low coupling and high cohesion - classes should be focused and independent.

**#. What is method hiding in Java?**

Method hiding occurs when a subclass defines a static method with the same signature as a static method in its parent class. Unlike method overriding with instance methods, this doesn't involve polymorphism. The method that gets called depends on the reference type, not the object type. It's generally not recommended because it can be confusing and doesn't follow polymorphic behavior.

**#. Can you explain the concept of 'this' keyword?**

The 'this' keyword refers to the current object instance. It's used in several ways: to refer to instance variables when there's a naming conflict with parameters, to call other constructors in the same class (constructor chaining), to pass the current object as a parameter to other methods, or to return the current object from a method. It's implicit in most cases but becomes necessary to avoid ambiguity.

**#. What are wrapper classes and autoboxing?**

Wrapper classes are object representations of primitive types - like Integer for int, Double for double, Boolean for boolean, etc. They're useful because collections can only store objects, not primitives. Autoboxing is the automatic conversion of primitives to their wrapper objects, and unboxing is the reverse. For example, when you add an int to an ArrayList<Integer>, autoboxing automatically converts it to Integer.

**#. Explain pass by value in Java.**

Java is strictly pass by value. For primitives, a copy of the value is passed. For objects, a copy of the reference is passed, not the object itself. This means you can modify the object's state through the reference, but you cannot make the reference point to a different object and have that change reflect in the caller. This is a common point of confusion, but understanding it's always pass by value is important.

**#. What is a marker interface? Can you give an example?**

A marker interface is an interface that has no methods or fields. It's just an empty interface. Its purpose is to 'mark' a class as possessing a certain capability or to tell the JVM or a framework to treat objects of that class in a special way. Classic Java examples are Serializable (which tells the JVM that an object can be converted into a byte stream) and Cloneable (which indicates that the clone() method can be called on an object).

**#. Explain the concept of immutability. How do you create an immutable class?**

Immutability means that once an object is created, its state cannot be changed. Any attempt to 'modify' it results in a new object being created. String is a classic example. To create an immutable class in Java, you should: Declare the class as final so it cannot be subclassed.Make all fields private and final. Don't provide any setter methods that modify fields. If the class holds references to mutable objects (like Date or collections), don't return the reference directly. In the getter, return a defensive copy (e.g., new Date(date.getTime()) or Collections.unmodifiableList(myList)). In the constructor, also make defensive copies of any mutable objects passed in, to ensure the internal state isn't modified from outside.

**#. What is the Diamond Problem in the context of multiple inheritance and how does Java handle it?**

The diamond problem occurs when a class inherits from two superclasses that have a method with the same signature, creating ambiguity about which method to call. Java avoids this with classes because it doesn't support multiple inheritance of state. However, since Java 8, with default methods in interfaces, a form of the diamond problem can arise if a class implements two interfaces that provide a default method with the same signature. Java handles this by forcing the implementing class to provide its own implementation of that method, explicitly resolving the conflict. The class can also choose to call one of the parent interfaces' methods using InterfaceName.super.methodName().

## Java 8+ Features

**#. What are Lambda expressions and why were they introduced?**

Lambda expressions are anonymous functions(a method without a declaration, access modifier, return type, or name) that let you write more concise code. They were introduced in Java 8 to enable functional programming and make it easier to write code that treats functionality as a method argument. The syntax is (parameters) -> expression or (parameters) -> { statements; }. They're especially useful with streams and functional interfaces. They reduce boilerplate code and make the code more readable.

**#. What is a functional interface?**

A functional interface is an interface with exactly one abstract method. It can have multiple default or static methods, but only one abstract method. The @FunctionalInterface annotation is optional but recommended - it makes the compiler check that the interface follows the rules. Examples include Runnable, Callable, Comparator, and the new ones like Predicate, Function, Consumer, and Supplier. Lambda expressions implement functional interfaces.

**#. Can you explain the Stream API?**

The Stream API provides a functional approach to processing collections. A stream is a sequence of elements that supports operations like filter, map, reduce, etc. Streams can be sequential or parallel. They're lazy - intermediate operations don't execute until a terminal operation is called. Streams don't modify the original data source, they just process elements. Common operations include filter for selection, map for transformation, collect for aggregation, and forEach for iteration.

**#. What's the difference between map() and flatMap()?**

The map() method transforms each element into exactly one new element - it's a one-to-one mapping. FlatMap() transforms each element into a stream of elements and then flattens all those streams into a single stream. It's useful when you have nested structures. For example, if you have a list of lists and want to flatten it into a single list, you'd use flatMap. Map would give you a Stream of Streams, while flatMap gives you a single flattened Stream.

**#. Explain the Optional class and its benefits.**

Optional is a container object that may or may not contain a value. It was introduced to avoid NullPointerException and make code more explicit about nullability. Instead of returning null, methods can return Optional.empty(). You can check if a value is present using isPresent(), get it using get() (though this is risky), or use safer methods like orElse(), orElseGet(), or orElseThrow(). You can also chain operations using map() and flatMap(). It makes null handling more explicit and functional.

**#. What are default methods in interfaces?**

Default methods were introduced in Java 8 to allow adding new methods to interfaces without breaking existing implementations. They're declared with the 'default' keyword and provide a default implementation. If a class implements the interface but doesn't override the default method, it uses the default implementation. This was crucial for adding Stream methods to existing interfaces like Collection without breaking backward compatibility.

**#. What are static methods in interfaces?**

Static methods in interfaces are utility methods related to the interface. They belong to the interface itself, not to implementing classes. They can't be overridden by implementing classes. They're useful for providing helper or factory methods related to the interface. For example, Comparator has static methods like comparing() and naturalOrder() that return Comparator instances.

**#. Explain method references in Java 8.**

Method references are a shorthand for lambda expressions that just call a specific method. There are four types: static method references (ClassName::staticMethod), instance method references on a particular object (object::instanceMethod), instance method references on an arbitrary object of a particular type (ClassName::instanceMethod), and constructor references (ClassName::new). They make code more readable when the lambda just calls an existing method.

**#. What is the forEach() method?**

forEach() is a method introduced in the Iterable interface in Java 8. It takes a Consumer functional interface as a parameter and performs an action for each element. It's an internal iteration - you specify what to do, not how to iterate. For example, list.forEach(System.out::println) prints each element. It's cleaner than traditional for loops for simple iterations, though traditional loops are better when you need more control like breaking early.

**#. Explain the Predicate functional interface.**

Predicate is a functional interface with a test() method that takes one argument and returns a boolean. It's used for filtering or matching. For example, Predicate<Integer> isEven = n -> n % 2 == 0. It has useful default methods like and(), or(), and negate() for combining predicates. It's commonly used with stream's filter() method. It makes conditional logic more expressive and composable.

**#. What are Consumer and Supplier interfaces?**

Consumer is a functional interface with an accept() method that takes one argument and returns void. It's used for operations that consume a value without returning anything, like printing or saving. For example, Consumer<String> print = s -> System.out.println(s). Supplier is the opposite - its get() method takes no arguments but returns a value. It's used for lazy generation of values. For example, Supplier<Double> random = () -> Math.random().

**#. Explain the Function interface.**

Function is a functional interface with an apply() method that takes one argument and returns a result. It represents a transformation from type T to type R. For example, Function<String, Integer> length = s -> s.length(). It has useful methods like andThen() and compose() for chaining functions. It's commonly used with stream's map() method. It makes transformations explicit and composable.

**#. What's the difference between intermediate and terminal operations in streams?**

Intermediate operations like filter(), map(), and sorted() return a stream and are lazy - they don't execute until a terminal operation is called. You can chain multiple intermediate operations. Terminal operations like forEach(), collect(), and reduce() trigger the processing and return a non-stream result or produce a side effect. Once a terminal operation is called, the stream is consumed and can't be reused. This lazy evaluation improves performance.

**#. Explain the collect() method and Collectors.**

The collect() method is a terminal operation that accumulates stream elements into a collection or other result. The Collectors class provides many predefined collectors. Common ones include toList(), toSet(), toMap(), joining() for concatenating strings, groupingBy() for grouping elements, and partitioningBy() for dividing elements into two groups based on a predicate. You can also create custom collectors. It's very powerful for aggregating stream results.

**#. What is the reduce() method?**

The reduce() method performs a reduction on stream elements using an associative accumulation function and returns an Optional or a single value. For example, stream.reduce((a, b) -> a + b) sums all elements. It can take an identity value as the first parameter. It's useful for operations like sum, product, max, min, or any custom aggregation. It's more general than specialized methods like sum() but sometimes less readable.

**#. Explain parallel streams and when to use them.**

Parallel streams split the data into multiple chunks and process them in parallel using multiple threads from the ForkJoin pool. You create them using parallelStream() or stream().parallel(). They can significantly improve performance for large datasets and CPU-intensive operations. However, they have overhead, so they're not always faster. Use them when you have large amounts of data, the operations are stateless and don't depend on order, and there's enough work to justify the parallelization overhead. Avoid them for I/O operations or small datasets.

**#. What are the new Date and Time APIs in Java 8?**

Java 8 introduced the java.time package to replace the problematic Date and Calendar classes. Key classes include LocalDate for dates without time, LocalTime for times without dates, LocalDateTime for both, ZonedDateTime for date-time with timezone, Instant for timestamps, Duration for time-based amounts, and Period for date-based amounts. These classes are immutable and thread-safe. They have a fluent API with methods like plusDays(), minusMonths(), etc. The API is much clearer and easier to use than the old one.

**#. Explain LocalDate, LocalTime, and LocalDateTime.**

LocalDate represents a date without time or timezone, like 2024-12-15. LocalTime represents a time without date or timezone, like 14:30:00. LocalDateTime combines both - date and time without timezone. They're all immutable and thread-safe. You create them using static factory methods like now(), of(), or parse(). They have methods for adding/subtracting time, formatting, parsing, and comparing. They're useful when you don't need timezone information.

**#. What is the difference between Instant and LocalDateTime?**

Instant represents a point in time on the timeline in UTC - it's the number of seconds from the Unix epoch (January 1, 1970). It's machine-oriented and used for timestamps. LocalDateTime represents date and time without timezone information - it's human-oriented, like "2024-12-15 14:30:00". LocalDateTime doesn't have timezone context, so "14:30" means different actual moments in different timezones. Instant always refers to the same moment globally. You'd use Instant for timestamps and LocalDateTime for display purposes.

**#. Explain the StringJoiner class.**

StringJoiner is a utility class introduced in Java 8 for constructing strings with delimiters, prefixes, and suffixes. For example, StringJoiner sj = new StringJoiner(", ", "[", "]") creates a joiner that joins with comma-space, starting with "[" and ending with "]". You add elements using add(). It's useful for building formatted strings. However, for simple joining, the String.join() method or Collectors.joining() in streams is more convenient.

**#. What is the difference between an IntStream and a Stream<Integer>?**

This is about primitive specializations in the Stream API. Stream<Integer> is a stream of object references. Operations on it involve boxing and unboxing, which can have a performance overhead for large numerical datasets. IntStream is a primitive stream for int values. It provides operations specifically for integers, like sum(), average(), min(), max(), and range(), without the boxing overhead. It's more efficient for numerical operations. There are also LongStream and DoubleStream.

## Exception Handling

**#. What's the difference between checked and unchecked exceptions?**

Checked exceptions are checked at compile time - you must either handle them with try-catch or declare them with throws. They extend Exception but not RuntimeException. Examples include IOException, SQLException. They represent conditions that a reasonable application might want to catch. Unchecked exceptions are not checked at compile time - you're not required to handle them. They extend RuntimeException and include things like NullPointerException, ArrayIndexOutOfBoundsException. They usually represent programming errors.

**#. Explain the try-catch-finally block.**

Try block contains code that might throw an exception. Catch blocks handle specific exceptions - you can have multiple catch blocks for different exceptions. Finally block always executes whether an exception occurs or not - it's used for cleanup like closing resources. The order must be try, then catch, then finally. From Java 7, there's also try-with-resources which automatically closes resources that implement AutoCloseable, making finally less necessary for resource management.

**#. What is try-with-resources?**

Try-with-resources is a feature from Java 7 that automatically closes resources that implement AutoCloseable or Closeable. You declare resources in parentheses after try, and they're automatically closed when the try block exits, whether normally or due to an exception. For example, try (FileReader fr = new FileReader("file.txt")) { ... }. You can declare multiple resources separated by semicolons. It's cleaner and safer than manually closing in finally blocks because it handles suppressed exceptions properly.

**#. Can you have multiple catch blocks? What's catch block ordering?**

Yes, you can have multiple catch blocks to handle different exception types. The order matters - more specific exceptions must come before more general ones. For example, IOException must come before Exception, otherwise you'll get a compilation error. From Java 7, you can also use multi-catch to handle multiple exceptions in one block using the pipe symbol, like catch (IOException | SQLException e). This is useful when you want to handle different exceptions the same way.

**#. What is exception propagation?**

Exception propagation is when an uncaught exception is automatically passed up the call stack to the calling method. If method A calls method B and method B throws an exception that it doesn't catch, the exception propagates to method A. This continues until the exception is caught or reaches the JVM, which prints the stack trace and terminates the thread. Checked exceptions must be declared in the method signature with throws, while unchecked exceptions propagate automatically.

**#. What's the difference between throw and throws?**

'Throw' is used to explicitly throw an exception from a method or code block - you use it with an exception object. 'Throws' is used in the method signature to declare that the method might throw certain checked exceptions - it's a declaration for the caller. For example, "throw new IOException()" throws an exception, while "void readFile() throws IOException" declares that the method might throw IOException.

**#. Can you create custom exceptions?**

Yes, you create custom exceptions by extending Exception for checked exceptions or RuntimeException for unchecked ones. You typically provide constructors that call super() to pass messages to the parent class. For example: class InsufficientBalanceException extends Exception { public InsufficientBalanceException(String message) { super(message); } }. Custom exceptions make error handling more specific and meaningful for your application domain.

**#. What happens if an exception occurs in a finally block?**

If an exception occurs in a finally block, it suppresses any exception that was thrown in the try or catch block. The finally block exception is propagated, and the original exception is lost unless you explicitly handle it. This is one reason to avoid complex logic in finally blocks. Try-with-resources handles this better - it has a mechanism for suppressed exceptions where you can retrieve the original exception even if close() throws an exception.

**#. Can you catch and rethrow an exception?**

Yes, you can catch an exception, do some processing like logging, and then rethrow it. You can rethrow the same exception using "throw e" or wrap it in a different exception. Rethrowing is useful when you want to do something like logging or cleanup but still let the exception propagate. You can also throw a new exception and include the original as the cause using initCause() or passing it to the constructor.

**#. What is the exception hierarchy in Java?**

At the top is Throwable, which has two main subclasses: Error and Exception. Errors represent serious problems that applications shouldn't try to catch, like OutOfMemoryError or StackOverflowError. Exceptions are divided into checked exceptions (direct subclasses of Exception except RuntimeException) and unchecked exceptions (RuntimeException and its subclasses). This hierarchy determines whether exceptions need to be declared or caught at compile time.

## Multithreading

**#. What's the difference between process and thread?**

A process is an independent program with its own memory space - processes don't share memory. A thread is a lightweight subprocess that shares the process's memory space. Multiple threads within a process can access the same data, which enables communication but requires synchronization to avoid conflicts. Creating threads is faster than creating processes. Threads are useful for concurrent tasks within the same application, while processes are for running separate applications.

**#. How do you create a thread in Java?**

There are two main ways. First, extend the Thread class and override its run() method, then create an instance and call start(). Second, implement the Runnable interface, override run(), create a Thread object passing your Runnable, and call start(). Implementing Runnable is generally preferred because Java doesn't support multiple inheritance, so extending Thread limits your options. You can also use lambda expressions with Runnable since it's a functional interface.

**#. What's the difference between start() and run() methods?**

start() creates a new thread and calls run() on that new thread - it's the correct way to start a thread. If you call run() directly, it executes on the current thread just like a normal method call - no new thread is created. So start() is for concurrent execution, run() is just a regular method. You can only call start() once on a thread object; calling it again throws IllegalThreadStateException.

**#. Explain thread life cycle states.**

A thread goes through several states. NEW when it's created but not started. RUNNABLE after start() is called - it's ready to run but may be waiting for the CPU. RUNNING when it's actually executing (considered part of RUNNABLE in Java's State enum). BLOCKED when waiting for a monitor lock. WAITING when explicitly waiting via wait(), join(), or park(). TIMED_WAITING when waiting with a timeout. TERMINATED when run() completes or an exception occurs.

**#. What is synchronization and why is it needed?**

Synchronization is a mechanism to control access to shared resources by multiple threads. It's needed to prevent race conditions where multiple threads access shared data simultaneously, leading to data inconsistency. In Java, you use the synchronized keyword on methods or blocks. When a thread enters a synchronized method or block, it acquires the lock on the object, and other threads must wait. This ensures only one thread accesses the critical section at a time.

**#. Explain synchronized method vs synchronized block.**

A synchronized method locks the entire method - the lock is on 'this' for instance methods or the Class object for static methods. A synchronized block locks only a specific section of code and you explicitly specify which object to lock. Synchronized blocks provide finer-grained control and better concurrency because threads can execute non-synchronized parts concurrently. Use synchronized methods for simplicity when the entire method needs protection, and synchronized blocks when only part needs protection.

**#. What is a deadlock and how can you avoid it?**

Deadlock occurs when two or more threads are blocked forever, each waiting for a resource held by another. For example, Thread A holds lock 1 and waits for lock 2, while Thread B holds lock 2 and waits for lock 1. To avoid deadlock: acquire locks in a consistent order across all threads, use timeouts with tryLock(), avoid nested locks when possible, or use higher-level concurrency utilities like Executor framework. Detecting deadlock is hard; prevention is better.

**#. Explain the wait(), notify(), and notifyAll() methods.**

These are methods in the Object class for inter-thread communication. wait() releases the lock and makes the thread wait until another thread calls notify() or notifyAll() on the same object. notify() wakes up one waiting thread. notifyAll() wakes up all waiting threads. They must be called within a synchronized context on the same object. They're used for coordination - like producer-consumer where producer notifies consumer when data is available.

**#. What's the difference between notify() and notifyAll()?**

notify() wakes up exactly one thread that's waiting on the object, but you can't control which one - the JVM chooses. notifyAll() wakes up all threads waiting on the object, and they'll compete for the lock. In most cases, notifyAll() is safer because it ensures all waiting threads get a chance. Use notify() only when you're certain that only one thread should be woken up and any waiting thread can handle it.

**#. Explain the volatile keyword.**

The volatile keyword ensures that changes to a variable are immediately visible to all threads. Without volatile, threads might cache variable values locally, seeing stale data. Volatile provides visibility guarantee but not atomicity - it's useful for flags or state variables. It prevents compiler and CPU from reordering operations on the variable. However, for compound operations like increment (read-modify-write), volatile alone isn't enough - you need synchronization or atomic classes.

**#. What is the happens-before relationship?**

Happens-before is a guarantee that memory operations in one thread are visible to another thread. For example, everything before a thread start() happens before the thread's run() begins. Exiting a synchronized block happens before entering the next synchronized block on the same lock. Writing to a volatile variable happens before subsequent reads of that variable. These guarantees help reason about visibility in concurrent programs without needing to know low-level memory model details.

**#. Explain the ExecutorService.**

ExecutorService is a higher-level interface for managing thread pools and asynchronous task execution. Instead of managing threads manually, you submit Runnable or Callable tasks to an ExecutorService, and it manages execution using a pool of threads. Methods include submit() for submitting tasks, shutdown() for stopping execution, and invokeAll() for executing multiple tasks. It's more flexible and easier to use than raw threads, provides better resource management, and supports returning results via Future.

**#. What's the difference between Runnable and Callable?**

Runnable has a run() method that returns void and can't throw checked exceptions directly. Callable has a call() method that returns a value and can throw checked exceptions. Callable is more powerful for tasks that compute results. You submit Runnable to executors for fire-and-forget tasks, while Callable returns a Future that you can use to retrieve the result or check if it's done. Callable enables better error handling and result retrieval.

**#. Explain the Future interface.**

Future represents the result of an asynchronous computation. When you submit a Callable to an ExecutorService, it returns a Future. You can use get() to retrieve the result (this blocks until the computation completes), cancel() to cancel the task, isDone() to check if it's complete, and isCancelled() to check if it was cancelled. The get() method with timeout is useful to avoid blocking forever. Future enables non-blocking submission of tasks and later retrieval of results.

**#. What are thread pools and why use them?**

A thread pool is a collection of pre-created threads that are reused for executing tasks. Instead of creating a new thread for each task (which is expensive), you submit tasks to the pool, and available threads execute them. Benefits include reduced overhead from thread creation/destruction, controlled resource usage (you can limit max threads), and better performance. Java provides factory methods like newFixedThreadPool(), newCachedThreadPool(), and newScheduledThreadPool() for creating different types of pools.

**#. Explain CountDownLatch and CyclicBarrier.**

Both are concurrency utilities for coordinating threads. CountDownLatch is used for one-time synchronization. You initialize it with a count. One or more threads call await() on it and block. Other threads perform tasks and call countDown() to decrement the count. When the count reaches zero, all waiting threads are released. It's like a gate that opens once. It cannot be reset. CyclicBarrier is used when a fixed number of threads must wait for each other to reach a common point before they can all proceed. All threads call await() and block. When the last thread arrives, the barrier is broken, and all threads are released. It's reusable—you can reset it for a new round of coordination.

**#. What is a Future and CompletableFuture?**

Future (Java 5) represents the result of an asynchronous computation. It has methods to check if the computation is complete, wait for its completion, and retrieve the result. However, its main limitation is that you have to block using get() to obtain the result, and it cannot be manually completed or chained. CompletableFuture (Java 8) is an extension of Future. It implements Future and CompletionStage, which makes it extremely powerful for asynchronous programming. It allows you to manually complete the future, apply functions, and compose asynchronous operations in a non-blocking, callback-driven style using methods like thenApply(), thenAccept(), thenCompose(), and thenCombine(). It's perfect for building complex asynchronous pipelines.

**#. What is the ReentrantLock? How is it different from synchronized?**

ReentrantLock is a class in java.util.concurrent.locks that provides more extensive locking operations than synchronized. It's called 'reentrant' because a thread can acquire the same lock multiple times without blocking itself. Differences from synchronized: ReentrantLock has a fairness parameter, allowing the lock to favor granting access to the longest-waiting thread.It provides tryLock() which can attempt to acquire the lock without blocking indefinitely, and tryLock(long timeout, TimeUnit unit) which can wait with a timeout. lockInterruptibly() allows a thread to be interrupted while waiting for the lock. You must explicitly call unlock() in a finally block, whereas synchronized unlocks automatically

## Collections Framework

**#. Explain the Collections framework hierarchy.**

At the top is the Iterable interface, then Collection. Collection has three main sub-interfaces: List for ordered collections allowing duplicates (ArrayList, LinkedList), Set for unique elements (HashSet, TreeSet), and Queue for holding elements prior to processing (PriorityQueue, LinkedList). Separately, there's the Map interface for key-value pairs (HashMap, TreeMap). Each interface has multiple implementations optimized for different use cases.

**#. What's the difference between ArrayList and LinkedList?**

ArrayList uses a dynamic array internally - it provides fast random access with O(1) time complexity for get operations, but insertion and deletion in the middle is slow because elements need to be shifted. LinkedList uses a doubly-linked list - random access is slow O(n), but insertion and deletion at any position is fast O(1) if you have the reference. I'd use ArrayList for frequent access and rare modifications, and LinkedList when you frequently add/remove elements at the beginning or middle.

**#. Explain how HashMap works internally.**

HashMap uses an array of Node objects. When you put a key-value pair, it calculates the key's hashCode, applies a hash function, and uses that to determine the array index (bucket). If multiple keys hash to the same bucket, they're stored in a linked list (or tree if too many). When getting a value, it uses the same process to find the bucket, then searches the linked list using equals(). From Java 8, if a bucket has more than 8 entries, the linked list converts to a tree for better performance.

**#. What's the difference between HashMap and HashTable?**

HashMap is not synchronized so it's faster but not thread-safe. It allows one null key and multiple null values. HashTable is synchronized so it's thread-safe but slower. It doesn't allow null keys or values. HashTable is legacy - for thread-safe maps, it's better to use ConcurrentHashMap which is more efficient. Another option is Collections.synchronizedMap() to wrap a HashMap.

**#. Explain LinkedHashMap and TreeMap.**

LinkedHashMap maintains insertion order or access order (if specified in constructor) using a doubly-linked list. It's slightly slower than HashMap but useful when you need predictable iteration order. TreeMap implements NavigableMap and stores entries in sorted order based on keys' natural ordering or a provided Comparator. Operations like get and put are O(log n). It's useful when you need sorted keys or operations like firstKey(), lastKey(), or subMap().

**#. What's the difference between Set and List?**

List is an ordered collection that allows duplicates. Elements maintain their insertion order and can be accessed by index. Implementations include ArrayList and LinkedList. Set doesn't allow duplicates and has no guaranteed order (except LinkedHashSet which maintains insertion order and TreeSet which maintains sorted order). Set implementations include HashSet, LinkedHashSet, and TreeSet. Lists are useful when order and duplicates matter, Sets when uniqueness matters.

**#. Explain HashSet and TreeSet.**

HashSet uses a HashMap internally - it stores elements as keys with a dummy value. Operations like add, remove, and contains are O(1) on average. It doesn't maintain any order. TreeSet uses a TreeMap internally - it stores elements in sorted order. Operations are O(log n). Elements must be comparable or you must provide a Comparator. HashSet is faster, TreeSet is useful when you need sorted unique elements.

**#. What is the ConcurrentHashMap?**

ConcurrentHashMap is a thread-safe map that provides better concurrency than HashTable or synchronized HashMap. Instead of locking the entire map, it uses segment-based locking (before Java 8) or node-based locking (Java 8+). Multiple threads can read and write to different segments concurrently. It doesn't allow null keys or values. It's the preferred choice for thread-safe maps in multi-threaded applications because it provides better throughput.

**#. Explain the difference between Iterator and ListIterator.**

Iterator can traverse any Collection in forward direction only. It has methods hasNext(), next(), and remove(). ListIterator is specifically for Lists and can traverse in both directions. It has additional methods like hasPrevious(), previous(), add(), and set(). ListIterator also provides index information with nextIndex() and previousIndex(). You get an Iterator using collection.iterator() and a ListIterator using list.listIterator().

**#. What is the fail-fast behavior of iterators?**

Fail-fast iterators throw ConcurrentModificationException if the collection is structurally modified after the iterator is created, except through the iterator's own methods. This happens because the iterator maintains a modification count, and if it detects the count has changed unexpectedly, it fails immediately rather than risking unpredictable behavior. Not all collections have fail-fast iterators - for example, ConcurrentHashMap uses fail-safe iterators that work on a clone.

**#. Explain the Comparable and Comparator interfaces.**

Comparable is an interface with one method compareTo() that defines natural ordering for a class. The class implements it. For example, String implements Comparable to define alphabetical ordering. Comparator is a separate interface with compare() method - it defines custom ordering without modifying the class. You can create multiple Comparators for the same class to sort in different ways. Comparable is for default sorting, Comparator for custom sorting.

**#. What's the difference between Comparator and Comparable?**

Comparable is implemented by the class itself to provide natural ordering - the class decides how it should be compared. There can be only one compareTo() implementation. Comparator is a separate class that compares two objects - you can create multiple Comparators for different sorting strategies. Comparable is in java.lang, Comparator is in java.util. If you control the class, use Comparable for natural ordering. For custom or multiple sorting strategies, use Comparator.

**#. Explain the Queue interface and implementations.**

Queue is a collection for holding elements before processing, typically in FIFO order. Main methods are offer() to add, poll() to remove and retrieve, and peek() to retrieve without removing. LinkedList implements Queue. PriorityQueue orders elements based on natural ordering or Comparator. ArrayDeque is a resizable array implementation that's faster than LinkedList. Queues are useful for scheduling, task processing, and breadth-first searches.

**#. What is a PriorityQueue?**

PriorityQueue is a queue where elements are ordered by priority rather than insertion order. By default, it uses natural ordering (Comparable), or you can provide a Comparator. The element with highest priority (smallest value by default) is at the head. Operations like offer and poll are O(log n). It uses a heap internally. It's useful for scheduling where you need to process highest-priority items first.

**#. Explain the Deque interface.**

Deque (Double-Ended Queue) allows insertion and removal at both ends. It extends Queue and can be used as FIFO queue or LIFO stack. Methods include addFirst(), addLast(), removeFirst(), removeLast(), etc. ArrayDeque and LinkedList implement Deque. It's more versatile than Queue or Stack. You can use it to implement stack (push/pop), queue (offer/poll), or steque (stack-queue combination).

**#. What's the difference between Collection and Collections?**

Collection is an interface - the root interface of the collections framework. It defines basic collection operations like add, remove, contains, size, etc. Collections is a utility class with static methods for operating on collections - like sort(), reverse(), shuffle(), synchronizedList(), etc. It's similar to how Arrays is a utility class for array operations while array is a language construct.

**#. Explain some useful methods in Collections utility class.**

The Collections class has many useful methods. sort() sorts lists, reverse() reverses order, shuffle() randomizes order. binarySearch() searches sorted lists efficiently. max() and min() find extreme values. frequency() counts occurrences. synchronizedCollection() wraps collections to make them thread-safe. unmodifiableCollection() creates read-only views. disjoint() checks if two collections have no common elements. These methods make collection operations more convenient.

**#. What is the difference between synchronized collection and concurrent collection?**

Synchronized collections like those created with Collections.synchronizedMap() lock the entire collection for each operation - only one thread can access it at a time. This is simple but has low concurrency. Concurrent collections like ConcurrentHashMap use fine-grained locking or lock-free algorithms allowing multiple threads to access different parts simultaneously. They provide better throughput in multi-threaded scenarios. Concurrent collections are generally preferred for high-concurrency applications.

**#. Explain WeakHashMap.**

WeakHashMap is a Map implementation where keys are stored as weak references. If a key has no strong references outside the map, it becomes eligible for garbage collection and its entry is automatically removed from the map. This is useful for caches or metadata storage where you don't want the map to prevent garbage collection of objects. Regular HashMap holds strong references, preventing garbage collection even if no other references exist.

**#. What is the IdentityHashMap?**

IdentityHashMap is a Map that uses reference equality (==) instead of object equality (equals()) when comparing keys. It uses System.identityHashCode() instead of hashCode(). This is useful in rare scenarios where you want to track objects by identity rather than value. For example, when implementing serialization or keeping metadata about specific object instances. It violates the Map contract but is useful for specific low-level scenarios.

**#. What is a BlockingQueue and where would you use it?**

BlockingQueue is an interface in java.util.concurrent that represents a queue which is thread-safe and supports operations that wait for the queue to become non-empty when retrieving an element, and wait for space to become available when storing an element. It's an implementation of the Producer-Consumer pattern. A classic use case is a thread pool. Tasks are offered to the queue by producer threads, and worker threads consume them. If the queue is full, the producers block; if it's empty, the consumers block. Implementations include ArrayBlockingQueue and LinkedBlockingQueue.

## Advanced Java Concepts

**#. Explain reflection in Java.**

Reflection is the ability to inspect and manipulate classes, methods, fields, and other components at runtime. The java.lang.reflect package provides this capability. You can load classes dynamically with Class.forName(), create instances with newInstance(), invoke methods with method.invoke(), and access private fields. It's used by frameworks like Spring and Hibernate for dependency injection and ORM. However, reflection is slower than direct code, breaks encapsulation, and can bypass security checks, so use it judiciously.

**#. What are annotations and how are they used?**

Annotations are metadata that you add to Java code using @ symbol. They don't directly affect program execution but provide information to the compiler, tools, or runtime. Built-in annotations include @Override, @Deprecated, @SuppressWarnings. Custom annotations can be created by defining an @interface. Retention policy determines when the annotation is available - SOURCE, CLASS, or RUNTIME. They're heavily used by frameworks for configuration, validation, ORM mapping, etc. They make code cleaner than XML configuration.

**#. Explain Java serialization.**

Serialization is converting an object's state into a byte stream so it can be saved to a file or transmitted over a network. Deserialization is the reverse - reconstructing the object from the byte stream. A class must implement Serializable (a marker interface) to be serializable. Use ObjectOutputStream to serialize and ObjectInputStream to deserialize. The transient keyword marks fields that shouldn't be serialized. serialVersionUID helps maintain version compatibility. It's used for persistence, distributed systems, and caching.

**#. What is the transient keyword?**

The transient keyword marks fields that shouldn't be serialized. When an object is serialized, transient fields are ignored - their values aren't saved. After deserialization, transient fields have default values (null for objects, 0 for numbers, false for booleans). Use it for fields that don't need persistence, contain sensitive information, or can be recalculated. For example, passwords, cached values, or derived fields. It only affects serialization, not normal object usage.

**#. Explain the difference between shallow copy and deep copy.**

Shallow copy creates a new object but copies references to nested objects - changes to nested objects affect both copies. Deep copy creates a new object and recursively copies all nested objects - changes don't affect the original. Java's clone() method does shallow copy by default. For deep copy, you need to manually clone nested objects or use serialization. Immutable objects make this simpler since they can be safely shared. Choose based on whether you need complete independence between copies.

**#. What is the instanceof operator used for?**

The instanceof operator is used to test whether an object is an instance of a specific class, subclass, or interface. It returns true or false. It's often used before casting an object to a specific type to avoid a ClassCastException. For example: if (obj instanceof String) { String str = (String) obj; ... }.

**#. What are varargs in Java?**

Varargs (variable-length arguments) is a feature that allows a method to accept zero or multiple arguments of the same type. It's denoted by an ellipsis (...) after the type. For example: public void printNumbers(int... numbers). Inside the method, the varargs parameter is treated as an array of the specified type. It makes it easier to create methods that need to handle an unknown number of arguments.

**#. What is the String.intern() method?**

The intern() method is used to put a String object into the JVM's internal pool of unique strings. When you call intern() on a String, if the pool already contains a string equal to this String object (as determined by the equals() method), then the string from the pool is returned. Otherwise, this String object is added to the pool and a reference to it is returned. This can save memory if you have many duplicate string values, but using it can have performance implications.
