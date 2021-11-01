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

In this blog, we'll talk about matrix eigendecomposition, or diagonalization, which is a widely used technique in linear algebra. 

<!--more-->

In [matrix representation](https://staratlas.xyz/2021/09/22/Matrix-Representation.html) we discuss how we can see matrix in the view of linear transformation of the space on one hand and the inverse matrix as the inverse transformation on the other hand. There is a quick review.

We have two column vectors $\mathbf{a}_1=\begin{pmatrix} 1 \\ 2\end{pmatrix}$ and $\mathbf{a}_2=\begin{pmatrix} 2 \\ 1\end{pmatrix}$, which combined column by column forms the matrix $\mathbf{A}$.

$$\mathbf{A} =  \begin{pmatrix} \mathbf{a}_1 & \mathbf{a}_2\end{pmatrix} = \begin{pmatrix} 1 & 2 \\ 2 & 1\end{pmatrix}$$

Now suppose for an arbitrary vector in the $x-y$ plane, that is, $$\begin{pmatrix} x \\ y\end{pmatrix}$$, we want to express it according to the bases of $\mathbf{a}_1$ and $\mathbf{a}_2$, that is, find a linear combination of $\mathbf{a}_1$ and $\mathbf{a}_2$ that results the vector $\begin{pmatrix} x \\ y\end{pmatrix}$, we need to solve the following problem,

$$\begin{pmatrix} x \\ y\end{pmatrix} = c_1 \begin{pmatrix} 1 \\ 2\end{pmatrix} + c_2 \begin{pmatrix} 2 \\ 1\end{pmatrix}=\begin{pmatrix} 1 & 2 \\ 2 & 1\end{pmatrix} \begin{pmatrix} c_1 \\ c_2\end{pmatrix} =\mathbf{A}\begin{pmatrix} c_1 \\ c_2\end{pmatrix}\tag{1}$$

Since $\mathbf{A}$ is invertible, we can solve for coefficient vector by multiplying its inverse on both sides of $(1)$.

$$\begin{pmatrix} c_1 \\ c_2\end{pmatrix} = \begin{pmatrix} 1 & 2 \\ 2 & 1\end{pmatrix}^{-1}\begin{pmatrix} x \\ y\end{pmatrix} = \mathbf{A}^{-1}\begin{pmatrix} x \\ y\end{pmatrix} \tag{2}$$

Now the meaning of inverse matrix becomes clear that once it is multiplied by a vector, it results the coefficients of the linear combination where this vector is expressed on the bases of the column vectors of this matrix.

Also, from the linear transformation view, $\mathbf{A}$ transforms $$\begin{pmatrix} c_1 \\ c_2\end{pmatrix}$$ into $$\begin{pmatrix} x \\ y\end{pmatrix}$$ in $(1)$ and $\mathbf{A}^{-1}$ transforms $$\begin{pmatrix} x \\ y\end{pmatrix}$$ back into $$\begin{pmatrix} c_1 \\ c_2\end{pmatrix}$$ in $(2)$ like counteraction of $\mathbf{A}$.

## Eigenvalue & Eigenvector

Matrix transforms the whole space, rotating, scaling and flipping any vectors in the space, while in the process some vectors only experience scaling. They are special because only their lenghths or directions change but not relative positions in the space. And these vectors are called **eigenvectors** and the scale factors associated with eigenvectors are called **eigenvalues**.

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

by linear transformation, $\mathbf{p}_1$ keeps unchanged and $\mathbf{p}_2$ is stretched five times its original length, both of them only being scaled, illustrated as below. Therefore the eigenvalues associated with $\mathbf{p}_1$ and $\mathbf{p}_2$ are $1$ and $5$.

<div align="center">
    <img class="image image--xl" src="/img/1001-MD-E/plot1.gif">
</div>

The whole space, including the <span style="color:yellow">yellow vector</span> is rotated and stretched, while these two eigen vectors (illustrated in <span style="color:green">green</span> and <span style="color:orange">orange</span> respectively) stay along their original lines through this transformation.

 It also implies that eigenvectors do not merely tell us a set of vectors, but a set of directions along which eigenvectors lie that only are scaled by transformation.

Let $c_1\mathbf{p}_1$ and $c_2\mathbf{p}_2$ be two arbitrary vectors respectively along the direction of $\mathbf{p}_1$ and $\mathbf{p}_2$, by linear transformation $\mathbf{A}$,

$$\mathbf{A}c_1\mathbf{p}_1 = c_1\begin{pmatrix} -1\\1\end{pmatrix} = 1 (c_1\mathbf{p}_1) $$

$$\mathbf{A}c_2\mathbf{p}_2 = c_2\begin{pmatrix} 5\\15\end{pmatrix}=5(c_2\mathbf{p}_2) $$

it means that every vectors along the directions of eigenvectors are also eigenvectors, with the same eigenvalue each associated with one direction.

## Eigendecomposition

For a non-singular matrix $\mathbf{A}$ with linearly independent eigenvectors $\mathbf{p}_1, \mathbf{p}_2, \cdots, \mathbf{p}_n$ associated with eigenvalues $\lambda_1, \lambda_2, \cdots, \boldsymbol{\lambda_n}$, the eigendecomposition of $\mathbf{A}$ is given by,

$$\mathbf{A}=\mathbf{P}\Lambda\mathbf{P}^{-1} \tag{6}$$

where $\mathbf{P}=\begin{pmatrix}\mathbf{p}_1 & \mathbf{p}_2 &\cdots& \mathbf{p}_n\end{pmatrix}$ and $$\Lambda=\begin{pmatrix}\lambda_1 & & & \\ & \lambda_2 & & \\ & & \ddots & \\ & & & \lambda_n\\\end{pmatrix}$$.

Previously, we know that a matrix may be decomposed into multiple transformations each corresponding to a specific operation on the space. By eigendecomposition, $\mathbf{A}$ is decomposed into three components: $\mathbf{P}^{-1}$, $\boldsymbol{\Lambda}$ and $\mathbf{P}$. The order is of great importance because when we write $\mathbf{A}\mathbf{x}$, $\mathbf{x}$ goes through transformations by strict order. Therefore, we'll introduce each transformation one by one.

### $\mathbf{P}^{-1}$

At the beginning, we review the inverse matrix as the counteraction of the transformation imposed by the matrix. For an arbitrary vector in the plane, $$\mathbf{x}=\begin{pmatrix} x \\ y\end{pmatrix}$$, $$\mathbf{P}^{-1}\mathbf{x}$$ results in a vector whose elements are coefficients in the linear expression of $\mathbf{x}$ in the bases of column vectors of $\mathbf{P}$ ([review](https://staratlas.xyz/2021/09/22/Matrix-Representation.html) if it is unfamiliar to you.). Because $\mathbf{P}$ consists of eigenvectors of $\mathbf{A}$ as its columns, what $$\mathbf{P}^{-1}\mathbf{x}$$ really means is to project $\mathbf{x}$ into a "new coordinate systems" where the axes rather than $$\begin{pmatrix} 1\\0\end{pmatrix}$$ and $$\begin{pmatrix} 0 \\ 1\end{pmatrix}$$ are $\mathbf{p}_1$ and $\mathbf{p}_2$.

For example, let $$\mathbf{x}=\begin{pmatrix} -1 \\ 5\end{pmatrix}$$, which is the yellow vector in the graph above.

$$\mathbf{P}^{-1}\mathbf{x}=\mathbf{P}^{-1}\begin{pmatrix} -1 \\ 5\end{pmatrix}=\begin{pmatrix} 2 \\ 1\end{pmatrix} \tag{7}$$

we can recover the following relation from $(7)$,

$$\mathbf{P}\begin{pmatrix} 2 \\ 1\end{pmatrix} = 2\mathbf{p}_1 + \mathbf{p}_2= \begin{pmatrix} -1 \\ 5\end{pmatrix}=\mathbf{x}$$

which verifies that by $\mathbf{P}^{-1}\mathbf{x}$ we express $\mathbf{x}$ as linear combination of eigenvectors of $\mathbf{A}$, that is, $\mathbf{x}$ is $2$ times $\mathbf{p}_1$ plus $1$ times $\mathbf{p}_2$, illustrated below.

<div align="center">
    <img class="image image--xl" src="/img/1001-MD-E/plot4.svg">
</div>

It is clear that after transformation $\mathbf{P}^{-1}$, we end up with a new coordinate systems where <span style="color:orange">$\mathbf{p}_1$</span> and <span style="color:green">$\mathbf{p}_2$</span> are unit vectors along the $x$- and $y$- axis in the new transformed space. Also, they seem to be *orthogonal*. Is it true for any non-singular matrix $\mathbf{A}$ or purely accidental? Let's check it out by seeing how each $\mathbf{p}_i$ is transformed by $\mathbf{P}^{-1}$. For a $n\times n$ non-singular matrix $\mathbf{A}$ with eigen-matrix $\mathbf{P}=\begin{pmatrix} p_1 & p_2 & \cdots & p_n \end{pmatrix}$.

$$\mathbf{P}^{-1}\begin{pmatrix} p_1 & p_2 & \cdots & p_n \end{pmatrix} = \mathbf{P}^{-1} \mathbf{P}=\mathbf{I}_n$$

where $\mathbf{I}_n$ is the $n$-dimensional identity matrix, therefore, we know that after transformation $\mathbf{P}^{-1}$, this set of eigenvectors is **orthonormal basis** of the new space.

### $\boldsymbol{\Lambda}$

$\boldsymbol{\Lambda}$ is a diagonal matrix whose diagonal elements are eigenvalues of $\mathbf{A}$. For any vector in the plane, 

$$\boldsymbol{\Lambda}\mathbf{x} = \begin{pmatrix} \lambda_1 & \\ & \lambda_2 \end{pmatrix} \begin{pmatrix} x \\ y \end{pmatrix} = \begin{pmatrix} 1 & \\ & 5 \end{pmatrix} \begin{pmatrix} x \\ y \end{pmatrix} = x \begin{pmatrix} 1 \\ 0 \end{pmatrix} + y \begin{pmatrix} 0 \\ 5 \end{pmatrix} =  x \begin{pmatrix} 1 \\ 0 \end{pmatrix} + 5y \begin{pmatrix} 0 \\  1\end{pmatrix}$$

In means that by multiplying a diagonal matrix, the space is stretched such that each direction is scaled independent of others. Because $\mathbf{A}$ has eigenvalues $1$ and $5$, the $x$-direction keeps unchanged but $x$-direction is scaled $5$ times its original length.

<div align="center">
    <img class="image image--xl" src="/img/1001-MD-E/plot5.svg">
</div>

Notice that here the $x$-direction and $y$-direction are the directions of *eigenvectors* because by the $\boldsymbol{\Lambda}^{-1}$ transforamtion, we are in the space where vectors are located by eigenvectors. The benefit of it is that a matrix does't rotate or flip vectors along the directions of its eigenvectors, therefore, in this space, eigenvectors **play the role of orthonormal basis** just like the $\mathbf{u}=\begin{pmatrix} 1 \\ 0\end{pmatrix}$ and $\mathbf{v}=\begin{pmatrix} 0 \\ 1\end{pmatrix}$ in our very familiar 2-dimensional Cartesian coordinate system.

Also, since matrix only scales its eigenvectors by a fixed amount (the eigenvalue), how many times any vectors in this "eigen-space" are scaled in each direction are fully determined by the eigenvalue associated with each eigenvector.


### $\mathbf{P}$

In the "eigen-space" a vector is scaled in each direction according to the eigenvalues, however, we are still in the space whose orthonormal basis is the eigenvectors. We need to switch back to the original coordinate system to get the result. Therefore, in the last step, we need to multiply $\mathbf{P}$ to the original space.

The whole process of transformation imposed by $\mathbf{A}$ is animated below which consists of three steps according to the three components of matrix eigendecomposition.

<div align="center">
    <img class="image image--xl" src="/img/1001-MD-E/plot2.gif">
</div>

## Matrix Diagonalization

For the eigendecomposition $\mathbf{A} = \mathbf{P} \boldsymbol{\Lambda} \mathbf{P}^{-1}$, where $\mathbf{P}$ is invertible, and $\boldsymbol{\Lambda}$ is a diagonal matrix, we can recover $\boldsymbol{\Lambda}$ by multiplying $\mathbf{P}^{-1}$ and $\mathbf{P}$ on each side of the equation,

$$\mathbf{P}^{-1} \mathbf{A} \mathbf{P} = \boldsymbol{\Lambda}$$

which implies that we can recover a diagonal matrix by taking linear transformation upon $\mathbf{A}$. In this case, we say that **$\mathbf{A}$ is diagonalizable**, and, **$\mathbf{A}$ is similar to $\boldsymbol{\Lambda}$**.

We introduce the eigendecomposition of $\mathbf{A}$ in the previous section by assuming that $\mathbf{A}$ is a nonsingular matrix, but nonsingularity is actually not sufficient to ensure that $\mathbf{A}$ is diagonalizable.

