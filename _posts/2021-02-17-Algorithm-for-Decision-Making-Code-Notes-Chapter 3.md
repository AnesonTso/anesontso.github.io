---
title: Algorithm for Decision Making Code Notes Chapter 3
mathjax: true
date: 2021-02-17
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

This is my notes on code snippets associated with the book *Algorithm for Decision Making*[^1].

There are three factor operations combined to represent discrete multivariate distributions that are,
1. **factor product** yields Cartesian product from original two factors to fully depict possible combinations of variables assignment in those two factors. *Similar to derive joint probability from marginal probabilities*;
2. **factor marginalization** deletes one or more variables from factors, putting probability weights on remaining variables. *Similar to marginalize variables from joint probability*;
3. **factor conditioning** given **evidence** about particular assignment deletes assignments in the factor that are inconsistent with the evidence. *Similar to conditional probability*.

Suppose we have a factor $\phi(X, Y)$, which has the following probability distribution,

|row id|X=x | Y=y | $p(x,y)$|
|:-:|:-:|:-:|:-:|
|1|X=0|Y=0|0.1|
|2|X=0|Y=1|0.4|
|3|X=1|Y=0|0.2|
|4|X=1|Y=1|0.3|

Notice the conditional probability formula,

$$P(X=x|Y=y) = \frac{P(X=x,Y=y)}{P(Y=y}$$

$$P(X=1\vert Y=0)$$ is the probability of $$X$$ being $$1$$ given that we observed that $$Y$$ being $$0$$. When there is evidence $$Y=0$$, row 2 and row 4 are not consistent with this evidence thus removed. *Row 3* is what we care but its probability itself is not legitimate because the remaining two entries' probabilities doesn't sum to one. By normalization, we have the normalized probability for row 3,

$$\frac{X=1, Y=0}{Y=0} = \frac{0.2}{0.1+0.2} = \frac{2}{3}$$

which is consistent with the conditional probability formula. Therefore, conditional probability is actually derived by removing entries inconsistent with the evidence then normalize the probability of entry corresponding to our interest. Sum of probabilites of remaining entries is itself marginalization. Therefore, conditioning contains two phases: marginalization and normalization.

## Factor Product


Factor product constructs joint probability from marginal probabiliies. For example, consider following two factors $\varphi(X, Y)$ and $\psi(Y, Z)$ each with the following factor table,

**$\varphi(X, Y)$**

|X=x|Y=y|$\varphi$(X=x, Y=y)|
|:-:|:-:|:-:|
|0|0|0.1|
|0|1|0.2|
|1|0|0.3|
|1|1|0.4|

**$\psi(Y, Z)$**

|Y=y|Z=z|$\psi$(Y=y, Z=z)|
|:-:|:-:|:-:|
|0|0|0.2|
|0|1|0.5|
|1|0|0.0|
|1|1|0.3|

The factor $\phi(X, Y, Z)=\varphi(X, Y) * \psi(Y,Z)$ is that,

|X=x|Y=y|Z=z|$\phi$(X=x, Y=y, Z=z)|
|:-:|:-:|:-:|:-:|
|0|0|0|0.02|
|0|0|1|0.05|
|0|1|0|0.0|
|0|1|1|0.06|
|1|0|0|0.06|
|1|0|1|0.15|
|1|1|0|0.0|
|1|1|1|0.12|

Notice how a single entry in the product factor is determined, because $Z$ takes two possible values, thus for each assignment of $X$ and $Y$, there are two cases where $Z=0$ and $Z=1$, therefore, the new factor now has eight entries in total, each is a combination of values of $(X, Y, Z)$. And the factor value,

$$\phi(X=x,Y=y,Z=z) = \varphi(X=x,Y=y) \times \psi(Y=y,Z=z)$$

```julia
function Base.:*(ϕ::Factor, ψ::Factor)
	ϕnames = variablenames(ϕ)
	ψnames = variablenames(ψ)
	shared = intersect(ϕnames, ψnames)
	ψonly = setdiff(ψ.vars, ϕ.vars)
	table = FactorTable()
	for (ϕa, ϕp) in ϕ.table
		for a in assignments(ψonly)
			a = merge(ϕa, a)
			ψa = isempty(ψ.vars) ? Assignment() : select(a, ψnames)
			table[a] = ϕp * get(ψ.table, ψa, 0.0)
		end
	end
	vars = vcat(ϕ.vars, ψonly)
	return Factor(vars, table)
end
```

The product of factors should be factor as well, thus the variables and factor table of produced factor should be defined. The list for variables, `vars` is defined by concatenating variables contained only in $\psi$ to variable list of $\phi$, which is pretty straightforward.

Another way for doing this is that,

```julia
vars = unique([ϕ.vars; ψonly])
```

but the way original code to handle variables is better since intermediate object `ψonly` associated with distinct variable $Z$ needs to be considered.

1. the first for loop `for (ϕa, ϕp) in ϕ.table` is because for each assignment of the original factor, every possible value of new variables introduced by the latter factor should be considered therefore a second for loop `for a in assignments(ψonly)`;
2. `merge` is used to combine two dictionary, where in this case will combine assignment from the original factor with latter factor. Thus `a` is the combined assignment with all variables in those factors specified to given values;
3. `isempty(ψ.vars) ? Assignment() : select(a, ψnames)` is the **tenery operator** which has the following syntax:
	`condition ? body1 : body2`. If expression in `condition` yields `true` then the tenery expression executes expression in `body1` otherwise `body2`. It works as a check. `ψa` stores assignment consistent with factor `ϕ` and is used to retrieve the factor value from factor table of `ϕ` then multiply the value to that of `ψ` then assign it to the factor value of product factor.

## Marginalization

Marginalization, in a sense, similar to the inverse operation of factor product. To marginalize $Z$ from $\phi(X, Y, Z)$ yields $\varphi(X, Y)$ and to marginalize $X$ yields $\psi(Y, Z)$.

For example, to marginalize $Z$ from $\phi(X, Y, Z)$, take every assignment of combination $(X,Y)$ as assignment for the marginalized factor then add together as the marginalized factor value those of assignments consistent with the combination of $(X,Y)$.

```julia
function marginalize(φ::Factor, name::Symbol)
	table = FactorTable()
	for (a, p) in φ.table
		a′ = delete!(copy(a), name)
		table[a′] = get(table, a′, 0.0) + p
	end
	vars = filter(v -> v.name != name, φ.vars)
	return Factor(vars, table)
end
```

The assignment of marginalized factor is each added to the new factor table, then by iterating through factor table add factor value to assignment associated with the original combination of variables.

`filter(v -> v.name != name, φ.vars)` is used to sort out variable name in `name`, which contains an anonymous function `v -> v.name != name`, which has no function name but knows how to do with the argument `v` by comparing `v`'s field `name` to the `name`, returning `true` only when field `name` is not the same to `name`. And the anonymous function is called on each element in the `φ.vars` then return outcomes with `true`.

## Factor Conditioning

```julia
in_scope(name, φ) = any(name == v.name for v in φ.vars)

function condition(φ::Factor, name, value)
	if !in_scope(name, φ)
		return φ
	end
	table = FactorTable()
	for (a, p) in φ.table
		if a[name] == value
			table[delete!(copy(a), name)] = p
		end
	end
	vars = filter(v -> v.name != name, φ.vars)
	return Factor(vars, table)
end

function condition(φ::Factor, evidence)
	for (name, value) in pairs(evidence)
		φ = condition(φ, name, value)
	end
	return φ
end
```

The condition has no effect on factors not containing its corresponding variable. And conditioning is simply by removing entries in the factor that is inconsistent with the condition. Notice by conditioning, resulted factor is always a subset of the original factor.

The first `condition` defines how to do factor condtion on single assignment, and the second `condition` can be used to  condition on multiple assignment collected	as a dictionary called `evidence`.




[^1]: *Algorithm for Decision Making* is shared under a [Creative Commons CC-BY-NC-ND](https://www.creativecommons.org/licenses/by-nc-nd/2.0/?__cf_chl_captcha_tk__=284e66f4273dece881bce6ec57aae8cafc39d52d-1613463829-0-AcHDuxbEyFxnLUAxb28FfnAgy0tksWt_fMvyKzibthdQWwxg15FI_XD8x8DS74USg97fqyQ6otmCOIscpr2sT-PbdVt16uy7qISRfyS1xoBD7JtWg4hFfj_0DCSLdTqJfJWJLyyMB0jvxomn_BIWRg1j0ucsYijDSd2dncIAAAsTfkyYPkU3EPZU28E20PSBg3Nd7oe6txCOwBCFRTpNZcmVZT34R_uUqZCTIe1Rlk3_Lg4h8Ej4TJiwjw6nhyBm1WASH73-DdrmFhi36OxVMe4K2Sm0HvKnleJeGUyTdPgMvDI1fk7JN0MyPhR1ruChpRArdiFmBBOEKkXJzsEiV25tb1SX8rA5nE_OR4jYceMq6Dqd2ZarRqfmHqzg1RVwQibwhrEKKT24LgRNRonH0to9-Ox5vhhEnAVyQhC7-y3SdmbfWVkWc2oA7RV4jATwXJjsqJvRTZ5tLf34nQhzuaJFS7Dy1ASAmBsQEQXZYwS3uC4r4_jszA0ST6p9QZ9m8IyvoNvnf8Y6-B5VQjtXbyoquVmTeFa0lbsUK_96l6VDnlJxqhHSSUa445touHCN-PvnIgJIar4zC0MnorlDStNYZoLnXEWVVmDNUhjG6wgY) license. Further information can be found on its formal [website](https://algorithmsbook.com).
