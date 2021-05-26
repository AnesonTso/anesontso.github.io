---
title: Gaussian Mixture Model and EM Algorithm
mathjax: true
date: 2021-02-26
tags:
- Probability
- PRML
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
key: p2021-02-26-GMM
---

This is my review of Gaussian mixture model and EM algorithm in Bishop's book *Pattern Recognition and Machine Learning*[^1], including my organization of materials covered by the book along with code implementation and visualization. Formulas will not be deduced in detail since these work will be collected in *PRML Formula* series.

EM algorithm is a maximum likelihood estimation for parameters of a model with latent variables. Estimation is obtained by maximizing the expected complete log likelihood with respect to the posterior of latent variables.
{:.info}

## Missing Values and Latent Variable

Suppose we collect a bunch of sample points $\mathbf{X} = \\{\mathbf{x}_n,n=1,2,\cdots, N\\}$ in $\mathbb{R}^2$, that is, each $\mathbf{x}_n$ has two components $(x_1, x_2)$, which can be easily drawn in the Cartesian coordinate system for visualization, as in the following two graphs.

![](/img/226-GMM/complt_data.png)

Even all points are displayed in the same positions, these two graphs are distinct in the information they convey.

In the left graph, all points are colored purple, as if there were generated from a single distribution whereas in the right graph, we can clearly see that all points are grouped into two colors and the whole samples are formed by combining points from two distinct **clusters** together in a way points from each group are generated from different distribution.

The left graph represents the **incomplete data** because information of each sample point being generated from which cluster is missing. Unfortunately the graph also represents reality, where information is always mixed up and not seperated in nature. Now the burden falls on finding a solution to assigning each sample point to the cluster it is generated from, in other word, to recover the left graph to right graph, or to fill in missing information in the incomplete data, where the **EM** algorithm plays an important role.

For example, in several observations of $(X, Y)$ pairs, some values of $Y$ are missing from the samples,

|X|Y|
|:-:|:-:|
|1|0|
|1|?|
|0|1|
|1|0|
|0|?|
|0|1|


if we are reluctant to drop samples with missing values or the cost of doing so is expensive, the best strategy is to **infer** the missing values through fully observed samples. By investigating the samples, we "happen" to figure out that in all observed samples, either $X$ or $Y$ only takes $0$ and $1$ and they appear in opposite. Therefore, the first missing value of $Y$ is more **likely** to be $0$ and the second is $1$. Thus, by plugging in the inferred missing values of $Y$, we obtain a complete dataset.

In this example, some values of $Y$ are missing, in case where samples of a variable are all missing, or simply it is not observable, this variable is called **latent variable** just as in the beginning two clusters example, where variable indicating which cluster each sample is generated from is not observable.

Though it couldn't be that superficial to infer the missing values as in the second example, the basic idea is much the same, that is, *using observed values to infer the missing ones*.

Suppose the observed values are denoted as $\mathbf{x}$ and latent variable is denoted by $\mathbf{z}$ and $\mathbf{z}$ is assumed to follow a distribution $\boldsymbol{\pi}(\mathbf{z})$ which can be according to our empirical knowledge about it or simply using non-informative distribution, for instance, same probability for each possible state of the discrete variable or uniform distribution for continuous one.

Such probability distribution $\boldsymbol{\pi}(\mathbf{z})$ is called **prior** because this probability is what we assign to the latent variable without observing samples. And by observing samples $\mathbf{x}$, we gain information about the distribution of $\mathbf{z}$ then the distribution of $\mathbf{z}$ is **inferred** to be $P(\mathbf{z}\mid \mathbf{x})$, which is called **posterior** of $\mathbf{z}$ after observing sample $\mathbf{x}$.

## Gaussian Mixture Model

If we are given the the incomplete data in the first graph, how can we recover the clustering behind each sample?

Suppose you happen to figure out those samples seem to be generated from a mysterious distribution which is called **Gaussian mixture model** because it is simply combination of several Gaussian distributions, in a formal way,

$$p(\mathbf{x}) = \sum_{k=1}^K\pi_k\mathcal{N}(\mathbf{x}\mid \boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k) \tag{1}$$

$$\sum_{k=1}^K \pi_k = 1$$

$$\mathcal{N}(\mathbf{x} \mid \boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k) = (2\pi)^{-\frac{1}{2}}|\boldsymbol{\Sigma}|_k^{-\frac{1}{2}}e^{-\frac{1}{2}(\mathbf{x}-\boldsymbol{\mu}_k)'\boldsymbol{\Sigma}_k^{-1}(\mathbf{x}-\boldsymbol{\mu}_k)}$$

where $K$ is the number of components or clusters and $\boldsymbol{\mu}_k$ and $\boldsymbol{\Sigma}_k$ is the mean and covariance matrix for $k$-th Gaussian distribution and $\pi_k$ is the *weight* of it but can also be interpreted as the probability a sample is generated from $k$-th cluster.

![](/img/226-GMM/mixtureGaussian.png)

From the graph above we can see that those samples are well fitted into the Gaussian mixture model with $K=2$ components where one component has lower mean and bigger covariance and the other is higher in mean but lower in covariance.

Now the question becomes estimating the unknown parameters for each component, that is, $\boldsymbol{\mu}_1$, $\boldsymbol{\Sigma}_1$ and $\boldsymbol{\mu}_2$, $\boldsymbol{\Sigma}_2$ as well as the mixing coefficients $\boldsymbol{\pi}=(\pi_1,\pi_2, \cdots, \pi_K)'=(\pi_1, \pi_2)'$.

Suppose the cluster from which a sample $\mathbf{x}_n$ is generated is indicated by a one-hot encoding variable $\mathbf{z}_n=(z_1, z_2, \cdots, z_K)'=(z_1, z_2)\prime$ such that one and only one out of its $K$ components is 1 and 0 otherwise, then $z_k=1$ indicates that sample $\mathbf{x}_n$ belongs to cluster $k$ . Since we don't know the exact clustering of all samples, all $\mathbf{Z}=\\{\mathbf{z}_n, n=1,2,\cdots, N\\}$ are latent variables.

Thus, the likelihood of $\mathbf{x}_n$ given its corresponding latent variable $\mathbf{z}_n$ is given by,

$$p(\mathbf{x}_n \mid \mathbf{z}_n) = \prod_{k=1}^K\left(\mathcal{N}(\mathbf{x}_n\mid \boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k)\right)^{z_{nk}} \tag{2}$$

To implement *only one out of many* in formula, product with terms to some power is always a good choice.
{:.warning}

$\mathbf{z}_n$ is a random variable where only one of its component is 1 and 0 for others, it actually follows the multivariate extension of Bernoulli distribution, that is, **categorical distribution**,

$$p(\mathbf{z}_n\mid \boldsymbol{\pi}) = \prod_{k=1}^K \pi_k^{z_{nk}} \tag{3}$$

## Complete Data Case

Assume that we know beforehand the exact clustering of all samples $\mathbf{X}=\\{\mathbf{x}_n,n=1,2,\cdots, N\\}$, that is, $\mathbf{Z}=\\{\mathbf{z}_n, n=1,2,\cdots,N\\}$ are known, then, all variables involved are observed.

![](/img/226-GMM/complete-datasamples.png)

we can try to recover $\boldsymbol{\mu}_k$, $\boldsymbol{\Sigma}_k$ and $\pi_k$ from this complete-data case by **maximization likelihood estimation**.

Because samples are independent, the joint likelihood function of a single observation of $(\mathbf{z}_n, \mathbf{x}_n)$ is that,

$$\begin{aligned}
p(\mathbf{x}_n, \mathbf{z}_n\mid \boldsymbol{\mu}, \boldsymbol{\Sigma}, \boldsymbol{\pi}) &= p(\mathbf{z_n}\mid \boldsymbol{\pi}) \cdot p(\mathbf{x}_n \mid \mathbf{z}_n, \boldsymbol{\mu}, \boldsymbol{\Sigma}) \\
&= \prod_{k=1}^{K} \pi_{k}^{z_{n k}} \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)^{z_{n k}}
\end{aligned} \tag{4}$$

The joint likelihood for all $n$ independent samples thus is,

$$p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\mu}, \boldsymbol{\Sigma}, \boldsymbol{\pi}) = \prod_{n=1}^N \prod_{k=1}^{K} \pi_{k}^{z_{n k}} \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)^{z_{n k}}
\tag{5}$$

by log-transformation, we have the **complete-data log likelihood**,

$$\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\mu}, \boldsymbol{\Sigma}, \boldsymbol{\pi})=\sum_{n=1}^{N} \sum_{k=1}^{K} z_{n k}\left\{\ln \pi_{k}+\ln \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)\right\}
\tag{6}$$

Now, maximum likelihood estimation for $\boldsymbol{\mu}_k, \boldsymbol{\Sigma}_k$ and $\pi_k$ can be derived by taking corresponding partial derivative of $(6)$, which yields,

$$\boldsymbol{\mu}_k = \frac{\sum_{n=1}^Nz_{nk}\mathbf{x}_n}{N_k} \tag{7}$$

where

$$N_k = \sum_{n=1}^Nz_{nk} \tag{8}$$

which means the number of samples assigned to cluster $k$.

$$
\boldsymbol{\Sigma}_{k}=\frac{1}{N_{k}} \sum_{n=1}^{N} z_{nk}\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)^{\mathrm{T}}
\tag{9}$$

MLE for `$\boldsymbol{\mu}_k$` and `$\boldsymbol{\Sigma}_k$` under complete data case are rather intuitive, since `$\sum_{n=1}^Nz_{nk}$` selects out all samples in cluster $k$, thus the estimation for mean and covariance of cluster $k$ are simply sample mean and sample covariance based on samples assigned to cluster $k$. This process is illustrated in the graph below,

![](/img/226-GMM/complete-data.png)

For the weighting coefficient,

$$\pi_k = \frac{N_k}{N} \tag{10}$$

The estimation of probability for a sample to be generated from cluster $k$ is simply the proportion of samples in cluster $k$.

## Incomplete Data Case

When the latent variables $\mathbf{Z}$ are not observable, in this case, the joint log-likelihood function for $(\mathbf{X}, \mathbf{Z})$ is not available.

In this incomplete data case, only likelihood of observed samples $\mathbf{X}$ can be derived,

$$
\ln p(\mathbf{X} \mid \boldsymbol{\pi}, \boldsymbol{\mu}, \boldsymbol{\Sigma})=\sum_{n=1}^{N} \ln \left\{\sum_{k=1}^{K} \pi_{k} \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)\right\}
 \tag{11}$$

 Similarly by the MLE methods, we can derive estimation for $\boldsymbol{\mu}_k$, $\boldsymbol{\Sigma}_k$, $\pi_k$.

 $$
\boldsymbol{\mu}_{k}=\frac{1}{N_{k}} \sum_{n=1}^{N} \gamma\left(z_{n k}\right) \mathbf{x}_{n} \tag{12}
$$

where,

$$
\gamma(z_{nk}) = \frac{\pi_{k} \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)}{\sum_{j=1}^K \pi_{j} \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{j}, \boldsymbol{\Sigma}_{j}\right)} \tag{13}
$$

and,

$$N_k = \sum_{n=1}^N\gamma(z_{nk}) \tag{14}$$

Comparing $(12)$ to $(7)$ will find that instead of taking sample average of samples in cluster $k$ as mean estimate for cluster $k$, now, because assignments are no longer available, the mean estimate for cluster $k$ is now average of **all** samples weighted by $\gamma(z_{nk})$ in $(13)$, which is a metric on both sample $n$ and cluster $k$.

Comparing $(14)$ to $(8)$ will find that **direct count** is **substituted** for sum of metrics $\gamma(z_{nk})$.

$$
\boldsymbol{\Sigma}_{k}=\frac{1}{N_{k}} \sum_{n=1}^{N} \gamma\left(z_{n k}\right)\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)^{\mathrm{T}}
\tag{15}$$

For covariance estimate, it is similar to mean estimate in a way that cluster sample covariance is **substituted** for weighted sample covariance of all samples with weights being given by $(16)$.

And,

$$\pi_k = \frac{N_k}{N} \tag{16}$$

is similar to $(10)$ but the meaning of $N_k$ has changed.

It seems $\gamma(z_{nk})$ plays an important role in estimation with presence of latent variables. Actually, it is the posterior of the latent variable for sample $\mathbf{x}_n$ belonging to cluster $k$ after observing the sample itself.

$$
\begin{aligned}
\mathbb{E}(z_{nk})=p\left(z_{nk}=1 \mid \mathbf{x}_n\right) &=\frac{p\left(z_{nk}=1\right) p\left(\mathbf{x}_n \mid z_{nk}=1\right)}{\sum_{j=1}^{K} p\left(z_{nj}=1\right) p\left(\mathbf{x}_n \mid z_{nj}=1\right)} \\
&=\frac{\pi_{k} \mathcal{N}\left(\mathbf{x}_n \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)}{\sum_{j=1}^{K} \pi_{j} \mathcal{N}\left(\mathbf{x}_n \mid \boldsymbol{\mu}_{j}, \boldsymbol{\Sigma}_{j}\right)} \\
&= \gamma(z_{nk})
\end{aligned}
\tag{17} $$

Now it becomes clear that $\gamma(z_{nk})$ is the mean *belief* of sample $n$ generated by cluster $k$. Just as the naive example in the beginning, when missing values exist, we can first use observed values to infer them. In this case, when latent variable is not observable, we can use observed samples to infer it in the way to estimate its posterior distribution.

Therefore, estimation of Gaussian mixture model under latent variable for each parameter is by taking average of whole samples weights by its posterior probability that the sample belongs to the corresponding cluster.

## EM Algorithm

The MLE for unknonw parameters are,

$$\boldsymbol{\mu}_k =  \frac{1}{N_k}\sum_{n=1}^N\gamma(z_{nk}) \mathbf{x}_n \tag{12}$$

where,

$$N_k = \sum_{n=1}^N\gamma(z_{nk}) \tag{14}$$

$$\boldsymbol{\Sigma}_k = \frac{1}{N_k}\sum_{n=1}^N\gamma(z_{nk})(\mathbf{x}_n-\boldsymbol{\mu}_k)(\mathbf{x}_n-\boldsymbol{\mu}_k)^\text{T} \tag{15}$$

$$\pi_k = \frac{N_k}{N} \tag{16}$$

But all the parameter estimations depend on posterior probability $\gamma(z_{nk})$, and this probability in turn depends on the estimations. This interdependency between estimation of posterior probability and unknown parameters makes MLE results not available directly.

When we provide an **initial** guess of the parameters,

$$\boldsymbol{\mu^0} = \{\boldsymbol{\mu}^0_k, \},\boldsymbol{\Sigma^0}=\{\boldsymbol{\Sigma}^0_k\},\boldsymbol{\pi^0}=\{\pi_k^0\}, k=1,2,\cdots, K$$


the estimation of $$\gamma(z_{nk})$$ is given by its posterior mean, which is the **expectation** of its posterior distribution. And with available $$\gamma(z_{nk})$$, we can by maximizating log-likelihood, **update** the $\boldsymbol{\mu^0}$, $\boldsymbol{\Sigma^0}$ and $\boldsymbol{\pi^0}$ to $\boldsymbol{\mu^1}$, $\boldsymbol{\Sigma^1}$ and $\boldsymbol{\pi^1}$, and in turn calculate new $$\gamma(z_{nk})$$, derive new parameter estimation so on and so forth until the log-likelihood becomes stable in which case the log-likelihood acheives its local maximum.


This method alternately taking **expectation** to update its posterior belief and by **maximization** calculating new parameter estimation that better explains the data is called **EM** algorithm, or **expectation maximization**, which is guaranteed to improve the log-likelihood through iterations.

Back to the beginning example, if we want to recover the grouping and estimate parameters behinds those two distributions, we can use EM algorithm, which is illustrated below,

![](/img/226-GMM/EMiter.gif)

By iterations, samples are assigned to one of two clusters indicated by coloring each sample either red or blue. The contours of both Gaussian distributions are ploted in surrounding ellipses with corrsponding colors. Notice the samples along the intersection of two distributions are marked purple which is the transitional color between red and blue, for the reason that samples in the intersection are harder to figure out which cluster it should be assigned to, in other words, it is equally likely to be generated from both clusters in posterior probability.

Also notice the sample located near $(4, 1)$, it was marked blue whereas as the Gaussian distribution in blue tighten its variance on the dimension parallel to the direction this sample towards the distribution, this sample becomes statistically distant from the Gaussian in blue compared that in red thus marked red even it can be nearer to the mean point of Gaussian in blue in the coordinate distance.

Clustering is considered by assigning samples to their corresponding clusters where distance between samples in the same clusters are shorter than that between samples in distinct clusters. In EM algorithm, the distance considered is measured by **posterior probability**.

## Principle of EM Algorithm

In the *incomplete data* case, parameters are estimated by maximizing $(11)$, where the summation is within the logarithm operation which makes the results not in closed form as in the *complete case* by maximizing $(6)$, where the logarithm operation directly applies on the pdf of Gaussian distribution, which is a member of exponential family therefore cancels out the exponential operation, thus exposes elements on which maximization is performed, therefore produce results in closed form.

$$\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\mu}, \mathbf{\Sigma}, \boldsymbol{\pi})=\sum_{n=1}^{N} \sum_{k=1}^{K} z_{n k}\left\{\ln \pi_{k}+\ln \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \mathbf{\Sigma}_{k}\right)\right\} \tag{6}$$

$$
\ln p(\mathbf{X} \mid \boldsymbol{\pi}, \boldsymbol{\mu}, \boldsymbol{\Sigma})=\sum_{n=1}^{N} \ln \left\{\sum_{k=1}^{K} \pi_{k} \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)\right\} \tag{11}
$$

Now the question is, why by EM algorithm, estimated parameters by alternative and iterative E step and M step converge to (local if not global) maximizers of the log likelihood in $(11)$.

If take expectation of complete-data log likelihood in $(6)$ with respect to posterior distribution of $\mathbf{Z}$ in $(17)$,

$$
\mathbb{E}_{\mathbf{Z}}[\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\mu}, \boldsymbol{\Sigma}, \boldsymbol{\pi})]=\sum_{n=1}^{N} \sum_{k=1}^{K} \gamma\left(z_{n k}\right)\left\{\ln \pi_{k}+\ln \mathcal{N}\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)\right\}
\tag{18}$$

By maximizing $(18)$, the MLE results are actually equivalent to those derived by maximizing $(11)$, that is, the results derived by maximizing incomplete-data log likelihood are equivalent to those derived by maximizing the expected complete-data log likelihood with respect to the posterior of latent variables.

Denote all the observed data as $\mathbf{X}$, latent variables $\mathbf{Z}$ with prior $q(\mathbf{Z})$, and parameters $\boldsymbol{\theta}$, then,

$$\begin{aligned}
\boldsymbol{\theta} &= \arg\max_{\boldsymbol{\theta}} \ln p(\mathbf{X}\mid \mathbf{Z},\boldsymbol{\theta}) \\
&= \arg\max_{\boldsymbol{\theta}} \mathbb{E}_{\mathbf{Z}} \ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\theta})
\end{aligned} \tag{19}$$

The reason behind $(19)$ will become clear after investigating the process behind maximization of incomplete-data log-likelihood.

$$\begin{aligned}
\ln p(\mathbf{X}\mid \boldsymbol{\theta}) &= \sum_{\mathbf{Z}}q(\mathbf{Z}) \ln p(\mathbf{X}\mid \boldsymbol{\theta}) \\
&= \sum_{\mathbf{Z}}q(\mathbf{Z})\left(\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\theta}) - \ln p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta})\right) \\
&= \sum_{\mathbf{Z}}q(\mathbf{Z})\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\theta}) -  \sum_{\mathbf{Z}} \ln q(\mathbf{Z}) p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}) \\
&= \sum_{\mathbf{Z}}q(\mathbf{Z})\ln p(\mathbf{X}, \mathbf{Z} \mid \boldsymbol{\theta}) -\sum_{\mathbf{Z}}q(\mathbf{Z})\ln q(\mathbf{Z})  \\
& \quad -  \sum_{\mathbf{Z}} q(\mathbf{Z})  \ln p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}) + \sum_{\mathbf{Z}}q(\mathbf{Z})\ln q(\mathbf{Z}) \\
&= \sum_{\mathbf{Z}}q(\mathbf{Z})\ln\left\{\frac{p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})}{q(\mathbf{Z})}\right\} - \sum_{\mathbf{Z}} q(\mathbf{Z}) \ln \left\{ \frac{p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta})}{q(\mathbf{Z})} \right\} \\
&= \mathcal{L}(q, \boldsymbol{\theta}) + \text{KL}(q||p)
\end{aligned} \tag{20}$$

where,

$$ \mathcal{L}(q, \boldsymbol{\theta}) = \sum_{\mathbf{Z}}q(\mathbf{Z})\ln\left\{\frac{p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})}{q(\mathbf{Z})}\right\}  \tag{21}$$

is the functional of $q$ and $\boldsymbol{\theta}$ and contains the joints probability of $\mathbf{X}$ and $\mathbf{Z}$,

and the other component,

$$\text{KL}(q||p) = - \sum_{\mathbf{Z}} q(\mathbf{Z}) \ln \left\{ \frac{p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta})}{q(\mathbf{Z})} \right\} \tag{22} $$

contains the posterior / conditional probability of $\mathbf{Z}$ given $\mathbf{X}$ and is the Kullback-Leibler divergence for prior distribution $q(\mathbf{Z})$ and posterior distribution $q(\mathbf{Z}\mid \mathbf{X})$.

Because KL divergence is nonnegative, that is, $\text{KL}(q\vert \vert p) \ge 0$, then,

$$\ln p(\mathbf{X}\mid \boldsymbol{\theta}) \ge \mathcal{L}(q, \boldsymbol{\theta})$$

which means the incomplete-data log-likelihood has a lower bound of $\mathcal{L}(q,\boldsymbol{\theta}^{0})$ once we prove an initial parameter $\boldsymbol{\theta}^0$.

Notice that the incomplete-data log-likelihood $p(\mathbf{X}\mid \boldsymbol{\theta})$ does not depend on latent variables $\mathbf{Z}$ (see $(11)$ for example). Therefore, in the $E$ step, to maximize $p(\mathbf{X}\mid \boldsymbol{\theta})$, or equivalently, to raise the lower bound $\mathcal{L}(q, \boldsymbol{\theta}^0)$ can only be achieved when KL divergence is 0 if and only if $q(\mathbf{Z})=p(\mathbf{Z}\mid \mathbf{X},\boldsymbol{\theta}^0)$, that is, update the prior of $\mathbf{Z}$ to its posterior $p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0)$.

When $q\prime(\mathbf{Z})=p(\mathbf{Z} \mid \mathbf{X}, \boldsymbol{\theta}^0)$, in the $M$ step, to maximize $p(\mathbf{X} \mid \boldsymbol{\theta})$ is to maximize $\mathcal{L}(q\prime,\boldsymbol{\theta})$ with respect to $\boldsymbol{\theta}$.

$$\begin{aligned}
\mathcal{L}(q\prime, \boldsymbol{\theta}) & \stackrel{E \text{step}}{=} \mathcal{L}(p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0), \boldsymbol{\theta}) \\
&= \sum_{\boldsymbol{Z}}p(\mathbf{Z} \mid \mathbf{X}, \boldsymbol{\theta}^0) \ln \left\{ \frac{p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})}{p(\mathbf{Z}\mid \mathbf{X},\boldsymbol{\theta}^0)} \right\} \\
&= \sum_{\mathbf{Z}}p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0)\ln p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta}) - \sum_{\mathbf{Z}} p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0) \ln p(\mathbf{Z} \mid \mathbf{X}, \boldsymbol{\theta}^0) \\
&=  \sum_{\mathbf{Z}}p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0)\ln p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})  + \text{const}
\end{aligned} \tag{23}$$

the reason that the second term is constant is that it is entropy of distribution $p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0)$ which is irrelevant to $\boldsymbol{
\theta}$.

To maximize $(23)$ with respect to $\boldsymbol{\theta}$,

$$\begin{aligned}
\boldsymbol{\theta}^1 &= \arg\max_{\boldsymbol{\theta}} \mathcal{L}(q\prime, \boldsymbol{\theta}) \\
&= \arg\max_{\boldsymbol{\theta}}\sum_{\mathbf{Z}}p(\mathbf{Z}\mid \mathbf{X}, \boldsymbol{\theta}^0)\ln p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta}) \\
&= \arg\max_{\boldsymbol{\theta}} \mathbb{E}_{\boldsymbol{Z}}\ln p(\mathbf{X}, \mathbf{Z}\mid \boldsymbol{\theta})
\end{aligned}$$

which is exactly to maximize the complete-data log likelihood with respect to posterior distribution of latent variable $\mathbf{Z}$.

Notice that we want to derive the maximum likelihood estimation for the unknown parameters, but by maximizing the likelihood of observations with latent variable we end up with estimation of $\boldsymbol{\theta}$ as the **MAP** or *maximum a posteriori* estimation of the joint likelihood with respect to the posterior of latent variables, which might due to the randomness incorporated into the model by latent variable.

In the following iterations, it simply replaces $\boldsymbol{\theta}^0$ to $\boldsymbol{\theta}^{\text{old}}$ and $\boldsymbol{\theta}^1$ to $\boldsymbol{\theta}^{\text{new}}$.

[^1]: For more information about Christopher Bishop's *Pattern Recognition and Machine Learning*, refer to its [website](https://www.microsoft.com/en-us/research/people/cmbishop/prml-book/).

