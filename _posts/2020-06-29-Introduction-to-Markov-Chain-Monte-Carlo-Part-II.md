---
title: Introduction to Markov Chain Monte Carlo II
mathjax: true
date: 2020-06-29
tags:
- MCMC
- Bayesian
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
excerpt_separator: <!--more-->

---


**Main source: Introduction to Bayesian Econometrics *(Edward Greenberg, 2008)***

Before diving in the MCMC method, we need to cover other important forms of Markov chain with countable state spaces.

<!--more-->

## Countable State Spaces

### Random Walk

When a Markov chain is extended to contain infinite but countable number of states, it would be analytically convenient to index each state by a natural number.

In a Bernoulli process with countable state space, each state $t$, has two possible transformations,

1. transformed into the state $t-1$ with probability $p$,
2. transformed into the state $t+1$ with probability $1-p$,
3. if current state is 0, with probability p, it transforms to 1, otherwise stays in 0.

Let's draw some simulations with different $p$s and initial value state 0, and see how the path of such chains would be.


![svg](https://aneson-hexo-1259157358.cos.ap-nanjing.myqcloud.com/IMCMC1/Introduction%20to%20Markov%20Chain%20Monte%20Carlo%20Part%20II_8_0.svg)



When Markov chain contains infinite states, transition matrix is not available. Also, some properties of finite state Markov chain can not apply directly in infinite case.

Although the definition of *irreducibility* and *periodicity* is the same, we need to introduce some theories more suitable for this new topic.

### Recurrent and Transient

Remember how recurrency and transience are defined.

$T_i=\min\{n\ge1: X_n=i\}$ denotes the first step when current state turns state $i$. And $P_i$ denotes the probability of an event given the initial state is $i$, then,

- $P_i(T_i<\infty)=1$ implies the state is **recurrent**, and
- $P_i(T_i< \infty)<1$ implies the state is **transient**.

As previouly stated, every state in an irreducible finite state Markov chain is recurrent. When the Markov chain now contains infinite but countable states, it no longer holds true.

Some differences are,

1. an irreducible chain can contain transient states,
2. such irreducible chain will not have stationary distibutions.

In finite state Markov chain, $E_i(T_i)$ is finite for recurrent states, whereas in infinite case, recurrent states can have infinite $E_i(T_i)$. Additional definition of recurrency can be further made.

1. When $E_i(T_i) < \infty$, the state $i$ is said to be **positive recurrent**,
2. a recurrent state with $E_i(T_i) = \infty$ is said to be **null recurrent**.

Back in the graph we plotted earlier,

1. when $p>\frac{1}{2}$, the chain is *transient*, meaning that there would be infinitely large number of states which the chain only visits once.

2. when $p\le \frac{1}{2}$, the chain is *recurrent*, meaning that the chain will return to past states almost surely.

3. when $p=\frac{1}{2}$, states will be revisited surely, but may after a very large steps, making the time of revisit very large, hence, such states are *null recurrent*.

4. when $p<\frac{1}{2}$, each state will revisited, and return to it very fast, which is called *positive recurrent*.

The very aim of analysis is to find a stationary distribution. Once new conditions are added, the stationary distribution we want to derive can be proven to be exited.

**Existence of Stationary Distribution**

For an irreducible Markov chain with infinite but countable state space, if all states are positive recurrent, then there exists a stationary distribution $\pi$.

Once the stationary distribution is guaranteed, convergence theorems can be stated.

### Convergence Theorems

Similar to finite state space, in countable state space case, there are two important convergence theorem which guarantees that we can use MCMC method to do approximation.

#### First Type of Convergence

Suppose $p_{ij}$ is the transition matrix of an irreducible and aperiodic Markov chain with countable state space with a stationary distribution $\pi$, then for any two states $i,j$,

$$\lim_{n\rightarrow \infty}p^{(n)}_{ij} = \pi_j$$

Each row of transition matrix will converge to the stationary distribution, regardless of the initial distritbuion we choose.

#### Second Type of Convergence

Suppose an irreducible and aperiodic Markov chain with countable state space with a stationary distribution $\pi$. Let $f(x)$ be the function on the state space such that $\sum_s \mid f(s)\mid \pi_s < \infty, s \in S$, then

$$P\left(\lim_{n\rightarrow \infty}\frac{1}{n}\sum_{i}f(x_i)=\sum_s f(s)\pi_s\right)=1$$

### Detailed Balance

If we want to prove that target distribution $\pi$ is stationary, then it should satisfy detailed balance. For any two states $i,j$,

$$\pi_{i}p_{ij}=\pi_jp_{ji}$$

## Continuous State Spaces

### Measure Theory Concepts

Before we readily take the burden of continuous state space, we need to introduce some concepts of measure theory.

Remember that a distribution is defined on a measurable space $(S,\mathbb{S})$, where $S$ is the sample space, $\mathbb{S}$ is $\sigma$-algebra of the sample space, and let $P$ be a measure on the space, that is $P: S\times \mathbb{S} \rightarrow [0,1]$.

Let $X \sim N(0,1)$ for example, since standard normal distribution takes values on the real line, then $S=R, \mathbb{S}=\sigma(R):=\mathbb{R}$, and such distribution has pdf $f(x)$.

A measure $P$ assigns probability, or value in $[0,1]$ to an event, called a measurable set, $A \in (R,\mathbb{R})$. Suppose $A=\{x:x \ge 0\}$, then,

$$P(A)=\int_A f(x)dx = \frac{1}{2}$$

as we can see, $P$ is a measure on $A$, and $f(x)$ is a $\mathbb{R}$-measurable function on $A$.

If the measurable space $(S,\mathbb{S})$ has measure $\mu$, since $A$ is a subset of the measurable space, then we can use $\mu$ to measure $A$, then, the integral of $f$ with respect to $\mu$ is,

$$P(A)=\int_A fd\mu=\int_A f(x)\mu(dx)$$

And we say $f$ is the density of $\mu$ with respect to the Lebesgue measure. In this case, $P$ is absolutely continuous with respect to $x$, since the probability of a single point is 0.

### Continuous Markov Chain

Back to our introduction to Markov chain, and use the concepts of measure theory into the context of continuous case.

When the Markov chain can take on any real value in the continuous state space $\mathbf{S}$, we can not simply seperate each state. In this case, transition matrix should be redefined as **transition kernel**, denoted as $k(x,y)$, which can be seen as the density of $y$ given that the current state is $x$.

Such transition kernel should satisfy certain properties,

1. $k(x,y)>0 \forall x,y \in S$
2. $\int_S k(x,y)dy = 1, \forall x$

Let $\mathbb{S}$ be the $\sigma$-field generated by $S$. And the transition kernel $K$ is a mapping from the measurable space $(S, \mathbb{S})$ into $[0,1]$, such that,

1. for all $x \in S$, $K(x,\cdot)$ is a probability measure on the measurable space $(S, \mathbb{S})$, that is, $K: S \times \mathbb{S} \rightarrow [0,1]$,

2. for all $A \in \mathbb{S}$, $K(\cdot, A)$ is a measurable function on $S$.

Suppose the current state is $x$, the probability that it can move to a subset $A \in \mathbf{S}$, denoted as $K(x,A)$ is defined as,

$$K(x,A)=\int_Ak(x,y)dy$$

which is intuitive, since the probability of state $x$ transforming into any state in $A$ should be the probability integrated on $A$.

If a Markov process has taken $k$ steps, resulting $k$ random variables, $X_0, X_1, \cdots, X_k$, then the probability that the state is in $A$ at the next step is given by,

$$P(X_{k+1}\in A|X_0,X_1, \cdots, X_k)=\int_A K(X_k,dx)$$

which is equivalent to,

$$P(X_{k+1}\in A|x_0,x_1, \cdots, x_k)=\int_A K(x_k,dx)$$

since when $X_0,X_1,\cdot,X_k$ are given, they are realizations of such random variables.

Let the transition function covering *n* steps be that,

$$K^n(x,A)=P(X_n\in A|X_0=x)$$

Let $m,n$ be positive integers and $A\in S$, then,

$$K^{n+m}(x,A)=\int_S K^n(y,A)K^m(x,dy)$$

Let $n=n-1,m=1$, then we have,

$$K^{n}(x,A)=\int_S K^{n-1}(y,A)K(x,dy)$$

Notice how this expression is fitted into the measure theory we have introduced. There the probability measure is the distribution $K(x,\cdot)$ after $n$ steps, and the measurable function is $K(\cdot,A)$ after $n-1$ steps, and the base measure is $K(x,dy)$.

### Stationary Distribution

We still want to find such distribution to which the Markov chain converges. First, we need to redefine the stationary distribution under context of continuous state space.

A measure is stationary for the Markov chain with transition kernel $K$, if, for any set $A\in \mathbb{S}$,

$$\pi(A)=\int_S K(x,A)\pi(dx)$$

Notice such measure is not required to be probability distribution. When such $\pi$ is a probability measure, then, the chain is **positive recurrent**, meaning that very real value in the state space $S$ will be revisited very soon.

And when the chain is positive recurrent, it will have a stationary measure.

In practice, chances are we are interested in using a Markov chain with kernel function $k$ to approximate a stationary distribution $\pi$. As is in the finite state case, we need some theory to check our measure $\pi$ is stationary,

A Markov chain with transition kernel $k(\cdot,\cdot)$ is detailed balanced, if there is a non-negative function $\pi$ defined on $S$ such that,

$$\pi(y)k(y,x)=\pi(x)k(x,y) \forall x,y \in S$$

If the chain is detailed balanced, then such $\pi$ is stationary.

The convergence property of continuous state Markov chain depends on the recurrency.

Let $t_A=\inf\{n\ge 1: X_n \in A\}$ denotes the first time chain reaches $A \in \mathbb{S}$. If set $A$ is measurable and for every $x\in A$, $P_x(t_A < \infty)=1$, then the chain is called *Harris recurrent*.

Now we can introduce convergence property based on recurrence property.

### Convergence Theorems

#### First Type of Convergence

For a Harris recurrent, aperiodic Markov chain with continuous state space with a stationary measure $\pi$,

$$\lim_{n\rightarrow \infty}||K^n(x,\cdot)-\pi||_{TV}=0$$

where $\mid\mid\cdot\mid\mid_{TV}$ is the *total variation norm* of these two measures.

#### Second Type of Convergence

For a Harris recurrent, aperiodic Markov chain with continuous state space with a stationary measure $\pi$, for all integrable function $f$ in the $L^1$ space of $\pi$.

$$\lim_{n\rightarrow \infty}\frac{1}{n}\sum_{i=1}^n f(X_i)=\int_S f(x)d\pi(x)$$

Such convergence theorems lays out the basis for MCMC methods, which start with a desired stationary distribution, and try to construct an irreducible and positive recurrent transition kernel that converges to it.
