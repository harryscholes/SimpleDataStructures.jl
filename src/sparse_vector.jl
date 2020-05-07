using SparseArrays
import SparseArrays: AbstractSparseVector, nonzeros, nonzeroinds

#=
Sparse vector
=#

"""
Space complexity: O(m)
"""
mutable struct SimpleSparseVector{T} <: AbstractSparseVector{T, Int}
    n::Int
    indices::Vector{Int}
    values::Vector{T}

    function SimpleSparseVector(n::Integer, indices::Vector{<:Integer}, values::Vector{T}) where T
        n ≥ 0 || throw(ArgumentError("`n` must be ≥ 0"))
        length(indices) == length(values) || throw(ArgumentError("`indices` and `values` must be the same length"))
        new{T}(n, indices, values)
    end
end

#=
Constructors
=#

SimpleSparseVector{T}(n::Integer) where T = SimpleSparseVector(n, Int[], T[])

#=
Core methods
=#

"""
Time complexity: O(m)
"""
function Base.getindex(ssv::SimpleSparseVector{T}, i::Integer) where T
    checkbounds(ssv, i)
    indices = nonzeroinds(ssv)
    values = nonzeros(ssv)
    j = searchsortedfirst(indices, i)
    if j ≤ length(indices) && indices[j] == i
        return values[j]
    end
    return zero(T)
end

"""
Time complexity: O(m)
"""
function Base.setindex!(ssv::SimpleSparseVector{T}, v::T, i::Integer) where T
    checkbounds(ssv, i)
    indices = nonzeroinds(ssv)
    values = nonzeros(ssv)
    j = searchsortedfirst(indices, i)
    if 1 ≤ j ≤ length(indices) && indices[j] == i
        values[j] = v
    elseif !iszero(v)
        insert!(indices, j, i)
        insert!(values, j, v)
    end
    return ssv
end

"""
Time complexity: O(m)
"""
function Base.insert!(ssv::SimpleSparseVector{T}, index::Integer, item::T) where T
    checkbounds(ssv, index)
    indices = nonzeroinds(ssv)
    ssv.n += 1
    for i in 1:length(indices)
        if indices[i] ≥ index
            indices[i] += 1
        end
    end
    setindex!(ssv, item, index)
end

"""
Time complexity: O(m)
"""
function Base.deleteat!(ssv::SimpleSparseVector, index::Integer)
    checkbounds(ssv, index)
    indices = nonzeroinds(ssv)
    values = nonzeros(ssv)
    j = findfirst(==(index), indices)
    if !isnothing(j)
        deleteat!(indices, j)
        deleteat!(values, j)
    end
    for i in 1:length(indices)
        if indices[i] ≥ index
            indices[i] -= 1
        end
    end
    ssv.n -= 1
    return ssv
end

#=
Interface
=#

SparseArrays.nonzeros(ssv::SimpleSparseVector) = ssv.values

SparseArrays.nonzeroinds(ssv::SimpleSparseVector) = ssv.indices

Base.size(ssv::SimpleSparseVector) = (ssv.n,)

IndexStyle(::SimpleSparseVector) = IndexLinear


# Examples

#=
ssv = SimpleSparseVector(100, [1, 10, 50], rand(3))
ssv[1]
ssv[2]
ssv[50]
# ssv[101]
ssv[3] = rand()
insert!(ssv, 10, rand())
ssv[101]
deleteat!(ssv, 20)
deleteat!(ssv, 3)
ssv

ssv = SimpleSparseVector{Float64}(100)
ssv[50] = rand()
=#
