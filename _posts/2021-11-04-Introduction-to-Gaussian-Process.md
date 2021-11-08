---
title: "Introduction to Gaussian Process"
mathjax: true
date: 2021-11-04
tags:
- "Probabilistic Reasoning"
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

Gaussian process is a technique not only used in regression but also having its role in problem of classification. It is a simple yet powerful modelling method that fully utilizes both properties of Gaussian distributions and kernel methods. This post will give a gentle introduction to how these parts of methods are interconnected to be such an extensive and practical tool.

## Conditional Gaussian

Suppose there are two multivariate random variables $\mathbf{X} \in \mathbb{R}^p$ and $\mathbf{Y} \in \mathbb{R}^q$, jointly following multivariate Gaussian distribution, 

$$\begin{pmatrix}
\mathbf{X} \\ \mathbf{Y}
\end{pmatrix} \sim \boldsymbol{\mathcal{N}}\left(
  \begin{pmatrix}
\mu_\mathbf{X} \\ \mu_\mathbf{Y}
\end{pmatrix},
\begin{pmatrix}
\boldsymbol{\Sigma_{X}} & \boldsymbol{\Sigma_{X,Y}} \\
\boldsymbol{\Sigma_{Y,X}} & \boldsymbol{\Sigma_{Y}}
\end{pmatrix} \right)$$

where $\mu(\cdot)$ and $\boldsymbol{\Sigma}_{\cdot}$ are mean and variance of each variable respectively and $\boldsymbol{\Sigma_{X,Y}}$ is the covariance between $\mathbf{X}$ and $\mathbf{Y}$.

The truly useful property of Gaussian distribution is that we can infer the distribution of a marginal variable given some knowledge about the others. Since there exist the covariance $\boldsymbol{\Sigma_{X, Y}}$, it means that $\mathbf{X}$ and $\mathbf{Y}$ must have been probabilistically related, that is, correlated, then some a priori information about $\mathbf{X}$ will narrow down the possibility about $\mathbf{Y}$ in the form of conditional distribution $p(\mathbf{Y} \vert \mathbf{X})$. To prove the conditional Gaussian distribution, we need to use another property of Gaussian distribution that two random variables each follows Gaussian distribution are **independent** if they are not correlated, that is, $\boldsymbol{\Sigma_{X, Y}}=\mathbf{0}$, where the $\mathbf{0}$ stands for zero matrix.

Two uncorrelated Gaussian random variables are independent.
.{:info}

Now we need another variable $\mathbf{Z}$ that is correlated with $\mathbf{Y}$ but independent of $\mathbf{X}$ such that when conditioned on $\mathbf{X}$ it has nothing to do with the distribution of $\mathbf{Z}$. Let,

$$\mathbf{Z} = \mathbf{Y} - \mathbf{A}\mathbf{X}$$

where $\mathbf{A}$ is a $q\times p$ matrix. 

$\mathbf{Z}$ is correlated with $\mathbf{Y}$ but independent with $\mathbf{X}$ by some matrix $\mathbf{A}$ which cuts down the correlation between $\mathbf{X}$ and $\mathbf{Z}$.

We can determine the $\mathbf{A}$ by the restriction imposed by uncorrelation, that is, $\text{cov}(\mathbf{X},\mathbf{Z})=0$,

$$\begin{equation}
\begin{aligned}
\text{cov}(\mathbf{X},\mathbf{Z}) &= \mathbb{E}(\mathbf{X}^T\mathbf{Z}) - \mathbb{E}(\mathbf{X})^T\mathbb{E}(\mathbf{Z}) \\
&= \mathbb{E}(\mathbf{X}^T(\mathbf{Y}-\mathbf{A}\mathbf{X}))-\mathbb{E}(\mathbf{X})^T\mathbb{E}(\mathbf{Y}-\mathbf{A}\mathbf{X}) \\
&= \left(\mathbb{E}(\mathbf{X}^T\mathbf{Y}) - \mathbb{E}(\mathbf{X}^T\mathbf{A}\mathbf{X}) \right) - \left(\mathbb{E}(\mathbf{X}^T\mathbf{A}\mathbf{X} ) - \mathbb{E}(\mathbf{X}^T)\mathbb{E}(\mathbf{A}\mathbf{X})\right) \\
&= \boldsymbol{\Sigma_{X,Y}} - \boldsymbol{\Sigma_{X}}\mathbf{A}^T \\
& \stackrel{\Delta}{=} \mathbf{0}
\end{aligned}
\end{equation}$$

Solve equation $(1)$ yields,

$$\begin{equation}
\mathbf{A} = \boldsymbol{\Sigma_{Y, X}} \boldsymbol{\Sigma_X}^{-1}
\end{equation}$$

There is another fact about Gaussian distribution that its conditional distribution is also Gaussian, which means to fully determines the conditional distribution, we need only to figure out the mean and variance of the conditional variable.

The conditional distribution of a joint Gaussian distribution is also Gaussian.
{:.info}

$$\begin{equation}
\begin{aligned}
\mathbb{E}(\mathbf{Y} \vert \mathbf{X}) &= \mathbb{E}(\mathbf{Z}+ \mathbf{A}\mathbf{X} \vert \mathbf{X}) \\
&\stackrel{*}{=} \mathbb{E}(\mathbf{Z}) + \mathbf{A} \mathbf{X} \\
&= \mu(\mathbf{Y}) - \mathbf{A}\mu(\mathbf{X}) + \mathbf{A}\mathbf{X} \\
&= \mu_{\mathbf{Y}} + \mathbf{A}(\mathbf{X} - \mu_{\mathbf{X}}) \\
&= \mu_{\mathbf{Y}} + \boldsymbol{\Sigma_{Y,X}} \boldsymbol{\Sigma_X}^{-1}(\mathbf{X} - \mu_{\mathbf{X}})
\end{aligned}
\end{equation}$$

where equation(*) uses the facts that $\mathbf{X}$ and $\mathbf{Z}$ are independent and $\mathbb{E}(\mathbf{X}\vert \mathbf{X})$ is $\mathbf{X}$ itself.

For the variance,

$$\begin{equation}
\begin{aligned}
\text{var}(\mathbf{Y} \vert \mathbf{X}) &= \text{var}(\mathbf{Z} + \mathbf{A} \mathbf{X} \vert \mathbf{X}) \\
&= \text{var}(\mathbf{Z}) + \mathbf{A}\text{var}(\mathbf{X} \vert \mathbf{X}) \mathbf{A}^T \\
&= \text{var}(\bar{\mathbf{Y}}-\mathbf{A}\bar{\mathbf{X}} + \mu_\mathbf{Y}-\mathbf{A}\mu_{\mathbf{X}}) + \mathbf{0} \\
\end{aligned}
\end{equation}$$

where $\bar{\mathbf{X}}$ and $\bar{\mathbf{Y}}$ represent $\mathbf{X}-\mu_{\mathbf{X}}$ and $\mathbf{Y}-\mu_{\mathbf{Y}}$ respectively. Now equation $(4)$ proceeds as,

$$\begin{equation}
\begin{aligned}
\text{var}(\mathbf{Y} \vert \mathbf{X}) &= \text{var}(\bar{\mathbf{Y}}-\mathbf{A}\bar{\mathbf{X}})\\
&= \boldsymbol{\Sigma_{Y}} + \mathbf{A}\boldsymbol{\Sigma_{X}}\mathbf{A}^T - 2\mathbf{A}\boldsymbol{\Sigma_{X, Y}} \\
&= \boldsymbol{\Sigma_{Y}} + \boldsymbol{\Sigma_{Y, X}} \boldsymbol{\Sigma_X}^{-1}\boldsymbol{\Sigma_{X}} \boldsymbol{\Sigma_X}^{-1}\boldsymbol{\Sigma_{X, Y}} - 2\boldsymbol{\Sigma_{Y, X}} \boldsymbol{\Sigma_X}^{-1}\boldsymbol{\Sigma_{X, Y}} \\
&= \boldsymbol{\Sigma_{Y}}  - \boldsymbol{\Sigma_{Y, X}} \boldsymbol{\Sigma_X}^{-1}\boldsymbol{\Sigma_{X, Y}} 
\end{aligned}
\end{equation}$$

Therefore, the conditional Gaussian is given by,

$$\begin{equation}
\mathbf{Y} \vert \mathbf{X} \sim \mathcal{N}(\mathbf{Y}\vert \mu_{\mathbf{Y} \vert \mathbf{X}}, \boldsymbol{\Sigma_{\mathbf{Y} \vert \mathbf{X}}})
\end{equation}$$

where,

$$\mu_{\mathbf{Y} \vert \mathbf{X}}=\mu_{\mathbf{Y}} + \boldsymbol{\Sigma_{Y,X}} \boldsymbol{\Sigma_X}^{-1}(\mathbf{X} - \mu_{\mathbf{X}})$$

$$\boldsymbol{\Sigma_{\mathbf{Y} \vert \mathbf{X}}}=\boldsymbol{\Sigma_{Y}}  - \boldsymbol{\Sigma_{Y, X}} \boldsymbol{\Sigma_X}^{-1}\boldsymbol{\Sigma_{X, Y}} $$

If $\mathbf{X}$ and $\mathbf{Y}$ are independent, that is, $\boldsymbol{\Sigma_{X,Y}} = \mathbf{0}$, the conditional mean and variance degenerate to the mean and variance of $\mathbf{Y}$, which means knowing the value $\mathbf{X}$ takes on provides no information about the distribution of $\mathbf{Y}$. Also, if $\mathbf{X}$ and $\mathbf{Y}$ are more and more correlated, that is, $\boldsymbol{\Sigma_{X, Y}}$ is "larger and larger" in some metric, the contribution of $\mu_\mathbf{X}$ in the determination of $\mu_{\mathbf{Y}\vert \mathbf{X}}$ gets larger and the variance of conditional Gaussian is decreased from the variance of $\mathbf{Y}$, meaning an increase in precision.


## Gaussian Process

