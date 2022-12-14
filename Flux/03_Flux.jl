using Pkg
Pkg.activate(".")

using OhMyREPL

using Flux

dense_layers = Chain(
    Dense(10,5),
    Dense(5,2),
    softmax
)
pms = Flux.params(dense_layer)

pms[1]
pms[2]
pms[3]
pms[4]

opt = Descent(0.01)

# `Training` a network reduces down to iterating on a dataset multiple times, performing these
# steps in order. Just for a quick implementation, let’s train a network that learns to predict
# `0.5` for every input of 10 floats. `Flux` defines the `train!` function to do it for us.

data, labels = rand(10, 100), fill(0.5, 2, 100)
loss(x, y) = Flux.Losses.crossentropy(dense_layers(x), y)
Flux.train!(loss, Flux.params(dense_layers), [(data,labels)], opt)