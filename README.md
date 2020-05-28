# SimpleDataStructures.jl

This package implements data structures — **simply**.

Code that is essential for the data structures to work is included; everything else is left out.

- All data structures are implemented in Julia in `src/`
- Implementations show off the flexibility and extensibility of Julia's type system: the new types *just work*™
- Complexities are provided:
    - Space complexities for data structures
    - Time complexities for methods
- Examples of the APIs are provided in `examples/`

Data structures implemented:
- `SimpleVector`
- `SimpleSparseVector`
- `SimpleDict`
- `SimpleDefaultDict`
- `SimpleLinkedList`
- `SimpleStack`
- `SimpleQueue`

Methods implemented:
- Access
    - `getindex`
    - `setindex!`
- Search
    - `haskey`
    - `in`
- Insertion
    - `insert!`
    - `push!`
    - `pushfirst!`
- Deletion
    - `delete!`
    - `deleteat!`
    - `pop!`
    - `popfirst!`

This package is largely for demonstration purposes only and not for production use.
