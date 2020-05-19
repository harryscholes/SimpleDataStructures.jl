#=
Doubly linked list
=#

"""
Space complexity: O(1)
"""
mutable struct Node{T}
    data::T
    prev::Node{T}
    next::Node{T}

    function Node{T}() where T
        node = new{T}()
        node.prev = node
        node.next = node
        return node
    end

    function Node(x::T) where T
        node = new{T}()
        node.data = x
        return node
    end
end

"""
Doubly linked list

Space complexity: O(n)
"""
mutable struct SimpleLinkedList{T}
    root::Node{T}
    n::Int

    SimpleLinkedList{T}() where T = new{T}(Node{T}(), 0)
end

#=
Core methods
=#

"""
Time complexity: O(1)
"""
function Base.push!(sll::SimpleLinkedList{T}, item::T) where T
    node = Node(item)
    last = sll.root.prev
    last.next = node
    node.prev = last
    node.next = sll.root
    sll.root.prev = node
    sll.n += 1
    return sll
end

"""
Time complexity: O(1)
"""
Base.first(sll::SimpleLinkedList) = sll.root.next.data

"""
Time complexity: O(1)
"""
Base.last(sll::SimpleLinkedList) = sll.root.prev.data

"""
Time complexity: O(1)
"""
function Base.pop!(sll::SimpleLinkedList)
    isempty(sll) && throw(ArgumentError("`SimpleLinkedList` is empty"))
    last = sll.root.prev
    penultimate = last.prev
    penultimate.next = sll.root
    sll.root.prev = penultimate
    sll.n -= 1
    return last.data
end

"""
Time complexity: O(1)
"""
function Base.popfirst!(sll::SimpleLinkedList)
    isempty(sll) && throw(ArgumentError("`SimpleLinkedList` is empty"))
    first = sll.root.next
    second = first.next
    second.prev = sll.root
    sll.root.next = second
    sll.n -= 1
    return first.data
end

"""
Time complexity: O(n)
"""
function Base.getindex(sll::SimpleLinkedList, index::Integer)
    checkbounds(sll, index)
    node = sll.root
    for i in 1:index
        node = node.next
    end
    return node.data
end

"""
Time complexity: O(n)
"""
function Base.setindex!(sll::SimpleLinkedList{T}, item::T, index::Integer) where T
    checkbounds(sll, index)
    node = sll.root
    for i in 1:index
        node = node.next
    end
    node.data = item
end

"""
Time complexity: O(n)
"""
function Base.insert!(sll::SimpleLinkedList{T}, index::Integer, item::T) where T
    checkbounds(sll, index)
    new_node = Node(item)
    node = sll.root
    for i in 1:index - 1
        node = node.next
    end
    prev_node = node
    next_node = node.next
    prev_node.next = new_node
    new_node.prev = prev_node
    next_node.prev = new_node
    new_node.next = next_node
    sll.n += 1
    return sll
end

"""
Time complexity: O(n)
"""
function Base.deleteat!(sll::SimpleLinkedList, index::Integer)
    checkbounds(sll, index)
    node = sll.root
    for i in 1:index - 1
        node = node.next
    end
    prev_node = node
    next_node = node.next.next
    prev_node.next = next_node
    next_node.prev = prev_node
    sll.n -= 1
    return sll
end

#=
Interface
=#

Base.length(sll::SimpleLinkedList) = sll.n
Base.isempty(sll::SimpleLinkedList) = sll.n < 1
Base.eltype(sll::SimpleLinkedList{T}) where T = T

function Base.iterate(sll::SimpleLinkedList)
    length(sll) == 0 && return nothing
    return sll.root.next.data, sll.root.next.next
end

function Base.iterate(sll::SimpleLinkedList, n::Node)
    n === sll.root && return nothing
    return n.data, n.next
end

function Base.checkbounds(sll::SimpleLinkedList, index::Integer)
    1 ≤ index ≤ length(sll) || throw(BoundsError(sll, index))
    return nothing
end
