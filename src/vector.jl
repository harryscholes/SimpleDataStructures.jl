using .Libc: malloc, realloc

#=
Vector
=#

"""
Space complexity: O(n)
"""
mutable struct SimpleVector{T} <: AbstractVector{T}
    buffer::Ptr{T}
    size::Int
    capacity::Int

    # Only allow isbitstypes for simplicity
    function SimpleVector{T}(buffer::Ptr{T}, size::Integer, capacity::Integer) where T
        isbitstype(T) || throw(ArgumentError("eltype of `SimpleVector` must be `isbitstype`"))
        new{T}(buffer, size, capacity)
    end
end

#=
Constructors
=#

function SimpleVector{T}(; size::Integer = 0, capacity::Integer = 2) where T
    size ≤ capacity || throw(ArgumentError("`size` must be ≤ `capacity`"))
    n_bits = sizeof(T) * 8 * capacity
    buffer = convert(Ptr{T}, malloc(n_bits))
    SimpleVector{T}(buffer, size, capacity)
end

function SimpleVector(xs::T...) where T
    n = length(xs)
    sv = SimpleVector{T}(size = n, capacity = n)
    for i in 1:n
        sv[i] = xs[i]
    end
    return sv
end

function SimpleVector(xs::AbstractVector{T}) where T
    n = length(xs)
    sv = SimpleVector{T}(size = n, capacity = n)
    for i in 1:n
        sv[i] = xs[i]
    end
    return sv
end

#=
Core methods
=#

"""
Time complexity: O(1)
"""
function Base.getindex(sv::SimpleVector{T}, i::Integer)::T where T
    checkbounds(sv, i)
    return unsafe_load(sv.buffer, i)
end

"""
Time complexity: O(1)
"""
function Base.setindex!(sv::SimpleVector{T}, x, i::Integer) where T
    x_T = convert(T, x)
    checkbounds(sv, i)
    unsafe_store!(sv.buffer, x_T, i)
    return sv
end

"""
Time complexity: amortised O(1), O(n) worst case
"""
function Base.push!(sv::SimpleVector{T}, x) where T
    x_T = convert(T, x)
    sv.size += 1
    if sv.size > sv.capacity
        resize!(sv, 2^ceil(Int, log2(sv.capacity)))
    end
    setindex!(sv, x_T, sv.size)
end

"""
Time complexity: O(n)
"""
function Base.resize!(sv::SimpleVector{T}, n::Integer) where T
    if sv.capacity == n
        return sv
    end
    n_bits = sizeof(T) * 8 * n
    sv.buffer = realloc(sv.buffer, n_bits)
    sv.capacity = n
    if n < sv.size
        sv.size = n
    end
    return sv
end

"""
Time complexity: O(n)
"""
function Base.insert!(sv::SimpleVector{T}, index::Integer, item::T) where T
    checkbounds(sv, index)
    if sv.size == sv.capacity
        resize!(sv, sv.capacity + 1)
    end
    sv.size += 1
    for i = sv.size-1:-1:index
        sv[i+1] = sv[i]
    end
    sv[index] = item
    return sv
end

"""
Time complexity: O(n)
"""
function Base.deleteat!(sv::SimpleVector, index::Integer)
    checkbounds(sv, index)
    for i = index:sv.size-1
        sv[i] = sv[i+1]
    end
    sv.size -= 1
    return sv
end

#=
Interface
=#

Base.size(sv::SimpleVector) = (sv.size,)

IndexStyle(::SimpleVector) = IndexLinear


#=
# Examples

sv = SimpleVector{Int}()
dump(sv)
for i = 1:4
    push!(sv, i)
    @show sv.size, sv.capacity
end
sv
sv[1] = 10
resize!(sv, 3)
dump(sv)

SimpleVector([1, 2, 3])

sv = SimpleVector{Int}()
sizehint!(sv, 100)
for i = 1:100
    push!(sv, i)
    @show sv.size, sv.capacity
end

sv = SimpleVector{Int}()
push!(sv, 2.)
push!(sv, "hello")

sv = SimpleVector{Complex{Float64}}()
push!(sv, complex(7, 3))
push!(sv, 1//2)
push!(sv, π)

SimpleVector(1, 2, 3, 4)

x = SimpleVector(1:10...)
insert!(x, 3, 100)
deleteat!(x, 3)
=#
