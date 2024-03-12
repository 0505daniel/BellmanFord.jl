struct Edge
    to::Int
    weight::Int #TODO: Check if no float weights are allowed
end

mutable struct Vertex
    id::Int
    edges::Vector{Edge}
    dist::Float64
    predecessor::Int 
    edgeCount::Int 
end

struct Graph
    vertices::Vector{Vertex}
end

function createVertex(id::Int)
    return Vertex(id, [], Inf, 0, 0)
end

function addEdge!(vertex::Vertex, to::Int, weight::Int) #TODO: Check if no float weights are allowed
    push!(vertex.edges, Edge(to, weight))
end

function generateConnectedGraph(numVertices::Int; density::Symbol=:sparse, NEGATIVE_WEIGHT::Bool=false)
    vertices = [createVertex(i) for i in 1:numVertices]
    edgesAdded = Set{Tuple{Int, Int}}()
    
    # Ensure connectivity by adding a spanning tree
    for v in 2:numVertices
        from = rand(1:v-1)
        to = v
        if NEGATIVE_WEIGHT
            weight = rand(-1:10)
        else
            weight = rand(1:10)
        end
        addEdge!(vertices[from], to, weight)
        push!(edgesAdded, (from, to))
    end
    
    if density == :dense
        numAdditionalEdges = rand((numVertices/2):numVertices-1) 
    elseif density == :medium
        numAdditionalEdges = rand((numVertices/3):(numVertices/2))
    elseif density == :sparse
        numAdditionalEdges = rand(1:(numVertices/3))
    end

    while numAdditionalEdges > 0
        from = rand(1:numVertices)
        to = rand(1:numVertices)
        if from != to && !((from, to) in edgesAdded) && !((to, from) in edgesAdded)
            if NEGATIVE_WEIGHT
                weight = rand(-1:10)
            else
                weight = rand(1:10)
            end
            addEdge!(vertices[from], to, weight)
            push!(edgesAdded, (from, to))
            numAdditionalEdges -= 1
        end
    end
    
    return Graph(vertices)
end