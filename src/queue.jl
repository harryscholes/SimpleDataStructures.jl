#=
Queue
=#

"""
Space complexity: O(n)
"""
struct SimpleQueue{T}
    l::SimpleLinkedList{T}

    SimpleQueue{T}() where T = new{T}(SimpleLinkedList{T}())
end

#=
Core methods
=#

"""
Time complexity: O(1)
"""
function Base.push!(sq::SimpleQueue{T}, item::T) where T
    push!(sq.l, item)
    return sq
end

"""
Time complexity: O(1)
"""
Base.pop!(sq::SimpleQueue) = popfirst!(sq.l)
