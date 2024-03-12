using DataStructures

include("graph.jl")
include("algorithm.jl")

struct BellmanFordResult
    label_count::Int64
    distances::Dict{Int64, Float64}
    paths::Dict{Int64, Array{Int64, 1}}
end

function solve_directed_graph(
    graph,
    source::Int64,
    sink::Int64=None,
    listtype::Symbol=:fifo
)
    label_count = modifiedBellmanFord(graph, source, listtype)

    return label_count, graph.vertices[sink].dist, reconstructPath(graph, sink)
end

function solve_directed_graph(
    graph,
    source::Int64,
    listtype::Symbol=:fifo
)
    label_count = modifiedBellmanFord(graph, source, listtype)

    distances = Dict{Int64, Float64}()
    paths = Dict{Int64, Array{Int64, 1}}()

    for vertex in vertices(graph)
        distances[vertex] = vertex.dist
        paths[vertex] = reconstructPath(graph, vertex)
    end

    return BellmanFordResult(label_count, distances, paths)
end