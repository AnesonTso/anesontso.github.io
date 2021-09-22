---
title: Variational Inference
mathjax: true
date: 2021-03-02
tag: Probability
excerpt_separator: <!--more-->

---

This post is mainly based on Bishop's *Pattern Recognition and Machine Learning*.

<!--more-->

## Bayesian Overview

First let's quickly review some of the basic ideas behind the Bayesian inference. Bayesian inference is rooted in the Bayesian formula, for example, of two discrete random variables $X, Z$.

$$\begin{aligned}
P(Z=z\mid X=x) &= \frac{P(X=x, Z=z)}{P(X=x)} \cr
&= \frac{P(X=x, Z=z)}{\sum_{z\prime}P(X=x\mid Z=z\prime)P(Z=z\prime)}
\end{aligned} \tag{1}$$

For the continuous ones,

$$\begin{aligned}
P(Z\mid X) &= \frac{P(X, Z)}{P(X)} \\
&= \frac{P(X\mid Z)P(Z)}{\int P(X\mid Z)P(Z)dZ}
\end{aligned} \tag{2}$$

Because the denominator in each case is the summation or integral over variable $Z$ thus not relevant of $Z$, therefore, the denominator is a constant multiplied by the joint probability in the nominator. For this reason, we have,

$$P(Z\mid X) \propto P(X, Z) \tag{3}$$

Therefore, the conditional probability is only the **normalized joint probability of the variable that is not conditioned**. We'll come back to this conclusion.

If $X$ is the data we observe and $Z$ is some unknown parameters or latent variables, the **prior** $P(Z)$ is the initial belief about those unknown quantities, the **likelihood** $P(X\mid Z)$ is how likely to observe $X$ under $Z$ and **posterior** $P(Z\mid X)$ is the updated belief about the unknown quantities after observing data thus is the key role in Bayesian inference.

## EM Algorithm

In the previous post about EM algorithm, the maximum likelihood estimation is obtained by iteratively maximizing the log likelihood of data, that is, $\ln p(\mathbf{X}\mid \boldsymbol{\theta})$, which can be decomposed by,

$$\begin{aligned}
\ln p(\mathbf{X} \mid \boldsymbol{\theta}) &= \mathcal{L}(q, \boldsymbol{\theta}) + \text{KL}(q \Vert p)
\end{aligned} \tag{4}$$

where $\mathbf{X}$ are the observations, $\mathbf{Z}$ are the latent variables with prior $q(\mathbf{Z})$, $\boldsymbol{\theta}$ are the unknown parameters and,

$$\mathcal{L}(q, \boldsymbol{\theta})= \int q(\mathbf{Z})\ln \frac{p(\mathbf{X},\mathbf{Z}\mid \boldsymbol{\theta})}{q(\mathbf{Z})} d\mathbf{Z} \tag{5}$$

$$\text{KL}(q \Vert p) = - \int q(\mathbf{Z})\ln \frac{p(\mathbf{Z} \vert \mathbf{X}, \boldsymbol{\theta})}{q(\mathbf{Z})} d\mathbf{Z} \tag{6}$$

In the $E$ step, $\mathcal{L}(q, \boldsymbol{\theta})$ is updated to $\mathcal{L}(q\prime, \boldsymbol{\theta})$ where $q\prime$ is derived by miniming $\text{KL}(q\Vert p)$ which is given by,

$$q\prime(\mathbf{Z}) = p(\mathbf{Z} \vert \mathbf{X}, \boldsymbol{\theta}) \tag{7}$$

which means to assign posterior of latent variables as prior for the next iteration.

In the $M$ step, estimation of $\boldsymbol{\theta}$ is derived by maximizing $\mathcal{L}(q\prime,\boldsymbol{\theta})$.

Repeat these two steps until some convergence conditions are satisfied.

## Variational Inference

If, by Bayesian view, unknown parameters are assigned random distributions, $\boldsymbol{\theta}$ now has no intrinsic difference to latent variable $\mathbf{Z}$ therefore the former can be regarded as part of the latter.

In this case,

$$\ln p(\mathbf{X}) = \mathcal{L}(q) + \text{KL}(q \Vert p) \tag{8}$$

where,

$$\mathcal{L}(q) = \int q(\mathbf{Z}) \ln \frac{p(\mathbf{X}, \mathbf{Z})}{q(\mathbf{Z})}d\mathbf{Z} \tag{9}$$

$$\text{KL}(q\Vert p) = -\int q(\mathbf{Z})\ln \frac{p(\mathbf{Z} \vert \mathbf{X})}{q(\mathbf{Z})}d\mathbf{Z} \tag{10}$$

when $\boldsymbol{\theta}$ are unobserved random variables, they are absorbed into $\mathbf{Z}$.

EM algorithm tries to find parameters best describing the model with latent variables, whereas variational inference tries to find a bunch of distributions best describing the posterior distribution or any distribution that is intractable to investigate its analytical properties. Those bunch of distributions are **approximate** for the posterior distribution.

$q(\mathbf{Z})$ in EM algorithm is the prior for latent variables which by $E$ step will be updated to the posterior $p(\mathbf{Z}\vert \mathbf{X})$ however, in variational inference, $q(\mathbf{Z})$ is some distribution used to approximate the posterior. Candidates for $q(\mathbf{Z})$ should be expressive and flexible as possible but still constrained in simple form such as normal distribution which is only governed by two parameters: $\boldsymbol{\mu}$ and $\boldsymbol{\Sigma}$ or its other members in the exponential family or some factored distribution which can incorporate conditional independence of variables into the approximation.

In EM algorithm, the approximation is derived by minimizing $\text{KL}$ divergence between $q(\mathbf{Z})$ and the posterior $p(\mathbf{Z}\vert \mathbf{X})$. But $p(\mathbf{Z} \vert \mathbf{X}$) is intractable needless to say $\text{KL}(q \Vert p)$, thus the objective function should be further decomposed as,

$$\begin{aligned}
\text{KL}(q\Vert p) &= -\int q(\mathbf{Z})\ln \frac{p(\mathbf{Z} \vert \mathbf{X})}{q(\mathbf{Z}) }d\mathbf{Z} \\
&= -\int q(\mathbf{Z})\ln \frac{p(\mathbf{X}, \mathbf{Z})}{q(\mathbf{Z})}d\mathbf{Z} + \int q(\mathbf{Z})\ln p(\mathbf{X})d\mathbf{Z} \\
&= - \mathcal{L}(q) + \ln p(\mathbf{X})
\end{aligned} \tag{11}$$

which can be derived directly from $(8)$.

Since $\ln p(\mathbf{X})$ is irrelevant of choice of $q$, to minimize $\text{KL}(q\Vert p)$ is equivalent to maximize $\mathcal{L}(q)$, which is called **energy functional** of $q$ and as previously introduced, is the lower bound of $\ln p(\mathbf{X})$.


## Variational Inference using Factorized Distributions

Suppose variable $\mathbf{Z}$ can be factored into $M$ components $$\{\mathbf{Z}_i\}_{i=1}^M$$. In this case, $q(\mathbf{Z})$ can be expressed as,

$$q(\mathbf{Z}) = \prod_{i=1}^M q(\mathbf{Z}_i)$$

Each factored distribution is distinguished from each other by its argument, that is $q(\mathbf{Z}_i)$ instead of $q_i(\mathbf{Z}_i)$ for better display.

Therefore,

$$\begin{aligned}
\mathcal{L}(q) &= \int q(\mathbf{Z})\ln \frac{p(\mathbf{X}, \mathbf{Z})}{q(\mathbf{Z})}d\mathbf{Z} \\
&= \int \prod_{i}q(\mathbf{Z}_i) \ln p(\mathbf{X}, \mathbf{Z})d\mathbf{Z} - \int \prod_i q(\mathbf{Z}_i)\sum_i\ln q(\mathbf{Z}_i) d\mathbf{Z}
\end{aligned} \tag{12}$$

By iteration, each component is updated at a time, thus we can derive a $\mathcal{L}$ with respect to single component $j$ by absorbing terms without $q_j$ into constant, that is,

$$\begin{aligned}
\mathcal{L}(q_j) &= \int \prod_{i}q(\mathbf{Z}_i) \ln p(\mathbf{X}, \mathbf{Z})d\mathbf{Z} - \int \prod_i q(\mathbf{Z}_i)\sum_i\ln q(\mathbf{Z}_i) d\mathbf{Z}   \\
&= \int_{\mathbf{Z}_j} \left(\int_{\mathbf{Z}_{-j}}q(\mathbf{Z}_j)\prod_{i\ne j}q(\mathbf{Z}_i) \ln p(\mathbf{X}, \mathbf{Z})d\mathbf{Z}_{-j} \right) d\mathbf{Z}_j \\
&-\int_{\mathbf{Z}_j} q(\mathbf{Z}_j)\int_{\mathbf{Z}_{-j}} \prod_{i\ne j}q(\mathbf{Z}_i)\left(\sum_{i\ne j} \ln q(\mathbf{Z}_i)+\ln q(\mathbf{Z}_j)\right)    \\
&= \int_{\mathbf{Z}_j}q(\mathbf{Z}_j) \left(\int_{\mathbf{Z}_{-j}}\prod_{i\ne j}q({\mathbf{Z}_i})\ln p(\mathbf{X}, \mathbf{Z})d\mathbf{Z}_{-j} \right) d\mathbf{Z}_j - \int_{\mathbf{Z}_j} q(\mathbf{Z}_j)\ln q(\mathbf{Z}_j) d\mathbf{Z}_j + \text{const} \\
&= \int_{\mathbf{Z}_j} q(\mathbf{Z}_j) \mathbb{E}_{-j}\big[\ln p(\mathbf{X},\mathbf{Z})\big]d\mathbf{Z}_j - \int_{\mathbf{Z}_j}q(\mathbf{Z}_j)\ln q(\mathbf{Z}_j)d\mathbf{Z}_j + \text{const} \\
&= \int_{\mathbf{Z}_j}q(\mathbf{Z}_j)\ln \tilde{p}(\mathbf{X},\mathbf{Z}_j)d \mathbf{Z}_j - \int_{\mathbf{Z}_j}q(\mathbf{Z}_j)\ln q(\mathbf{Z}_j)d\mathbf{Z}_j d\mathbf{Z}_j + \text{const} \\
&= -\text{KL}\left(q(\mathbf{Z}_j) \Vert \tilde{p}(\mathbf{X},\mathbf{Z}_j)\right) + \text{const}
\end{aligned}
\tag{13}$$

where

$$\ln \tilde{p}(\mathbf{X},\mathbf{Z}_j)=\mathbb{E}_{-j}\big[\ln p(\mathbf{X}, \mathbf{Z})\big] + \text{const}$$

where $\mathbb{E}_{-j}\left[\ln p(\mathbf{X}, \mathbf{Z})\right]$ is the expectation of $\ln p(\mathbf{X}, \mathbf{Z})$ with respect to $\mathbf{Z}_i,i\ne j$ and the constant contains all terms that are irrelevant to $q_j$.

To maximize $\mathcal{L}(q_j)$ is to minimize the KL divergence between $q(\mathbf{Z}_j)$ and $\tilde{p}(\mathbf{X}, \mathbf{Z}_j)$, which achieves its lowest when,

$$\begin{aligned}
\ln q(\mathbf{Z}_j) &= \ln \tilde{p}(\mathbf{X}, \mathbf{Z}_j) \\

&= \mathbb{E}_{-j}\big[\ln p(\mathbf{X},\mathbf{Z})\big] + \text{const}
\end{aligned}
\tag{13}$$

where the constant is used to normalize the probability function such that,

$$\begin{aligned}
q(\mathbf{Z}_j) &= \frac{\exp\left(\mathbb{E}_{-j}\left[\ln p(\mathbf{X}, \mathbf{Z})\right]\right)}{\int_{\mathbf{Z}_j}\exp\left(\mathbb{E}_{-j}\left[\ln p(\mathbf{X}, \mathbf{Z})\right]\right)d\mathbf{Z}_j}
\end{aligned}$$


That is, the optimal distribution for $q(\mathbf{Z}_j)$ is the expectation of the complete-data log likelihood with respect to $q(\mathbf{Z}_i)$ of all other latent variables except for $\mathbf{Z}_j$. The higher-dimensional distribution $q(\mathbf{Z})$ is factored into several lower-dimensional distribution $q(\mathbf{Z}_j)$ by "plugging in" expectations to the higher-dimensional distributions therefore such method is called **mean field method**.


## Example - Gaussian Approximation

In this example, variational method is used to approximate a two-dimensional normal distribution $p(\mathbf{z}) = (z_1, z_2)'$,

$$p(\mathbf{z}) = \mathcal{N}\left(\mathbf{z}\vert \boldsymbol{\mu}, \boldsymbol{\Lambda^{-1}}\right)$$

where,

$$\boldsymbol{\mu} = \begin{pmatrix}\mu_1 \\\mu_2\end{pmatrix}$$

$$\boldsymbol{\Lambda} = \begin{pmatrix}\lambda_{11} & \lambda_{12} \\ \lambda_{21} & \lambda_{22}\end{pmatrix}$$

Suppose a factorized distribution of two one-dimensional normal distributions are used to approximate $p(\mathbf{z})$,

$$q(\mathbf{z}) = q(z_1) \cdot q(z_2)$$

$$q(z_i) = \mathcal{N}(z_i\vert m_i, \lambda_i^{-1})\quad i=1,2$$

Then the optimal solution of each factor is derived by expression $(13)$.

$$\begin{aligned}
\ln q(z_1) &= \mathbb{E}_{z_2}[\ln p(\mathbf{z})] \\
&= \mathbb{E}_{z_2}\left[\frac{1}{2}\ln (2\pi) + \ln \vert \Lambda \vert - \frac{1}{2}(\mathbf{z}-\boldsymbol{\mu})'\boldsymbol{\Lambda}(\mathbf{z}-\boldsymbol{\mu}) \right] \\
&= -\frac{1}{2} \left[\lambda_{11}z_1^2-2\left(\lambda_{11}\mu_1 - \lambda_{12}\mathbb{E}(z_2)+\lambda_{12}\mu_2\right)z_1\right]  + \text{const} \\
&= -\frac{1}{2}\lambda_{11}\left[(z_1-m_1)^2\right] + \text{const}
\end{aligned} \tag{14}$$

where the constant absorbs any terms that not includes $z_1$, and,

$$m_1 = \mu_1- \lambda_{11}^{-1}\lambda_{12}(\mathbb{E}(z_2)-\mu_2) \tag{15}$$

By $(14)$, the log of $q(z_1)$ takes the **quadratic form** of $z_1$, by **completing the square**, $q(z_1)$ follows a normal distribution,

$$q(z_1) = \mathcal{N}(m_1, \lambda_{11}^{-1}) \tag{16}$$

By symmetric,

$$q(z_2) = \mathcal{N}(m_2, \lambda_{22}^{-1}) \tag{17}$$

where,

$$m_2 = \mu_2 -\lambda_{22}^{-1}\lambda_{21}(\mathbb{E}(z_1)-\mu_1) \tag{18}$$

The functional form of $q(\cdot)$ is not determined beforehand, but naturally arises as the consequence of minimizing the KL divergence.

Because $m_1=\mathbb{E}(z_1)$, $m_2=\mathbb{E}(z_2)$, therefore either $(15)$ or $(18)$ doesn't give a closed form solution since they interdepend on each other.

We can reorganize determinantion equations for $m_1,m_2$ as followed,

$$\begin{cases}
m_1 + \lambda_{11}^{-1}\lambda_{12}m_2 = \lambda_{11}^{-1}\lambda_{12}\mu_2 + \mu_1 \\
m_2 + \lambda_{22}^{-1}\lambda_{21}m_1 = \lambda_{22}^{-1}\lambda_{21}\mu_1+\mu_2
\end{cases}

\tag{19}$$

Because covariance matrix is not singuar that is,

$$\lambda_{11} \ne 0 \quad \lambda_{22} \ne 0$$

$$\lambda_{11}\lambda_{22} \ne \lambda_{12}\lambda_{21}$$

that is equivalent to,

$$\lambda_{11}^{-1}\lambda_{12}$$


$$\lambda_{22}^{-1}\lambda_{21} \ne \lambda_{11}^{-1}\lambda_{12}$$

Notice that the product of two normal distributions is **NOT** a normal distribution even it represents an eclipse shape in the contour graph.
