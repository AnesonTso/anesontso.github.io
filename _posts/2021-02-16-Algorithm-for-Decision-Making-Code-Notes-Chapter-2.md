---
title: Algorithm for Decision Making Code Notes Chapter 2
mathjax: true
date: 2021-02-16
tags: Probability
comment: true
code:
  copy_btn: true
  highlight:
    enable: true
    line_number: true
    lib: "highlightjs"
    highlightjs:
      style: 'Github Gist'
      bg_color: false
    prismjs:
      style: "default"
      preprocess: true
---

Currently reading the nicely written book *Algorithm for Decision Making*[^1] and happen to be a current [julia](https://julialang.org) beginner, so I decided to put my comments of the code snippets into a series of blog posts explaining in detail the code implementation associated with this book in a hope to strengthen my grasp on the promising julia language and the understanding of this book as well. Doing a single thing to harvest double benefits is the reason behind this series.

I am still new to julia language and technologies empowering it and also the programming world. If there are any mistakes or misunderstandings, please let me know and feedbacks are welcome in the comments.

## Variable

Algorithm 2.1 defines a struct called `Variable` which is the basic buiding block of a network.

```julia
struct Variable
	name::Symbol
	m::Int
end
```

Because variable so far only deals with discrete states, for example, binary state where $1$ stands for success/occur and $0$ for failure/not occur, $m$ is the number of discrete values a variable can take. For a binary variable, the $m$ associated with the instance of that variable is $2$, and for a ternary variable, the $m$ is $3$.

Key word `struct` is used to *define* **composite type** and a composite type is a type storing objects with varying types, each object is represented as a `field` of the composite type. In this case, a composite type named `Variable` has two fields where one called `name` is of a `Symbol` type and indicates the name of the variable, and the other called `m` is of `Int` type and is used to indicate the number of states a variable can take.

The previous struct syntax only defines what a variable should look like, or how it should be constructed from pre-defined types, i.e., `Int` or `Symbol`, therefore, it is an abstract description of variable. To really **instantiate** a variable, in other words, to construct a specific variable from this description, we should provide specific information about the variable.

```julia
X = Variable(:x, 2)
Y = Variable(:y, 2)
Z = Variable(:z, 2)
```

The `Variable` looks similar to a function, which accepts arguments contained in the parentheses. Since `Variable` is not the name of a function defined beforehand, but the name of the struct that was defined, the `Variable()` structure is a special function called **constructor**.

The syntax `Variable(:x, 2)` returns an **instance** of the struct `Variable` with `name` being `:x` and `m` being $2$. Similar for `Y` and `Z`.

## Factor

```julia
const Assignment = Dict{Symbol, Int}
const FactorTable = Dict{Assignment, Float64}
```

Both `Dict{Symbol, Int}` and `Dict{Assignment, Float64}` are *parametric* types where the parameters are contained in the curly brackets. A dictionary type `Dict` has two parameters, since a dictionary contains key-value pairs, one for type of keys and one for type of values. In this case, the former indicates a dictionary type which has symbol as key and integer as value, and the latter defines a dictionary where the key is of type `Assignment` and the value is a float number. Those two dictionary types are respectively assigned to variables named `Assignment` and `FactorTable`.

An assignment is described as symbol-integer pair, for example, `:x => 1, :y => 0`, which can be constructed by,

```julia
Dict{Symbol, Int}(:x => 1, :y => 0)
```

But since `Dict{Symbol, Int}` is assigned to `Assignment`, we can express it in a more compact and reader-friendly form,
```julia
Assignment(:x => 1, :y => 0)
```

Similar to `FactorTable` which is a dictionary of Assignment-float number pairs, we can express it in a compact way as well,
```julia
FactorTable(Assignment(:x => 0, :y => 0) => 0.4,
			Assignment(:x => 0, :y => 1) => 0.1,
			Assignment(:x => 1, :y => 0) => 0.2,
			Assignment(:x => 1, :y => 1) => 0.3)
```

A factor table collects assignment from random variables to their realization to real values. And the `Factor`, the abstraction of factor in the computer world is constructed by,

```julia
struct Factor
	vars::Vector{Variable}
	table::FactorTable
end
```

`Factor` is constructed with two fields: `vars` and `table`. `vars` is of type `Vector{Variable}`. `Vector` is the alias for `Array{T} where T` just as `Assignment` for `Dict{Symbol, Int}`. And the field `table` is of type `FactorTable` which is actually the `Dict{Assignment, Float64}`.

```julia
select(a::Assignment, varnames::Vector{Symbol}) =
	Assignment(n => a[n] for n in varnames)
```

`select` returns from original assignment a reduced assignment whose symbol-integer pairs are consistent with the selected variable names.

```julia
function assignments(vars::AbstractVector{Variable})
	names = [var.name for var in vars]
	return vec([Assignment(n => v for (n, v) in zip(names, values))
		for values in Iterators.product((1:v.m for v in vars)...)])
end
```

`assignments` is defined in nested way and I will explain it layer by layer.

1. `Iterators.product(1:v.m for v in vars)...)`: number of states of each variable is retrived and used to construct iterators incrementing from `1` to `m`. `...` is used to take every iterators as each argument for function `Iterators.product`. `Iterators.product` construct Cartesian product from the combination of its argument, for example,

```julia
for p in Iterators.product(1:2, 1:3)
	println(p)
end

>> (1, 1)
>> (1, 2)
>> (1, 3)
>> (2, 1)
>> (2, 2)
>> (2, 3)
```

2. `[Assignment(n=>v for (n,v) in zip(names, values)) for values in Iterators.product((1:v.m for v in vars))]`: the `Iterators.product` function is incorperated in a list comprehension. Each combination produced by the Cartesian product is the combination of values the variables take. `Assignment(n=>v) for (n,v) in zip(names, values)` assigns value to corresponding variable to construct assignment.

Overall, function `assignments` creates an array of all possible assignments the combination of variables can take.

```julia
function normalize!(φ::Factor)
	z = sum(p for (a, p) in φ.table)
	for (a, p) in φ.table
		φ.table[a] = p / z
	end
	return φ
end
```

Factor itself is a mapping from assignment to float number, which doesn't necessarily sum to one therefore, `normalize!` is defined to *normalize* a factor such that probabilities of all assignments consistent with a distribution sums to one.

Now it's ready to construct a factor, which combines two objects: `Variable` and `FactorTable`, therefore,

```julia
φ = Factor([X, Y], FactorTable(
			Assignment(:x => 0, :y => 0) => 0.4,
			Assignment(:x => 0, :y => 1) => 0.1,
			Assignment(:x => 1, :y => 0) => 0.2,
			Assignment(:x => 1, :y => 1) => 0.3))
```

It can be tedious to write the pair operator `=>`, it would be nice to express it in a compact way as,

```julia
φ = Factor([X, Y], FactorTable(
			(x = 0, y = 0) => 0.4,
			(x = 0, y = 1) => 0.1,
			(x = 1, y = 0) => 0.2,
			(x = 1, y = 1) => 0.3))
```

Notice the change here, the `Assignment`, or `Dict{Symbol, Int}` is replaced by a `NamedTuple`, that is, the `Assignment` was constructed from `Symbol`-`Integer` pairs now is constructed from a `NamedTuple`. Therefore, we need to **overload** the constructor of `Assignment`.

```julia
Assignment(a::NamedTuple) =
	Assignment(n => v for (n, v) in zip(keys(a), values(a)))
Base.convert(::Type{Assignment}, nt::NamedTuple) = Assignment(nt)
Base.isequal(a::Assignment, nt::NamedTuple) = length(a) == length(nt)
	&& all(a[n] == v for (n, v) in zip(keys(nt), values(nt)))
```

By define a function called `Assignment` with type of argument specified to `NamedTuple` (`a::NamedTuple`), when function `Assignment` is called with argument of `NamedTuple`, the compiler knows it should deal with this situation by the method defined in the fuction `Assignment(a::NamedTuple)`. It is not a new function defined for this new situation, but a new method associated with the function with respect to the argument type. This procedure is empowered by a technology called **multiple dispatch**, and is at the core of julia programming.

By overloading the constructor of `Assignment`, instances of `Assignment` now can be constructed from `NamedTuple`, which frees us from writing pair operators.

But notice that construction of `Assignment` is nested in function call of `FactorTable` and `FactorTable` is constructed with `Assignment`-`Float` pairs. When `FactorTable` is called with arguments `NamedTuple`-`Float` pairs, it tries to convert arguments of `NamedTuple` to counterpart of type `Assignment` because that is what a `FactorTable` originally defined. Thus, `convert` and `isequal` functions in the `Base` module should also be overloaded to handle this situation.

`Base.convert` performs by calling `Assignment` with new defined method and `Base.isequal` returns Boolean value (`true`/`false`) by comparing the length and each of the values associated with the argument `NamedTuple` and target `Assignment`.

## Bayesian Network

Bayesian Network, or belief network is expressed as a **directed acyclic graph**, or **DAG** for short. It contains several nodes, each representing a random variable in several possible states and directed relationships representing dependency and independency between those random variables.

```julia
struct BayesianNetwork
	vars::Vector{Variable}
	factors::Vector{Factor}
	graph::SimpleDiGraph{Int64}
end
```

To fully depict the relationship between those variables, a `BayesianNetwork` has a field `factors` that is an array of factors each representing a conditional probability of the underlying variable given its parent nodes. For a Bayesian network, the joint probability of a set of variables `$x_{1:n}=\{x_i\}_{i=1}^n$` can be written as,

$$p(x_{1:n}) = \prod_{i=1}^n p(x_i|\text{pa}(x_i))$$

where $\text{pa}(x_i)$ stands for the parent nodes of node $x_i$, that is, the nodes with an arrow pointing out toward node $x_i$.

Therefore, joint probability can be expressed as product of factors and all necessary factors used to depict the joint probability of variables combined are stored in `factors`.

A Bayesian network only contains factors as conditional probabilities, the joint probability of a specific assignment can be calculated from the product of factors.

```julia
function probability(bn::BayesianNetwork, assignment::Assignment)
	subassignment(φ) = select(assignment, variablenames(φ))
	probability(φ) = get(φ.table, subassignment(φ), 0.0)
	return prod(probability(φ) for φ in bn.factors)
end
```

`probability` is constructed from two facility functions:
1. `subassignment` uses `select` to return a subassignment whose variables are consistent with the factor given,
2. `probability` uses `get` function to retrive probability of target assignement from a factor table (`φ.table`), for example,

```julia
ft = FactorTable(
	(x = 0, y = 0) => 0.4,
	(x = 0, y = 1) => 0.1,
	(x = 1, y = 0) => 0.2,
	(x = 1, y = 1) => 0.3))

get(ft, (x = 0, y = 0), 0.0)

>>> 0.4

get(ft, (x = 0, y = 2), 0.0)

>>> 0.0
```

`get(a, b, c)` takes three arguments where `a` is a named container. If key `b` is in `a`, it results corresponding value of key `b` in the container `a`, if not, it simply return `c`.

When assignment $(x = 0, y=0)$ is in `ft`, `get` function returns the corresponding probability, if not, it returns `0.0`, which is consistent to the fact that any assignment out of factor table is regarded as `0` probability.

3. By the `probability` function to retrieve probability of given assignment, use a `for` loop to iterate factors in the network as argument for `probability` function and finally use `prod` function to multiply all of conditional probabilities as the final joint probability associated with the assignment.

[^1]: *Algorithm for Decision Making* is shared under a [Creative Commons CC-BY-NC-ND](https://www.creativecommons.org/licenses/by-nc-nd/2.0/?__cf_chl_captcha_tk__=284e66f4273dece881bce6ec57aae8cafc39d52d-1613463829-0-AcHDuxbEyFxnLUAxb28FfnAgy0tksWt_fMvyKzibthdQWwxg15FI_XD8x8DS74USg97fqyQ6otmCOIscpr2sT-PbdVt16uy7qISRfyS1xoBD7JtWg4hFfj_0DCSLdTqJfJWJLyyMB0jvxomn_BIWRg1j0ucsYijDSd2dncIAAAsTfkyYPkU3EPZU28E20PSBg3Nd7oe6txCOwBCFRTpNZcmVZT34R_uUqZCTIe1Rlk3_Lg4h8Ej4TJiwjw6nhyBm1WASH73-DdrmFhi36OxVMe4K2Sm0HvKnleJeGUyTdPgMvDI1fk7JN0MyPhR1ruChpRArdiFmBBOEKkXJzsEiV25tb1SX8rA5nE_OR4jYceMq6Dqd2ZarRqfmHqzg1RVwQibwhrEKKT24LgRNRonH0to9-Ox5vhhEnAVyQhC7-y3SdmbfWVkWc2oA7RV4jATwXJjsqJvRTZ5tLf34nQhzuaJFS7Dy1ASAmBsQEQXZYwS3uC4r4_jszA0ST6p9QZ9m8IyvoNvnf8Y6-B5VQjtXbyoquVmTeFa0lbsUK_96l6VDnlJxqhHSSUa445touHCN-PvnIgJIar4zC0MnorlDStNYZoLnXEWVVmDNUhjG6wgY) license. Further information can be found on its formal [website](https://algorithmsbook.com).
