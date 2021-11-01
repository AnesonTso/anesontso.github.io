---
title: PRML Formula - 9 Mixture Model and EM
mathjax: true
date: 2021-02-26
tags:
- Probability
- "Machine Learning"
comment: true
excerpt_separator: <!--more-->

---

This blog collects detailed deduction of formulas in Bishop's *Pattern Recognition and
Machine Learning*, Chapter 9.

<!--more-->

## Section 9.3.3

When $$\mathbf{x}_n$$ is generated from $$\boldsymbol{\mu}_k$$, each element of $$\mathbf{x}_n$$ follows independent Bernulli distribution with parameter $$\mu_{ki}$$, which jointly has the following likelihood,

$$P(\mathbf{x}_n \mid \boldsymbol{\mu}_k) = \prod_{i=1}^D \mu_{ki}^{x_{ni}}(1-\mu_{ki})^{1-x_{ni}}

\tag{9.48}$$

If $$\mathbf{x}_n$$ is generated from a mixture of $$\boldsymbol{\mu}_k,k=1,2,\cdots, K$$, each weighted by $$\boldsymbol{\pi}=(\pi_1, \pi_2, \cdots, \pi_K)$$, that is,

$$P(\mathbf{x}_n \mid \boldsymbol{\mu}_k, \boldsymbol{\pi}) = \sum_{k=1}^K \pi_kP(\mathbf{x}_n \mid \boldsymbol{\mu}_k) \tag{9.47}$$

By introducing latent variable $\mathbf{z}=(z_1, z_2,\cdots, z_K)\prime$,

$$P(\mathbf{x}_n \mid \boldsymbol{\mathbf{z}_n, \mu}_k) = \prod_{k=1}^K P(\mathbf{x}_n \mid \boldsymbol{\mu}_k)^{z_{nk}} \tag{9.52}$$

$\mathbf{z}_n$ follows categorical distribution which has a conjugate prior following Dirichlet distribution, with probability density,

$$P(\mathbf{z}_n \mid \boldsymbol{\pi}) = \prod_{k=1}^K\pi_k^{z_{nk}} \tag{9.53}$$

and notice each $\mathbf{z}_n$ is an instantiation from distribution with $\boldsymbol{\pi}$.

From $(9.48)$ and $(9.52)$ the likelihood of single datum $\mathbf{x}_n$ is given by,

$$
\begin{aligned}
P(\mathbf{x}_n\mid \mathbf{z}_n,  \boldsymbol{\mu}_k) &= \prod_{k=1}^KP(\mathbf{x}_n\mid \boldsymbol{\mu}_k)^{z_{nk}} \\
&= \prod_{k=1}^K\left(\prod_{i=1}^D\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}} \\
&= \prod_{k=1}^K\prod_{i=1}^D \left(\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}}
\end{aligned}
$$

therefore, the likelihood of $N$ data $$\{\mathbf{x}_n\}_{n=1}^N$$ is that,

$$P(\mathbf{X}\mid \mathbf{Z}, \boldsymbol{\mu}) = \prod_{n=1}^N\prod_{k=1}^K\prod_{i=1}^D \left(\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}} \tag{*}
$$

Because $$\{\mathbf{z}_n\}_{n=1}^N$$ is generated independently and identically from $P(\mathbf{z}_n\mid \boldsymbol{\pi})$, the joint likelihood of $\mathbf{Z}$ is given by,

$$\begin{aligned}
P(\mathbf{Z}\mid \boldsymbol{\pi}) &= \prod_{n=1}^NP(\mathbf{z}_n\mid \boldsymbol{\pi}) \\
&= \prod_{n=1}^N \prod_{k=1}^K \pi_k^{z_{nk}}
\end{aligned} \tag{**}$$

Thus, the complete-data likelihood can be derived from $$(*)$$ and $$(**)$$,

$$\begin{aligned}
P(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\mu}, \boldsymbol{\pi}) &= P(\mathbf{X}\mid \mathbf{Z}, \boldsymbol{\mu})\times P(\mathbf{Z}\mid \boldsymbol{\pi}) \\
&= \prod_{n=1}^N\prod_{k=1}^K\prod_{i=1}^D \left(\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}}
\times \prod_{n=1}^N \prod_{k=1}^K \pi_k^{z_{nk}} \\
&= \prod_{n=1}^N\prod_{k=1}^K\left(\pi_k^{z_{nk}}\prod_{i=1}^D\left(\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}}\right)
\end{aligned}$$

Finially, the complete-data likelihood is then,

$$\begin{aligned}
\ln P(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\mu},\boldsymbol{\pi}) &= \ln \left(\prod_{n=1}^N\prod_{k=1}^K\left(\pi_k^{z_{nk}}\prod_{i=1}^D\left(\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}}\right) \right)\\
&= \sum_{n=1}^N \sum_{k=1}^K\ln\left(\pi_k^{z_{nk}}\prod_{i=1}^D\left(\mu_{ki}^{x_{ni}}(1-\mu_{ki}^{1-x_{ni}})\right)^{z_{nk}}\right) \\
&= \sum_{n=1}^N \sum_{k=1}^K\left(z_{nk} \ln \pi_k + \sum_{i=1}^D z_{nk} \left(x_{ni}\ln\mu_{ki} + (1-x_{ni})\ln(1-\mu_{ki}))\right)\right) \\
&= \sum_{n=1}^N \sum_{k=1}^K z_{nk}\left( \ln \pi_k + \sum_{i=1}^D \left(x_{ni}\ln\mu_{ki} + (1-x_{ni})\ln(1-\mu_{ki}))\right)\right)
\end{aligned} \tag{9.54}
$$

If take expectation of $(9.54)$ with respect to $\mathbf{z}$, that is, treating $\mathbf{x}$ as given, thus all components in the bigger brackets are constant therefore, the complete-data log likelihood with respect to posterior distribution of latant variable $\mathbf{Z}$ is simply,

$$\mathbb{E}_{\mathbf{z}}(\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\mu}, \boldsymbol{\pi})) = \sum_{n=1}^N \sum_{k=1}^K \gamma(z_{nk})\left( \ln \pi_k + \sum_{i=1}^D \left(x_{ni}\ln\mu_{ki} + (1-x_{ni})\ln(1-\mu_{ki}))\right)\right) $$

where $$\gamma(z_{nk}) = \mathbb{E}(z_{nk}\mid \mathbf{x}_n) = P(z_{nk}=1\mid \mathbf{x}_n)$$, which is the posterior probability of sample being generated from component $k$ after seeing sample $$\mathbf{x}_n$$, which, in **E step**, is calculated by,

$$\begin{aligned}
\gamma(z_{nk}) &= \mathbb{E}(z_{nk}\mid \mathbf{x}_n) = P(z_{nk}=1\mid \mathbf{x}_n) \\
&= \frac{P(z_{nk}=1)P(\mathbf{x}_n\mid z_{nk}=1)}{P(\mathbf{x}_n)} \\
&= \frac{\pi_k P(\mathbf{x}_n\mid z_{nk}=1)}{\sum_{j=1}^K \pi_j P(\mathbf{x}_n\mid z_{nj=1})} \\
&= \frac{\pi_kP(\mathbf{x}_n\mid \boldsymbol{\mu}_k)}{\sum_{j=1}^K \pi_jP(\mathbf{x}_n\mid \boldsymbol{\mu}_j)}
\end{aligned} \tag{9.56} $$


## Section 9.4

$$\begin{aligned}
\ln P(\mathbf{X}\mid \boldsymbol{\theta}) &= \sum_{\mathbf{z}}q(\mathbf{Z})\ln P(\mathbf{X}\mid \boldsymbol{\theta}) \\
&= \sum_{\mathbf{z}}q(\mathbf{Z})\ln \left( \frac{P(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\theta})}{P(\mathbf{Z}\mid \boldsymbol{\mathbf{X},\theta})} \right) \\
&= \sum_{\mathbf{z}} q(\mathbf{Z}) \ln\left( \frac{\frac{P(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})}{P(\mathbf{Z})} }{\frac{P(\mathbf{Z}\mid \mathbf{X},\boldsymbol{\theta})}{P(\mathbf{Z})}} \right) \\
&= \sum_{\mathbf{z}} q(\mathbf{Z}) \left( \ln\left(\frac{P(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})}{P(\mathbf{Z})}\right) - \ln \left(\frac{P(\mathbf{Z}\mid \mathbf{X},\boldsymbol{\theta})}{P(\mathbf{Z})}\right)  \right) \\
&= \sum_{\mathbf{z}}q(\mathbf{Z})\ln \left(\frac{P(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\theta})}{P(\mathbf{Z})}\right)
- \sum_{\mathbf{z}}q(\mathbf{Z})\ln \left( \frac{P(\mathbf{Z} \mid \mathbf{X},\boldsymbol{\theta})}{P(\mathbf{Z})} \right)\\
&= \mathcal{L}(q,\boldsymbol{\theta}) + \text{KL}(q||p)
\end{aligned} \tag{9.70}$$

where,

$$\mathcal{L}(q,\boldsymbol{\theta}) = \sum_{\mathbf{z}}q(\mathbf{z})\ln\left(\frac{P(\mathbf{X},\mathbf{Z}\mid \boldsymbol{\theta})}{P(\mathbf{Z})}\right) \tag{9.71}$$

$$\text{KL}(q||p) = -\sum_{\mathbf{z}}q(\mathbf{z})\ln\left(\frac{P(\mathbf{Z}\mid \mathbf{X},\boldsymbol{\theta})}{P(\mathbf{Z})}\right) \tag{9.72}$$
