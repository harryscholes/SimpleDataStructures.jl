using SparseArrays

struct SimpleSparseVector{T} <: AbstractSparseArray{T, Int, 1}
    n::Int
    indices::Vector{Int}
    values::Vector{T}

    function SimpleSparseVector(n::Integer, indices::Vector{<:Integer}, values::Vector{T}) where T
        n ≥ 0 || throw(ArgumentError("`n` must be ≥ 0"))
        length(indices) == length(values) || throw(ArgumentError("`indices` and `values` must be the same length"))
        new{T}(n, indices, values)
    end
end

SimpleSparseVector{T}(n::Integer) where T = SimpleSparseVector(n, Int[], T[])

SparseArrays.nonzeros(ssv::SimpleSparseVector) = ssv.values
SparseArrays.nonzeroinds(ssv::SimpleSparseVector) = ssv.indices

Base.size(ssv::SimpleSparseVector) = (ssv.n,)

function Base.getindex(ssv::SimpleSparseVector{T}, i::Integer) where T
    checkbounds(ssv, i)
    indices = nonzeroinds(sv)
    values = nonzeros(ssv)
    j = searchsortedfirst(indices, i)
    if j ≤ length(indices) && indices[j] == i
        return values[j]
    end
    return zero(T)
end

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

#=
# Examples

v = rand(3)
ssv = SimpleSparseVector(100, [1, 10, 50], v)
ssv[1]
ssv[2]
ssv[50]
ssv[101]
ssv[3] = rand()
ssv

ssv = SimpleSparseVector{Float64}(100)
ssv[50] = rand()
=#
