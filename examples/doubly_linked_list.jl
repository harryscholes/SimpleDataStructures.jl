#=
Doubly linked list
=#

using SimpleDataStructures

sll = SimpleLinkedList{Int}()
push!(sll, 1)
push!(sll, 2)
push!(sll, 3)
first(sll)
last(sll)

sll[9]

insert!(sll, 3, 10)
insert!(sll, 4, 100)
collect(sll)
deleteat!(sll, 3)
deleteat!(sll, 3)
pop!(sll)
popfirst!(sll)
collect(sll)
