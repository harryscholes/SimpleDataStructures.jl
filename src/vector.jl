using .Libc: malloc, realloc

# Space complexity: O(n)
mutable struct SimpleVector{T} <: AbstractVector{T}
    buffer::Ptr{T}
    size::Int
    capacity::Int

    # Only allow isbitstypes for simplicity
    function SimpleVector{T}(buffer::Ptr{T}, size::Integer, capacity::Integer) where T
        isbitstype(T) || throw(ArgumentError("Elements of `SimpleVector` must be `isbitstype`")
        new{T}(buffer, size, capacity)
    end
end

function SimpleVector{T}(; capacity::Integer = 2) where T
    n_bits = sizeof(T) * 8 * capacity
    buffer = convert(Ptr{T}, malloc(n_bits))
    SimpleVector{T}(buffer, 0, capacity)
end

function SimpleVector(xs::T...) where T
    sv = SimpleVector{T}(capacity = length(xs))
    for x in xs
        push!(sv, x)
    end
    return sv
end

# Time complexity: O(1)
Base.size(sv::SimpleVector) = (sv.size,)

# Time complexity: O(1)
function Base.getindex(sv::SimpleVector{T}, i::Integer)::T
    checkbounds(sv, i)
    return unsafe_load(sv.buffer, i)
end

# Time complexity: O(1)
function Base.setindex!(sv::SimpleVector{T}, x, i::Integer) where T
    x_T = convert(T, x)
    checkbounds(sv, i)
    unsafe_store!(sv.buffer, x_T, i)
    return sv
end

# Time complexity: Θ(1) amortised, O(1) worst case
function Base.push!(sv::SimpleVector{T}, x) where T
    x_T = convert(T, x)
    sv.size += 1
    if sv.size > sv.capacity
        resize!(sv, sv.capacity * 2)
    end
    setindex!(sv, x_T, sv.size)
end

# O(n)
function Base.resize!(sv::SimpleVector{T}, n::Integer) where T
    n_bits = sizeof(T) * 8 * n
    sv.buffer = realloc(sv.buffer, n_bits)
    sv.capacity = n
    if n < sv.size
        sv.size = n
    end
    return sv
end

# Base.sizehint!(sv::SimpleVector, n::Integer) = resize!(sv, n)

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

SimpleVector(1, 2, 3, 4, 5, 6, 7)
=#
