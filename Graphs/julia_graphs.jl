using Pkg
Pkg.activate(".")

using Random
using UnicodePlots

# For first toy example
using Graphs, CommunityDetection, GraphPlot
using GeometricFlux, GeometricFlux.Datasets
using MLDatasets
using Clustering

# for Graph Convolution Network
using Flux
using Flux: onehotbatch, onecold
using Flux.Losses: logitcrossentropy
using Flux.Data: DataLoader
using Statistics

Random.seed!(42)

karate = smallgraph(:karate)

clusters = [1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 2, 2, 1, 1, 2, 1, 2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]

int2col_str(x::Int) = x==1 ? "lightblue" : "red"

karate_feature = karate |> FeaturedGraph
karatembedding = karate_feature |> node2vec
karate_communities = kmeans(karatembedding, 2)

learned_clusters = copy(assignments(karate_communities))
# ensure that the cluster containing node 1 is cluster 1
if assignments(karate_communities)[1] != 1
    learned_clusters = [i == 1 ? 2 : 1 for i in assignments(karate_communities)]
end


gplot(karate,
    nodelabel=map(string, 1:34),
    nodefillc=[int2col_str(learned_clusters[i]) for i in 1:34],
    nodestrokec=["white" for _ in 1:34]
)

incorrect = sum(learned_clusters .!= clusters)

## A complex(er) example: convolution on a citation network

#' ?Cora
#' PubMed(), CiteSeer()

s, t = Cora()[1].edge_index
CitationNet = Graph(Cora()[1].num_nodes)
for (i, j) in zip(s, t)
    add_edge!(CitationNet, i, j)
end
fCitationNet = FeaturedGraph(CitationNet)


data = Cora()[1].node_data
X, y = data.features, onehotbatch(data.targets, 1:7)
train_idx, test_idx = data.train_mask, data.val_mask


train_X, train_y = repeat(X, outer=(1,1,128)), repeat(y, outer=(1,1,128))
test_X, test_y = repeat(X, outer=(1,1,16)), repeat(y, outer=(1,1,16))

model = Chain( # The same Chaining we saw in Flux
    WithGraph(fCitationNet, # The secret sauce of GeometricFlux for static graphs
        GCNConv(size(train_X)[1] => 14, relu)), # Graph Convolutional layer
    Dropout(0.5),
    WithGraph(fCitationNet,
        GCNConv(14 => 7)),
)
ps = Flux.params(model)

# and some boilerplate for training it all:

# data loaders for batched learning

train_loader = DataLoader((train_X, train_y), batchsize=Int(size(train_X)[3]/2), shuffle=true)
test_loader = DataLoader((test_X, test_y), batchsize=Int(size(test_X)[3]/2), shuffle=true)

# a personalised loss function

l2norm(x) = sum(abs2, x)

function model_loss(model, λ, X, y, idx)
    loss = logitcrossentropy(model(X)[:,idx,:], y[:,idx,:])
    loss += λ*sum(l2norm, Flux.params(model[1]))
    return loss
end

accuracy(model, X::AbstractArray, y::AbstractArray, idx) =
    mean(onecold(softmax(model(X)[:,idx,:])) .== onecold(y[:,idx,:]))

accuracy(model, loader::DataLoader, idx) =
    mean(accuracy(model, X, y, idx) for (X, y) in loader)

#' And now we train!

optimizer = Adam(0.01)

train_steps = 0
train_accuracies = Float64[]
test_accuracies = Float64[]
for epoch in 1:5
    @show epoch
for (X_tl, y_tl) in train_loader
    loss, back = Flux.pullback(() -> model_loss(model, 0.01, X_tl, y_tl, train_idx), ps)
    train_acc = accuracy(model, train_loader, train_idx)
    test_acc = accuracy(model, test_loader, test_idx)
    grad = back(1f0)
    Flux.Optimise.update!(optimizer, ps, grad)
    train_steps += 1
    push!(train_accuracies, train_acc)
    push!(test_accuracies, test_acc)
end
@show last(train_accuracies), last(test_accuracies)
end

lineplot(1:length(train_accuracies), [train_accuracies test_accuracies], name = ["train" "test"])

