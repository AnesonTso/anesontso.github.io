---
title: Markov Chain Monte Carlo Algorithms
mathjax: true
date: 2020-06-30
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

In previous introduction, we've learned that an irreducible and possitive recurrent Markov chain with kernel function in continuous state space or transition matrix in finite state space will converge to a stationary distribution.

<!--more-->

MCMC is utilized given a stationary distribution from which we need to take samples, and the question becomes to construct a kernel function to approximate it.

Differed from the way such construction is implemented, MCMC methods have different algorithms.


## Gibbs Sampling

Suppose we want to draw independent samples from a target distribution $\pi(x,y)$. Gibbs sampling requires conditional distribution of $\pi(x\mid y)$ and $\pi(y\mid x)$ to be known, and with a naught sample to update distribution, then iterately draw samples from updated conditional distribution.

We'll introduce Gibbs sampling in bivariate case, which can be easily extended to multivariate.

### Gibbs Kernel

The transition kernel for the Gibbs sampling is,

$$K\left((x,y),(x',y')\right)=\pi_{X|Y}(x'|y) \cdot \pi_{Y|X}(y'|x')$$

which will converge to the target distribution $\pi(x,y)$.

### Bivariate Algorithm

1. Start with initial values $(x^{(0)},y^{(0)})$ from initial distribution $\pi^{(0)}$

2. For $t$ from $1$ to $n$,

    - draw $x^{(t)}$ from $\pi\left(x\mid y^{(t-1)}\right)$

    - draw $y^{(t)}$ from $\pi\left(y\mid x^t\right)$

Because our naught sample may not from a stationary distribution $\pi$, it may take $m$ iterations to asymptotically converge to target distribution, if we want to draw $k$ samples from the target distribution, we can run $n=m+k$ iterations, and pick out last $k$ samples.

Then, $\{(x^{(m-1)},y^{(m-1)}),\cdots,(x^{(n)},y^{(n)})\}$ is the set of samples we draw from target distribution $\pi(x,y)$

### Example

Suppose we want to draw samples $(x,y)$ from a bivariate normal distribution $N(\mu, \Sigma)$, where,

$$\mu=(\mu_x,\mu_y)' \\
\Sigma = \begin{pmatrix} \sigma_X^2 & \rho \sigma_X \sigma_Y \\ \rho \sigma_X \sigma_Y & \sigma_Y^2\end{pmatrix}$$

By the property of bivariate normal distribution,

$$X \vert Y \sim N\left(\mu_X+\rho \frac{\sigma_X}{\sigma_Y}(y-\mu_Y),(1-\rho^2)\sigma_X^2\right)$$

$$Y \vert X \sim N\left(\mu_Y+\rho \frac{\sigma_Y}{\sigma_X}(x-\mu_X),(1-\rho^2)\sigma_Y^2\right)$$



![svg](https://aneson-hexo-1259157358.cos.ap-nanjing.myqcloud.com/MCMCA/Markov%20Chain%20Monte%20Carlo%20Algorithms_15_0.svg)



We can see the path each sample is drawn.

![gif](https://aneson-hexo-1259157358.cos.ap-nanjing.myqcloud.com/MCMCA/gibsgif.gif)


### Multivariate Algorithm

Gibbs sampling can be easily extended to multivariate case when multivariate conditional distribution is available, though it is even harder to acquire.

We give Gibbs algorithm under $d$-dimensional case.

1. Start with initial sample $(x_1^{(0)},x_2^{(0)},\cdots,x_d^{(0)})$ from initial distribution $\pi^{(0)}$

2. From $i$ from $1$ to $n$,

    - draw $x_1^{(i)}$ from $\pi(x_1\mid x_2^{(i-1)}, \cdots, x_d^{(i-1)})$,
    - draw $x_2^{(i)}$ from $\pi(x_2\mid x_1^{(i)},x_3^{(i-1)}, \cdots, x_d^{(i-1)})$,

    $\vdots$

    - draw $x_d^{(i)}$ from $$\pi(x_d\mid x_1^{(i)}, \cdots, x_{d-1}^{(i)})$$

### Block Gibbs Sampling

When variables are highly correlated, it will take much longer time for Gibbs sampler exploring the distribution density, which means the updated path moves very slowly. We can put correlated variables into blocks, then iterately sample from it.

## Metropolis–Hastings Algorithm

Gibbs sampling method requires known conditional distributions, which is not available for many practical uses.

We can use Metropolis–Hastings algorithm.

The method starts with a *reversible kernel* $q(\cdot)$, which is symmetric depending on the current state, meaning that,

$$q(x|y)=q(y|x)$$

$x,y$ be the samples before and after update.

Normal density is commonly used as the reversible kernel since it is symmetric in distance.

### Algorithm for MH Method

1. draw an initial sample $x^{(0)}$ from $q(x)$,

2. for $i$ from $1$ to $n$,

    draw $x'$ from $q(x\mid x^{(i-1)})$,

    let 
    $$\alpha\left(x' \mid x^{(i-1)}\right)=\min \left\{1, \frac{q\left(x^{(i-1)} \mid x'\right) \pi\left(x'\right)}{q\left(x' \mid x^{(i-1)}\right) \pi\left(x^{(i-1)}\right)}\right\}$$

3. draw $u\sim U(0,1)$

4. if $u \le \alpha(x'\mid x^{(i-1)})$, $x^{(i)}=x'$; otherwise go to 1.

We can decompose update probability $\alpha$ into two parts, $\frac{q(x^{(i-1)}\mid x')}{q(x'\mid x^{(i-1)})}$ and $\frac{\pi(x')}{\pi(x^{(i-1)})}$.

When $q(\cdot)$ satisfy reversible property, then the first term becomes $1$. And the latter term indicates the proportion of density before and after update. When the proportion is relative large, meaning that the sampler takes a sample from a high density area, it is encouraged to keep that sample, and move to that state.

When reversible property holds, we call such Metropolis–Hastings algorithm as **Random Walk MH**.

### Example

Suppose we are going to draw samples from $\text{Beta}(2,3)$ with proposal $U(0,1)$.


![svg](https://aneson-hexo-1259157358.cos.ap-nanjing.myqcloud.com/MCMCA/Markov%20Chain%20Monte%20Carlo%20Algorithms_32_0.svg)
