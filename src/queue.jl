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

#=
# Examples

sq = SimpleQueue{Int}()
enqueue!(sq, 1)
enqueue!(sq, 2)
dequeue!(sq)
enqueue!(sq, 3)
enqueue!(sq, 4)
dequeue!(sq)
dequeue!(sq)
dequeue!(sq)
dequeue!(sq)
=#
