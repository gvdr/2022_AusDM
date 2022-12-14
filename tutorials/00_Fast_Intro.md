~~~
<!-- PlutoStaticHTML.Begin -->
<!--
    # This information is used for caching.
    [PlutoStaticHTML.State]
    input_sha = "c10a6061eae81df017cbd0a1a5fe1f73843ab27d47d6a386eb29d2201798d3bb"
    julia_version = "1.8.3"
-->

<div class="markdown"><h1>All of Julia in 5 minute or less</h1>
<p>for people with some coding experience.</p>
</div>


<div class="markdown"><h2>Array notation</h2>
</div>

<pre class='language-julia'><code class='language-julia'># Arrays have commas
[1, 2, 3]</code></pre>
<pre id='var-hash505539' class='code-output documenter-example-output'>3-element Vector{Int64}:
 1
 2
 3</pre>

<pre class='language-julia'><code class='language-julia'> # Matrices have spaces for columns and semicolons for rows
 [1 2; 3 4]</code></pre>
<pre id='var-hash200414' class='code-output documenter-example-output'>2×2 Matrix{Int64}:
 1  2
 3  4</pre>

<pre class='language-julia'><code class='language-julia'> [1 2
  3 4]</code></pre>
<pre id='var-hash150334' class='code-output documenter-example-output'>2×2 Matrix{Int64}:
 1  2
 3  4</pre>

<pre class='language-julia'><code class='language-julia'># Tensors have triple semicolons
[1 2
 3 4 ;;;
 5 6
 7 8]</code></pre>
<pre id='var-hash125472' class='code-output documenter-example-output'>2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 5  6
 7  8</pre>


<div class="markdown"><p><strong>counting starts from 1</strong>. Deal with it ;-P</p>
</div>

<pre class='language-julia'><code class='language-julia'>tenzor = [1 2
 3 4 ;;;
 5 6
 7 8]</code></pre>
<pre id='var-tenzor' class='code-output documenter-example-output'>2×2×2 Array{Int64, 3}:
[:, :, 1] =
 1  2
 3  4

[:, :, 2] =
 5  6
 7  8</pre>

<pre class='language-julia'><code class='language-julia'>matriz = tenzor[:,1,:] # notice the projection</code></pre>
<pre id='var-matriz' class='code-output documenter-example-output'>2×2 Matrix{Int64}:
 1  5
 3  7</pre>


<div class="markdown"><h2>Array algebra</h2>
</div>

<pre class='language-julia'><code class='language-julia'>matriz + matriz</code></pre>
<pre id='var-hash147139' class='code-output documenter-example-output'>2×2 Matrix{Int64}:
 2  10
 6  14</pre>

<pre class='language-julia'><code class='language-julia'>matriz + matriz'</code></pre>
<pre id='var-hash742163' class='code-output documenter-example-output'>2×2 Matrix{Int64}:
 2   8
 8  14</pre>


<div class="markdown"><p>the <strong>dot</strong> . <em>broadcasts</em> a function over an array:</p>
</div>

<pre class='language-julia'><code class='language-julia'>matriz .+ 1</code></pre>
<pre id='var-hash117535' class='code-output documenter-example-output'>2×2 Matrix{Int64}:
 2  6
 4  8</pre>

<pre class='language-julia'><code class='language-julia'>(1:5) * (1:5)'</code></pre>
<pre id='var-hash110819' class='code-output documenter-example-output'>5×5 Matrix{Int64}:
 1   2   3   4   5
 2   4   6   8  10
 3   6   9  12  15
 4   8  12  16  20
 5  10  15  20  25</pre>

<pre class='language-julia'><code class='language-julia'>(1:5) .* (1:5)</code></pre>
<pre id='var-hash153139' class='code-output documenter-example-output'>5-element Vector{Int64}:
  1
  4
  9
 16
 25</pre>


<div class="markdown"><h2>GPU</h2>
</div>

<pre class='language-julia'><code class='language-julia'>using CUDA # &lt;- load a library</code></pre>


<pre class='language-julia'><code class='language-julia'># I don't have an NVIDIA gpu here
# go on malatesta
# x = cu(rand(5, 3))</code></pre>



<div class="markdown"><h2>Type type typed</h2>
<p>Julia has a rich <a href="https://docs.julialang.org/en/v1/manual/types/">type system</a>, and powerful dispatch methods.</p>
<p>Use them, they are your friends.</p>
</div>

<pre class='language-julia'><code class='language-julia'>typeof(π)</code></pre>
<pre id='var-hash171382' class='code-output documenter-example-output'>Irrational{:π}</pre>

<pre class='language-julia'><code class='language-julia'>typeof(3.14)</code></pre>
<pre id='var-hash186669' class='code-output documenter-example-output'>Float64</pre>

<pre class='language-julia'><code class='language-julia'>Real[1, 2.0, π]</code></pre>
<pre id='var-hash528885' class='code-output documenter-example-output'>3-element Vector{Real}:
 1
 2.0
 π = 3.1415926535897...</pre>

<pre class='language-julia'><code class='language-julia'>Float64[1,2,π]</code></pre>
<pre id='var-hash124270' class='code-output documenter-example-output'>3-element Vector{Float64}:
 1.0
 2.0
 3.141592653589793</pre>


<div class="markdown"><p>There is a couple of ways of defining functions. This is one:</p>
</div>

<pre class='language-julia'><code class='language-julia'>fff(x) = typeof(x) == Int ? "f"^x : "miao"</code></pre>
<pre id='var-fff' class='code-output documenter-example-output'>fff (generic function with 1 method)</pre>


<div class="markdown"><p>we can do better using types and dispatching</p>
</div>

<pre class='language-julia'><code class='language-julia'>begin
ff(x) = "miao"
ff(x::Int) = "f"^x
end</code></pre>
<pre id='var-ff' class='code-output documenter-example-output'>ff (generic function with 2 methods)</pre>

<pre class='language-julia'><code class='language-julia'>ff(4.5)</code></pre>
<pre id='var-hash890548' class='code-output documenter-example-output'>"miao"</pre>

<pre class='language-julia'><code class='language-julia'>ff(8)</code></pre>
<pre id='var-hash960694' class='code-output documenter-example-output'>"ffffffff"</pre>

<pre class='language-julia'><code class='language-julia'>ff.([1,4,"ciao",4.0,6])</code></pre>
<pre id='var-hash168527' class='code-output documenter-example-output'>5-element Vector{String}:
 "f"
 "ffff"
 "miao"
 "miao"
 "ffffff"</pre>

<pre class='language-julia'><code class='language-julia'> @code_lowered ff(8)</code></pre>
<pre id='var-hash118123' class='code-output documenter-example-output'>CodeInfo(
1 ─ %1 = "f" ^ x
└──      return %1
)</pre>

<pre class='language-julia'><code class='language-julia'>@code_typed ff(8)</code></pre>
<pre id='var-hash166641' class='code-output documenter-example-output'>CodeInfo(
1 ─ %1 = invoke Base.repeat("f"::String, x::Int64)::String
└──      return %1
) => String</pre>

<pre class='language-julia'><code class='language-julia'>@code_llvm ff(8)</code></pre>


<pre class='language-julia'><code class='language-julia'>@code_native ff(8)</code></pre>



<div class="markdown"><h2>AI</h2>
</div>

<pre class='language-julia'><code class='language-julia'>using Flux</code></pre>


<pre class='language-julia'><code class='language-julia'>using Flux: params</code></pre>


<pre class='language-julia'><code class='language-julia'>NN_model = Chain(
    Dense(10,5,relu),
    Dense(5,2,relu),
    softmax
)</code></pre>
<pre id='var-NN_model' class='code-output documenter-example-output'>Chain(
  Dense(10 => 5, relu),                 # 55 parameters
  Dense(5 => 2, relu),                  # 12 parameters
  NNlib.softmax,
)                   # Total: 4 arrays, 67 parameters, 524 bytes.</pre>

<pre class='language-julia'><code class='language-julia'>pₙₙ = params(NN_model)</code></pre>
<pre id='var-pₙₙ' class='code-output documenter-example-output'>Params([Float32[-0.3394587 -0.4917924 … -0.42839822 0.14853561; 0.5374313 -0.36971772 … 0.2575355 -0.59711635; … ; -0.5401597 -0.0074484563 … 0.12053383 0.4985586; -0.25185105 0.20210315 … -0.10787606 0.57953155], Float32[0.0, 0.0, 0.0, 0.0, 0.0], Float32[0.6839579 -0.8135689 … -0.75520873 -0.7309942; -0.3706536 -0.7086955 … -0.20821618 0.8319535], Float32[0.0, 0.0]])</pre>

<pre class='language-julia'><code class='language-julia'>rand_input = rand(Float32, 10)</code></pre>
<pre id='var-rand_input' class='code-output documenter-example-output'>10-element Vector{Float32}:
 0.8823784
 0.62837523
 0.26190466
 0.5754853
 0.2443623
 0.26416337
 0.7277685
 0.4581483
 0.06500381
 0.40792662</pre>

<pre class='language-julia'><code class='language-julia'>l(x) = Flux.Losses.crossentropy(NN_model(x), [0.5, 0.5])</code></pre>
<pre id='var-l' class='code-output documenter-example-output'>l (generic function with 1 method)</pre>

<pre class='language-julia'><code class='language-julia'>l(rand_input)</code></pre>
<pre id='var-hash663466' class='code-output documenter-example-output'>0.698170393705368</pre>

<pre class='language-julia'><code class='language-julia'>grads = gradient(pₙₙ) do
    l(rand_input)
end</code></pre>
<pre id='var-grads' class='code-output documenter-example-output'>Grads(...)</pre>

<pre class='language-julia'><code class='language-julia'>for p in pₙₙ
    println(grads[p])
end</code></pre>


<pre class='language-julia'><code class='language-julia'>using Flux.Optimise: update!, Descent</code></pre>


<pre class='language-julia'><code class='language-julia'>begin
    
η = 0.1
for p in pₙₙ
  update!(p, η * grads[p])
end
    
end</code></pre>



<div class="markdown"><p>And a large varaiety of optimisers are predefined</p>
</div>

<pre class='language-julia'><code class='language-julia'>my_optimisers = Descent(0.01)</code></pre>
<pre id='var-my_optimisers' class='code-output documenter-example-output'>Descent(0.01)</pre>

<pre class='language-julia'><code class='language-julia'>data, labels = rand(10, 100), fill(0.5, 2, 100)</code></pre>
<pre id='var-labels' class='code-output documenter-example-output'>([0.7815919226843753 0.6174080820903107 … 0.2576920239695416 0.039748842399825235; 0.5353542480610113 0.9182202481854659 … 0.26564117585104485 0.2434559057716722; … ; 0.9837556448226826 0.49472477351996835 … 0.9096512833979349 0.9179341448593525; 0.006631804018282228 0.009824532641440786 … 0.18500130003408688 0.6764573810543957], [0.5 0.5 … 0.5 0.5; 0.5 0.5 … 0.5 0.5])</pre>

<pre class='language-julia'><code class='language-julia'>my_loss(x, y) = Flux.Losses.crossentropy(NN_model(x), y)</code></pre>
<pre id='var-my_loss' class='code-output documenter-example-output'>my_loss (generic function with 1 method)</pre>

<pre class='language-julia'><code class='language-julia'>Flux.train!(
    my_loss,
    pₙₙ,
    [(data,labels)],
    my_optimisers)</code></pre>

<div class='manifest-versions'>
<p>Built with Julia 1.8.3 and</p>
CUDA 3.12.0<br>
Flux 0.13.9
</div>

<!-- PlutoStaticHTML.End -->
~~~