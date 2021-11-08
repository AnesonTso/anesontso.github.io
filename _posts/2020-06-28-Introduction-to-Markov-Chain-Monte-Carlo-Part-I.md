---
title: Introduction to Markov Chain Monte Carlo I
mathjax: true
date: 2020-06-28
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



Accept-reject method and importance sampling method can be used to effectively generate basic probability distributions, whereas in many practical cases, we may encounter distributions far more complicated that only numerical approximation is available.

When target distributions become tricky, suitable instruments and importance functions for AR method and importance sampling respectively are not easily determined, especially for multivariate distributions. In these cases, we can turn to Markov Chain Monte Carlo, or MCMC.

<!--more-->

## Basics of Markov Chain

### Finite State Spaces

Suppose we are interested in forecasing weather. Let $X_t$ be the weather of day t. That is to say, $X$ denotes a random variable standing for possible weather, and is indexed by $t$, which stands for our unit of observation time.

We assume there are three kinds of weather: sunny, or rainy. Then random variable $X$ takes value in the finite state space $S=\{\text{sunny}, \text{rainy}\}$

Suppose next day's weather only depends on today's weather, by the estimation, we have, for example,

$$P(X_{t+1}=\text{sunny}\vert X_t=\text{sunny})=0.7$$

$$P(X_{t+1}=\text{rainy}\vert X_t=\text{sunny})=0.3 $$

$$P(X_{t+1}=\text{sunny}\vert X_t=\text{rainy})=0.4 $$

$$P(X_{t+1}=\text{rainy}\vert X_t=\text{rainy})=0.6$$

Such conditional probabilities can be denoted as $p_{ij}, \forall i,j \in S$,

$$p_{ij}=P(X_{t+1}=j|X_t=i), \forall i,j \in S$$

which stands for distribution of the next day's weather given today's weather.

Such probability is called **transition probabilities**, since it defines the likelihood of translating into a possible state from current state.

In our case of 2 weather states, there will be 4 total transition probabilities. They have such properties,

1. transition only depends on transition probabilities, that is, next time's state only depends on current state. This property is called *Markov property*.

2. transition probabilities are invariant in time, meaning once transition probabilities are set, they act on any two successive time units. Such stochastic process is called *homogeneous Markov chain*.

Let $\text{sunny}, \text{rainy}$ be the $1^{st}$ and $2^{nd}$ state respectively. Since we are given all 4 transition probabilities in this weather prediction case, we can put them, in a more compact format, into a matrix, called **transition matrix** P.

$$P=\begin{pmatrix}
0.7 & 0.3 \\
0.4 & 0.6
\end{pmatrix}
$$

Notice how $p_{ij}$ is fitted into the $i$-th row and $j$-th column in the transition matrix.

Suppose we are interested in the probability of a sunny day in the day after tomorrow given today, time t, is sunny,

$$\begin{aligned}
&P(X_{t+2}=\text{sunny}|X_t=\text{sunny}) = \\
&P(X_{t+1}=\text{sunny}|X_t=\text{sunny})\cdot
P(X_{t+2}=\text{sunny}|X_{t+1}=\text{sunny})\\
&+ P(X_{t+1}=\text{rainy}|X_t=\text{sunny})\cdot
P(X_{t+2}=\text{sunny}|X_{t+1}=\text{rainy})
\end{aligned}$$

Since transition probabilities are invariant in time,

then,

$$\begin{aligned}
&P(X_{t+2}=\text{sunny}|X_t=\text{sunny}) = \\
&P(X_{t+1}=\text{sunny}|X_t=\text{sunny})\cdot
P(X_{t+2}=\text{sunny}|X_{t+1}=\text{sunny})\\
&+ P(X_{t+1}=\text{rainy}|X_t=\text{sunny})\cdot
P(X_{t+2}=\text{sunny}|X_{t+1}=\text{rainy}) \\
&=0.7*0.7+0.3*0.4 = 0.61
\end{aligned}$$

Similarly, we can derive the probability of a rainy day in the day after tomorrow given today is rainy.

$$\begin{aligned}
&P(X_{t+2}=\text{rainy}|X_t=\text{rainy}) = \\
&P(X_{t+1}=\text{sunny}|X_t=\text{rainy})\cdot
P(X_{t+2}=\text{rainy}|X_{t+1}=\text{sunny})\\
&+ P(X_{t+1}=\text{sunny}|X_t=\text{rainy})\cdot
P(X_{t+2}=\text{rainy}|X_{t+1}=\text{sunny}) \\
&=0.6*0.6 + 0.4*0.3=0.48
\end{aligned}$$

How about $P(X_{t+2}=\text{rainy}\mid X_t=\text{sunny})$?

$$\begin{aligned}
&P(X_{t+2}=\text{rainy}|X_t=\text{sunny}) = \\
&P(X_{t+1}=\text{sunny}|X_t=\text{sunny})\cdot
P(X_{t+2}=\text{rainy}|X_{t+1}=\text{sunny})\\ 
&+P(X_{t+1}=\text{rainy}|X_t=\text{sunny})\cdot
P(X_{t+2}=\text{rainy}|X_{t+1}=\text{rainy}) \\
&= 0.7*0.3+0.3*0.6=0.39
\end{aligned}$$

Similarly,

$$P(X_{t+2}=\text{sunny}|X_t=\text{rainy})
= 0.6*0.4+0.4*0.7=0.52$$

Then, the transition matrix over two units of time is,

$$P^{(2)}=\begin{pmatrix}
0.61 & 0.39 \\
0.52 & 0.48
\end{pmatrix}
$$

which is exactly $P^2=PP$.

By this way, we can easily derive the transition matrix over any units of time, $P^{(n)}=P^n$.

### Properties of Markov Chain

#### Random Walk / Independence

When a transition matrix has identical rows, each state is independent to others, meaning that the probability from any state $i$ to state $j$ is equal to the marginal probability of state $j$, regardless of $i$.

Suppose there are two independent states, each has marginal probability of $p_1$ and $p_2$ respectively, and $p_1+p_2=1$. Then we have transition matrix,

$$P = \begin{pmatrix}
p1 & p2 \\ p1 & p2
\end{pmatrix}$$

we can easily check that $P^n=P$, for any unit of time $n$, that is, such independence is time-invariant.

#### Irreducibility

If over n units of time, $p_{ij}^{n}>0, n \ge 1$, meaning that state $j$ is *accessible* from state $i$, denoted as $i \rightarrow j$.

It indicates that after one or more steps, state $j$ can be reached by initial state $i$.

If two states are accessible at each direction, that is, $i \rightarrow j, j \rightarrow i$, then, state $i$ and $j$ communicate to each other, denoted as $i \leftrightarrow j$.

The communication property between $i$ and $j$ indicates that,

1. *reflexivity*: $i \rightarrow i, j \rightarrow j$, meaning that state $i$ and $j$ are reachable by themselves;
2. *symmetry*: $i \leftrightarrow j \Leftrightarrow j \leftrightarrow i$;
3. *transitivity*: $i \leftrightarrow j, j \leftrightarrow k \Leftrightarrow i \leftrightarrow k$

If a Markov chain contains all the states communicable to each other, that is, all states are reachable by any inital state, then such Markov chain is said to be **irreducible**.

Or more formally, we say a Markov chain is irreducible, if, every possible states $i,j \in S$, and some steps $n$, such that,

$$p^{(n)}_{ij}>0$$

where $p_{ij}$ is the element of transition matrix $P$ at $i$-th row and $j$-th column.

Consider a transition matrix of a Markov chain which is not irreducible with two states,

$$P = \begin{pmatrix}
1 & 0 \\ 0 & 1
\end{pmatrix}$$

we can easily see that once initial state is state 1 or 2, it is stuck in such state and will never reach other state for any given units of time. Such Markov chain is not irreducible. Not matter what $n$ we choose, $P^{(n)}$ will always contain elements of 0.

#### Recurrent and Transient

Let $T_i = \min\{n\ge 1: X_n=i\}$ denote the first time current state revisit state $i$, and  $P_i$ denote the probability measured on the initial state being state $i$.

Then, we say state $i$ is **recurrent** if $P_i(T_i < \infty)=1$; and state $i$ is **transient** if $P_i(T_i < \infty) < 1$.

A recurrent state will always revisit itself after finite steps, whereas a transient one is probable to do so.

> If a finite state Markov chain is irreducible, then every state is recurrent, that is to say, only a Markov chain not irreducible will have transient states.

#### Periodicity

If, given an initial state, states are regularly reached at some interval of time, then such Markov chain is said to be **periodic**.

Consider a transition matrix of a Markov chain which is periodic with two states,

$$P = \begin{pmatrix}
0 & 1 \\ 1 & 0
\end{pmatrix}$$

we can see the states are continuously transformed to each other. Suppose the initial state is 1, then we have such series of states,

$$\{1,2,1,2,1,2,\cdots\}$$

Notice when state 1 is reached, the time index is $\{1,3,5,\cdots\}$ and when the state 2 is reached, the time index is $\{2,4,6,\cdots\}$. For the same state to be reached, the time index has interval of 2. Then, the period of the chain is 2.

For general Markov chain, the **period** of state $i$ is defined as the greatest common divisor of the set $$\{n \ge 1: p^{(n)}_{ii}>0\}$$, where $$p^{(n)}_{ii}>0$$ means after $n$ steps, state $i$ is reachable by itself.

> In an irreducible chain all the states have the same period.

A Markov chain is said to be **aperiodic** if the period for all states is 1.

### Stationary Distribution

Let $\pi=(\pi_1,\pi_2, \cdots,\pi_s)'$ be the row vector of probability, each $\pi_i$ indicates the probability of current state being state $i$. Then, we can compute the *updated* probability by the Markov chain $P$, by taking matrix product,

$$\pi' = \pi P$$

Such vector or probability can be seen as the probability distribution of possible states.

If the updated probability distribution is equal to original distribution, that is,

$$\pi = \pi P \tag{1}$$

which is equivalent to,

$$\sum_i \pi_i p_{ij} = \pi_j, \forall j \in S$$

such distribution is said to be **stationary**, or **invariant** of time.

Notice formula $(1)$ indicates that such stationary distribution $\pi$ is actually the transition matrix $P$'s left eigenvector with eigenvalue of 1 becasue of our definition of $\pi$ is row vector and $P$ contains element $p_{ij}$ with each $i$ being the current state.

As an exapmle, back to our weather forecast case, where

$$P=\begin{pmatrix}
0.7 & 0.3 \\
0.4 & 0.6
\end{pmatrix}
$$

by solving the problem of,

$$\pi = \pi P$$

we have $\pi = \begin{pmatrix}\frac{4}{7} & \frac{3}{7}\end{pmatrix}$, which is stationary by the transition matrix $P$.

We can also use the property of left eigenvector to solve stationary distributions.

Since $\pi = \pi P$, take transpose for both sides,

$$\pi' = P' \pi'$$

which yields standard characteristic equation.

If we do eigendecomposition of $P$, we'll get exactly what we have solved analytically.

The irreducible and aperiodic finite Markov chain has special property that it has a unique stationary distribution and all states are positively recurrent, meaning that $p_{ij}>0 \forall i,j$.

### Convergence Theorems

#### First Type of Convergence

Let $p_{ij}$ denote element of transition matrix of an irreducible and aperiodic finite Markov chain which has a unique stationary distribution $\pi$, with probability $\pi_j$ for $j$-th state.

$$\lim_{n\rightarrow \infty} p^{(n)}_{ij} = \pi_j, \forall i,j \in S$$

Using our weather forecast for example,

$$P=\begin{pmatrix}
0.7 & 0.3 \\
0.4 & 0.6
\end{pmatrix}
$$

and let the initial distribution of states be,

$$\pi = \begin{pmatrix}
0.2 & 0.8
\end{pmatrix}$$

that is, we estimate that the probability of a sunny day is 0.2, and that of a rainy day is 0.8.

Then, let's see after effectively large number of steps, what is the probability distribution evolved by time.


This convergence shows that updated distribution $\pi_n$ after $n$ evolutions given initial distribution $\pi_0$ converges to the stationary distribution $\pi$.

#### Second Type of Convergence

For an irreducible and aperiodic finite Markov chain, let $f(x), x\in S$ be a function on the state space, and $\pi$ is the stationary distribution. Then, we have such convergence,

$$P\left(\lim_{n\rightarrow \infty}\frac{1}{n}\sum_i f(X_i) = \sum_s \pi_s f(X_s)\right)=1, \text{for } s \in S$$

Such convergence indicates that if we want to compute the expectation of $f(x)$ measured on the stationary distribution, we can run the Markov chain long enough, using resulted mean to approximate the expectation.

### Detailed Balance

In MCMC, we have a stationary distribution $\pi$ which is analytically difficult to derive numerical queries like mean and variance. If we can find a transition matrix $P$ that takes such $\pi$ as its unique stationary distribution, then we can use such $P$ to make approximation. The question is, how can we know the distribution we encounter is a stationary distribution?

We first need the concept of detail balance.

**Detailed Balance**

A distribution $\pi$ is said to be detailed balanced, if, for any two states $i,j$,

$$\pi_ip_{ij}=\pi_jp_{ji}$$

Then, if a distribution is detailed balanced, it is a stationary distritbuion.
