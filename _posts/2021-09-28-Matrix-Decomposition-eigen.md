---
title: "Matrix Decomposition: Eigendecomposition"
mathjax: true
date: 2021-10-01
tags:
- Linear Algebra
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

## Matrix Decomposition: Eigendecomposition

In this blog, we'll talk about matrix eigendecomposition, or diagonalization, which is a widely used technique in linear algebra. 

<!--more-->

In [matrix representation](https://staratlas.xyz/2021/09/22/Matrix-Representation.html) we discuss how we can see matrix in the view of linear transformation of the space on one hand and the inverse matrix as the inverse transformation on the other hand. There is a quick review.

We have two column vectors $\mathbf{a}_1=\begin{pmatrix} 1 \\ 2\end{pmatrix}$ and $\mathbf{a}_2=\begin{pmatrix} 2 \\ 1\end{pmatrix}$, which combined column by column forms the matrix $\mathbf{A}$.

$$\mathbf{A} =  \begin{pmatrix} \mathbf{a}_1 & \mathbf{a}_2\end{pmatrix} = \begin{pmatrix} 1 & 2 \\ 2 & 1\end{pmatrix}$$

Now suppose for an arbitrary vector in the $x-y$ plane, that is, $\begin{pmatrix} x \\ y\end{pmatrix}$, we want to express it according to the bases of $\mathbf{a}_1$ and $\mathbf{a}_2$, that is, find a linear combination of $\mathbf{a}_1$ and $\mathbf{a}_2$ that results the vector $\begin{pmatrix} x \\ y\end{pmatrix}$, we need to solve the following problem,

$$\begin{pmatrix} x \\ y\end{pmatrix} = c_1 \begin{pmatrix} 1 \\ 2\end{pmatrix} + c_2 \begin{pmatrix} 2 \\ 1\end{pmatrix}=\begin{pmatrix} 1 & 2 \\ 2 & 1\end{pmatrix} \begin{pmatrix} c_1 \\ c_2\end{pmatrix} =\mathbf{A}\begin{pmatrix} c_1 \\ c_2\end{pmatrix}\tag{1}$$

Since $\mathbf{A}$ is invertible, we can solve for coefficient vector by multiplying its inverse on both sides of $(1)$.

$$\begin{pmatrix} c_1 \\ c_2\end{pmatrix} = \begin{pmatrix} 1 & 2 \\ 2 & 1\end{pmatrix}^{-1}\begin{pmatrix} x \\ y\end{pmatrix} = \mathbf{A}^{-1}\begin{pmatrix} x \\ y\end{pmatrix} \tag{2}$$

Now the meaning of inverse matrix becomes clear that once it is multiplied by a vector, it results the coefficients of the linear combination where this vector is expressed on the bases of the column vectors of this matrix.

Also, from the linear transformation view, $\mathbf{A}$ transforms $$\begin{pmatrix} c_1 \\ c_2\end{pmatrix}$$ into $$\begin{pmatrix} x \\ y\end{pmatrix}$$ in $(1)$ and $\mathbf{A}^{-1}$ transforms $$\begin{pmatrix} x \\ y\end{pmatrix}$$ back into $$\begin{pmatrix} c_1 \\ c_2\end{pmatrix}$$ in $(2)$ like counteraction of $\mathbf{A}$.

## Eigenvalue & Eigenvector

Matrix transforms the whole space, rotating, scaling and flipping any vectors in the space, while in the process some vectors only experience scaling. They are special because only their lenghths or directions change but not relative positions in the space. And these vectors are called **eigenvectors** and the scale coefficients associated with eigenvectors are called **eigenvalues**.

The formal definition of eigenvectors $\mathbf{p}$ and eigenvalues $\lambda$ of matrix $\mathbf{A}$ is,

$$\mathbf{A}\mathbf{p} = \lambda\mathbf{p} \tag{3}$$

which can be written as,

$$(\mathbf{A} - \lambda \mathbf{I})\mathbf{p} = \mathbf{0} \tag{4}$$

$(4)$ itself is a matrix multiplied by a column vector, meaning that taking some linear combination of columns of $\mathbf{A} - \lambda \mathbf{I}$ will result in zero vector, which implies that columns of $\mathbf{A} - \lambda \mathbf{I}$ are **linear dependent** therefore, $\mathbf{A} - \lambda \mathbf{I}$ is singular, with zero determinant.

$$\vert \mathbf{A} - \lambda \mathbf{I} \vert = 0 \tag{5}$$

Solving $(5)$ yields the eigenvalues and eigenvectors of $\mathbf{A}$.


For example, $$\mathbf{A} = \begin{pmatrix} 2 & 1\\ 3 & 4\end{pmatrix}$$ has eigen vectors $$\mathbf{p}_1=\begin{pmatrix} -1 \\ 1\end{pmatrix}$$ and $$\mathbf{p}_2=\begin{pmatrix} 1 \\ 3\end{pmatrix}$$, by linear transformation $\mathbf{A}$, both $\mathbf{p}_1$ and $\mathbf{p}_2$ only go through scaling,

$$\mathbf{A}\mathbf{p}_1 = \begin{pmatrix} -1\\1\end{pmatrix} = \mathbf{p}_1$$

$$\mathbf{A}\mathbf{p}_2 = \begin{pmatrix} 5\\15\end{pmatrix}=5\mathbf{p}_2$$

by linear transformation, $\mathbf{p}_1$ keeps unchanged and $\mathbf{p}_2$ is strehched five times its original length, therefore the eigenvalues associated with $\mathbf{p}_1$ and $\mathbf{p}_2$ are $1$ and $5$, both of them only being scaled, illustrated as below.

<div align="center">
    <img class="image image--xl" src="/img/1001-MD-E/plot1.gif">
</div>

The whole space is rotated and stretched while these <span style="color:green">two eigen vectors</span> stay along their original lines through the transformation, which implies that eigenvectors do not merely tell us vectors that only are scaled, but the directions along which eigenvectors lie.

Let $c_1\mathbf{p}_1$ and $c_2\mathbf{p}_2$ be two arbitrary vectors respectively along the direction of $\mathbf{p}_1$ and $\mathbf{p}_2$, by linear transformation $\mathbf{A}$,

$$\mathbf{A}c_1\mathbf{p}_1 = c_1\begin{pmatrix} -1\\1\end{pmatrix} = 1 (c_1\mathbf{p}_1) $$

$$\mathbf{A}c_2\mathbf{p}_2 = c_2\begin{pmatrix} 5\\15\end{pmatrix}=5(c_2\mathbf{p}_2) $$

it means that every vectors along the directions of eigenvectors are also eigenvectors, with the same eigenvalue each associated with one direction.

## Eigendecomposition

For a non-singular matrix $\mathbf{A}$ with linearly independent eigenvectors $\mathbf{p}_1, \mathbf{p}_2, \cdots, \mathbf{p}_n$ associated with eigenvalues $\lambda_1, \lambda_2, \cdots, \lambda_n$, the eigendecomposition of $\mathbf{A}$ is given by,

$$\mathbf{A}=\mathbf{P}\Lambda\mathbf{P}^{-1}$$

where $\mathbf{P}=\begin{pmatrix}\mathbf{p}_1 & \mathbf{p}_2 &\cdots& \mathbf{p}_n\end{pmatrix}$ and $$\Lambda=\begin{pmatrix}\lambda_1 & & & \\ & \lambda_2 & & \\ & & \ddots & \\ & & & \lambda_n\\\end{pmatrix}$$.

<div align="center">
    <img class="image image--xl" src="/img/1001-MD-E/plot2.gif">
</div>



## Diagonalization

## Similar Matrix