#=
Stack
=#

"""
Space complexity: O(n)
"""
struct SimpleStack{T}
    l::SimpleLinkedList{T}

    SimpleStack{T}() where T = new{T}(SimpleLinkedList{T}())
end

#=
Core methods
=#

"""
Time complexity: O(1)
"""
function Base.push!(ss::SimpleStack{T}, item::T) where T
    push!(ss.l, item)
    return ss
end

"""
Time complexity: O(1)
"""
Base.pop!(ss::SimpleStack) = pop!(ss.l)
