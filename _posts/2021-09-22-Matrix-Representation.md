---
title: Matrix Representation
mathjax: true
date: 2021-09-22
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

In this blog, we'll mention some elementary properties of matrix, which will be useful in our subsequent series.

<!--more-->

## Matrix Multiplied By A Vector

Now let's look at a very basic operation in linear algebra: a matrix multiplied by a column vector. For example,

$$\begin{pmatrix}1 & 2 \\ 3 & 4\end{pmatrix}\begin{pmatrix} 6 \\ 2\end{pmatrix} = \begin{pmatrix} 1\times 6 + 2\times 2 \\ 3 \times 6 + 4\times 2 \end{pmatrix} = \begin{pmatrix} 10 \\ 26\end{pmatrix} \tag{1}$$

Actually, the multiplication above can be represented as,

$$\begin{pmatrix}1 & 2 \\ 3 & 4\end{pmatrix}\begin{pmatrix} 6 \\ 2\end{pmatrix} = 6 \begin{pmatrix} 1 \\ 3\end{pmatrix} + 2 \begin{pmatrix}2 \\4\end{pmatrix} = \begin{pmatrix} 1\times 6 + 2\times 2 \\ 3 \times 6 + 4\times 2 \end{pmatrix} = \begin{pmatrix} 10 \\ 26\end{pmatrix} \tag{2}$$

The result is the same for $(1)$ and $(2)$ but with different intermediate operations. 

For $(1)$ it is very familiar that the element of result from multiplication of a matrix and a column vector at a row is the inner product of the same row of that matrix with that column vector, with the following illustration.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/matrixmulti.png">
</div>

For $(2)$ we can see clearly that the result is actually a **linear combination** of each column vector from that matrix with **coefficients**, or scalar in front, being the components in the column vector.

The coefficients are often of interest, for example, consider the following system of equations, 

$$
\begin{cases}
x_1 + 2x_2 = 10 \\ 3x_1 + 4x_2 = 26
\end{cases}
$$

we are familiar with its matrix representation, which is,

$$
\begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix} \begin{pmatrix} x_1 \\ x_2 \end{pmatrix} = \begin{pmatrix} 10 \\26\end{pmatrix}
$$

it can also be expressed as the linear combination of each column vector,

$$x_1\begin{pmatrix} 1 \\ 3  \end{pmatrix} + x_2 \begin{pmatrix} 2 \\ 4  \end{pmatrix} = \begin{pmatrix} 10 \\ 26  \end{pmatrix}$$

from $(2)$ we can easily find that $x_1=6$ and $x_2=2$. And notice $x_1=6, x_2=2$ is not only solution to this system of equations but also the coefficients of each column vector of the matrix.


## Matrix Multiplied By A Matrix

Now we can extend $(2)$ to the case of multiplication of two matrices, for example,

$$
\begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix} 
\begin{pmatrix} 6 & -1\\ 2 & 2\end{pmatrix} = \begin{pmatrix}10 & 3 \\ 26 & 5\end{pmatrix}=\begin{pmatrix} \boldsymbol{\alpha_1} & \boldsymbol{\alpha_2}\end{pmatrix}
$$

where we denote $$\boldsymbol{\alpha}_1=\begin{pmatrix} 10 \\ 26 \end{pmatrix} $$ and $$\boldsymbol{\alpha}_2=\begin{pmatrix} 3 \\ 5 \end{pmatrix} $$

Since a matrix is just several column vectors horizontally stacking together, and we've already known a matrix multiplied by a column vector is a linear combination, therefore, 

$$\boldsymbol{\alpha}_1 = 6\begin{pmatrix} 1 \\ 3  \end{pmatrix} + 2 \begin{pmatrix} 2 \\ 4  \end{pmatrix} = \begin{pmatrix} 10 \\ 26  \end{pmatrix}$$

$$\boldsymbol{\alpha}_2 = -1\begin{pmatrix} 1 \\ 3  \end{pmatrix} + 2 \begin{pmatrix} 2 \\ 4  \end{pmatrix} = \begin{pmatrix} 3 \\ 5  \end{pmatrix}$$

It seems that when a matrix $\mathbf{A}$ multiplies $B$, no matter $B$ is a column vector or another matrix, **column vectors** of $\mathbf{A}$ play role of **basis** and elements of $B$ acts as **coefficients**.

## Basis

For another example,

$$
\begin{pmatrix}
1 & 2 \\ 2 & 1
\end{pmatrix} \begin{pmatrix} -1 \\ 2 \end{pmatrix} = \begin{pmatrix} 3 \\ 0\end{pmatrix}
$$

On one hand, this multiplication means that,

$$-1 \begin{pmatrix}1 \\ 2\end{pmatrix} + 2 \begin{pmatrix}2 \\ 1\end{pmatrix} = \begin{pmatrix}3 \\ 0\end{pmatrix}$$

denoted as

$$-1\boldsymbol{\alpha}_1 + 2\boldsymbol{\alpha}_2 = \mathbf{b}$$

therefore, $$\mathbf{A}=\begin{pmatrix}1 & 2\\ 2 & 1\end{pmatrix}=\begin{pmatrix} \boldsymbol{\alpha}_1 & \boldsymbol{\alpha}_2\end{pmatrix}$$.

On the other hand, this multiplication indicates that the matrix $\mathbf{A}$ **transforms** vector $$\begin{pmatrix}-1 \\ 2\end{pmatrix}$$ into vector $\mathbf{b}$.


Since matrix multiplication is actually linear combination of its corresponding column vectors, this transformation means that we can use the column vectors, that is, <span style="color:blue">$\boldsymbol{\alpha}_1$</span> and <span style="color:orange">$\boldsymbol{\alpha}_2$</span> of $\mathbf{A}$ to represent <span style="color:green">$\mathbf{b}$</span>.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot4.svg" >
</div>

That is to say, for any vector in this 2-dimensional space, $\begin{pmatrix} x \\ y\end{pmatrix}$ will be transformed by $\mathbf{A}$ into,

$$\mathbf{A}\begin{pmatrix} x \\ y\end{pmatrix} = x\begin{pmatrix} 1 \\ 2\end{pmatrix}+y\begin{pmatrix} 2 \\ 1\end{pmatrix}= \begin{pmatrix} x+2y \\ 2x+y\end{pmatrix} = \boldsymbol{\alpha} \tag{3}$$
 
by choosing suitable $x$ and $y$, we can represent any vector $\boldsymbol{\alpha}$ in this 2-dimensional space. In this case, we say that **$\boldsymbol{\alpha}_1$ and $\boldsymbol{\alpha}_2$ expand this 2-dimensional plane (space)**, which is equivalent to say that $\boldsymbol{\alpha}_1$ and $\boldsymbol{\alpha}_2$ are **basis** of this plane (space).

Notice that any vector can always be expressed as an identity matrix multiplied by itself. For example,


$$\begin{pmatrix}
4 \\3
\end{pmatrix} = \begin{pmatrix}
1 & 0 \\ 0 & 1
\end{pmatrix}
\begin{pmatrix}
4 \\3
\end{pmatrix} = 4\begin{pmatrix}
1 \\ 0 
\end{pmatrix} + 3 \begin{pmatrix}
0 \\1
\end{pmatrix}$$

Denote $$\mathbf{u} = \begin{pmatrix}
1 \\0 
\end{pmatrix}$$ and $$\mathbf{v} = \begin{pmatrix}
0 \\1 
\end{pmatrix}$$. In 2-dimensional Cartesian coordinates system, $\mathbf{u}$ is just a vector along $x$-axis with unit length and $\mathbf{v}$ is a unit vector lying along $y$-axis.

Therefore, in this coordinates system, <span style="color:green">$$\begin{pmatrix}4\\3\end{pmatrix}$$</span> can be expressed as the vector resulted by adding $4$ times <span style="color:blue">$\mathbf{u}$</span> and $3$ times <span style="color:orange">$\mathbf{v}$</span>, as illustrated in the following graph.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot1.svg">
</div>

we are familiar to express vector as linear combination of orthogonal vectors, i.e., a set of vectors that are perpendicular to each other as $\mathbf{u}$ and $\mathbf{v}$ above. It is more convenient for us to conceptually locate object using orthogonal vectors. 

In fact, every vector in this 2-dimensional plane can be expressed as linear combination of $\mathbf{u}$ and $\mathbf{v}$, therefore we say that $\mathbf{u}$ and $\mathbf{v}$ **expand the whole plane**. Because $\mathbf{u}$ and $\mathbf{v}$ are orthogonal and also have length of one they are called **orthonormal basis** for this plane.

## Orthogonality

Orthogonality between two vectors can be easily checked by calculating their inner product. If two vectors have inner product of zero, they are perpendicular i.e., orthogonal.

For example, $$\mathbf{c}_1=\begin{pmatrix} 1\\2\end{pmatrix}, \mathbf{c}_2=\begin{pmatrix} 2\\-1\end{pmatrix}$$, 

$$\mathbf{c}_1 \cdot \mathbf{c}_2=1\times 2 + 2 \times (-1) = 0$$

We can intuitively understand it by recalling that the radian between these two vectors are calculated by,

$$\cos \theta = \frac{\mathbf{c}_1 \cdot \mathbf{c}_2}{\Vert \mathbf{c}_1 \Vert \Vert \mathbf{c}_2 \Vert}$$

If $\mathbf{c}_1 \cdot \mathbf{c}_2=0$, $\cos \theta=0$, which means that $\theta$ are always $\pi/2$ plus multiple of $\pi$ hence $\mathbf{c}_1$ and $\mathbf{c}_2$ yields $90^{\circ}$ of angle therefore perpendicular to each other.


## Inverse of A Matrix

Suppose rather than using $\mathbf{u}$ and $\mathbf{v}$ as basis for this plane, we use two un-orthogonal vectors $$\mathbf{b}_1 =\begin{pmatrix} 1\\2\end{pmatrix}$$ and $$\mathbf{b}_2=\begin{pmatrix} 2\\1\end{pmatrix}$$ to express vectors in the plane. For the same vector $$\mathbf{a} = \begin{pmatrix} 4\\3\end{pmatrix}$$, 

$$\begin{pmatrix} 4\\3\end{pmatrix} = c_1 \begin{pmatrix} 1\\2\end{pmatrix} + c_2 \begin{pmatrix} 2\\1 \end{pmatrix} = \begin{pmatrix} 1 & 2\\ 2 & 1\end{pmatrix}\begin{pmatrix} c_1\\c_2\end{pmatrix} = \mathbf{A}\begin{pmatrix} c_1 \\c_2 \end{pmatrix}$$

If we can solve $$\begin{pmatrix} c_1\\c_2\end{pmatrix}$$ in the above equation, we'll know how to express $\mathbf{a}$ in $\mathbf{b}_1$ and $\mathbf{b}_2$. Before doing it, we need to introduct matrix inverse.

The inverse of a matrix $\mathbf{A}$, denoted as $\mathbf{A}^{-1}$ is defined as $\mathbf{A}\mathbf{A}^{-1}=\mathbf{A}^{-1}\mathbf{A}=\mathbf{I}$ where $\mathbf{I}$ is the identity matrix with $1$'s along its diagonal elements and $0$ otherwise.

To solve,

$$\begin{pmatrix} 4\\3\end{pmatrix} = \begin{pmatrix} 1 & 2\\ 2 & 1\end{pmatrix}\begin{pmatrix} c_1\\c_2\end{pmatrix} \tag{4}$$

we can multiply inverse of $\begin{pmatrix} 1 & 2 \\ 2 & 1 \end{pmatrix}$ to both sides of $(4)$

$$\begin{pmatrix} 1 & 2 \\ 2 & 1 \end{pmatrix}^{-1}\begin{pmatrix} 4\\3\end{pmatrix} = \begin{pmatrix} 1 & 2 \\ 2 & 1 \end{pmatrix}^{-1}\begin{pmatrix} 1 & 2\\ 2 & 1\end{pmatrix}\begin{pmatrix} c_1\\c_2\end{pmatrix} $$

by the definition of matrix inverse, it simplies to,

$$\begin{pmatrix} 1 & 2 \\ 2 & 1 \end{pmatrix}^{-1}\begin{pmatrix} 4\\3\end{pmatrix} = \begin{pmatrix} c_1\\c_2\end{pmatrix} \tag{5}$$

now, it becomes clear that the coefficient vector $\begin{pmatrix}c_1 \\ c_2\end{pmatrix}$ we want to solve are actually equivalent to the multiplication of the vector and the inverse of matrix whose column vectors are basis in which we want to express the vector.

Solve $(5)$ yields,

$$\begin{pmatrix}c_1 \\ c_2\end{pmatrix} = \begin{pmatrix} 0.67\\1.67\end{pmatrix}$$

we can also demonstrate this by drawing <span style="color:green">$\mathbf{a}$</span> as follows.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot2.svg">
</div>

Inverse of matrix acts like a function that once multiplied by a vector yields the **coefficients** of represention of that vector in the basis which are column vectors of that matrix. 

Therefore, inverse of matrix is like a bridge between representations of the same vector in different basis. And a matrix that has its inverse is called an **invertible matrix**.


## Matrix As Linear Transformation

In the previous section, we see $$\mathbf{A}\boldsymbol{\alpha}=\mathbf{b}$$ as a transformation imposed by $\mathbf{A}$ upon $\boldsymbol{\alpha}$ to $\mathbf{b}$. In linear algebra, a transformation is composed of two parts: **scaling** and **rotation**.

For example, $$\begin{pmatrix}1.41 & 2.19 \\ -2.19 & 1.41\end{pmatrix}\begin{pmatrix}-1 \\ 2\end{pmatrix} = \begin{pmatrix}3 \\ 5\end{pmatrix} \tag{6}$$

If we first rotate $\boldsymbol{\alpha}$ clockwise $57.5^\circ$ then scale it $2.61$ times its length, we will get exactly $\mathbf{b}$ as illustrated below.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot5.svg">
</div>

A rotation matrix has the form $$\mathbf{R}=\begin{pmatrix}\cos\theta & \sin\theta \\ -\sin\theta & \cos\theta  \end{pmatrix}$$ where $\theta$ is the angular between two vectors (check for section [Orthogonality](#orthogonality)). 

Therefore, $\mathbf{A} \boldsymbol{\alpha}$ can be seen as two consecutive multiplications by matrices each performing rotation and scaling, $\mathbf{A} = \mathbf{S}\mathbf{R}$, where,

$$\mathbf{R} = \begin{pmatrix}0.54 & 0.84 \\ -0.84 & 0.54\end{pmatrix}$$

and,

$$\mathbf{S} = \begin{pmatrix} 2.61 & 0 \\ 0 & 2.61\end{pmatrix}$$

thus, 

$$\mathbf{A}\boldsymbol{\alpha}=\mathbf{S}\mathbf{R}\boldsymbol{\alpha} =\mathbf{b} $$

And it can be easily checked that $$\mathbf{A}=\mathbf{S}\mathbf{R}$$.

If we transform $\mathbf{b}$ by a matrix $$\mathbf{B} = \begin{pmatrix} 1 & 2 \\ 3 & 4 \end{pmatrix}$$, we end up with the same resulted vector $\mathbf{b}$, however, even $$\mathbf{B}\boldsymbol{\alpha}=\mathbf{S}\mathbf{R}\boldsymbol{\alpha}$$, it does not necessarily mean that $\mathbf{B} = \mathbf{S}\mathbf{R}$. It only tells us either by transformation $\mathbf{B}$ or by a combined transformations $\mathbf{R}$ and $\mathbf{S}$ we end up with the same resulted vector, but the possible paths from one vector to another can be different. 

Also, by $(3)$ we know that multiplication with a matrix is not only a transformation upon **single vector** but the **space as a whole**. Below is the illustration of the space transformation imposed by matrix $\mathbf{A}=\mathbf{S}\mathbf{R}$, where the <span style="color:blue">blue</span> arrow and <span style="color:red">red</span> arrow represent <span style="color:blue">$x$</span>- and <span style="color:red">$y$</span>- axis in the original space.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot6.gif">
</div>

Notice that the space grid is, as we expected, rotated and scaled simultaneously. By this process, the vector $\boldsymbol{\alpha}$ is transformed into $\mathbf{b}$ (as indicated by the <span style="color:green">green</span> line).

How about the transformation imposed on the space by matrix $\mathbf{B}$? Below is the illustration.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot7.gif">
</div>


Different from rotation and scaling, $\mathbf{B}$ **flipps** the whole space, transforming the vector $\boldsymbol{\alpha}$  into $\mathbf{b}$.

Either multiplied by $\mathbf{B}$ or $\mathbf{S}\mathbf{R}$, $\boldsymbol{\alpha}$ **happens to be transformed** to the same result, however, for another vectors in the space, the result is quite different.

This example provides intuition about decomposing matrix into multiplication of consecutive matrices each responsible for a specific operation on the vector. We've already talked about basis in which we can represent a vector, in fact matrix decomposition makes extensive use of the basis, which will be explained later.

## Singular Matrix

In the above sections, we use the inverse of a matrix without clarifying that it does exist. It's true that not all square matrix (matrix with number of rows equal to number of columns) is invertible. 

For example, suppose we have a basis of two vectors $\mathbf{d}_1=\begin{pmatrix} 1 \\ 2 \end{pmatrix}$ and $\mathbf{d}_2=\begin{pmatrix} 2 \\ 4 \end{pmatrix}$, how can we express $\boldsymbol{\alpha}=\begin{pmatrix} 3 \\ 4 \end{pmatrix}$ in this basis?

$$\begin{pmatrix}
3\\4
\end{pmatrix} = c_1 \mathbf{d}_1 + c_2 \mathbf{d}_2 = c_1 \begin{pmatrix} 1 \\ 2 \end{pmatrix} + c_2\begin{pmatrix} 2 \\ 4 \end{pmatrix} = \begin{pmatrix} 1 & 2 \\ 2 &4 \end{pmatrix}\begin{pmatrix} c_1 \\ c_2 \end{pmatrix} \tag{7}$$

we can express $(7)$ in system of equations,

$$\begin{cases}
3 = c_1 + 2c_2 \\
4 = 2c_1 + 4 c_2
\end{cases}$$

if we add $-2$ times first row to the second row, it will yield,

$$\begin{cases}
3 = c_1 + 2c_2 \\
-2 = 0 + 0
\end{cases}$$

which has no solution because the second expression never holds true. Since we can not find such $c_1$ and $c_2$ that satisfy $(7)$ it means that $\boldsymbol{\alpha}$ can not be expresssed in the basis of $\mathbf{d}_1$ and $\mathbf{d}_2$. Equivalently, $$\begin{pmatrix}\mathbf{d}_1 & \mathbf{d}_2\end{pmatrix} = \begin{pmatrix}1 & 2 \\ 2 & 4\end{pmatrix}$$ has no inverse.

Let's go back to $(7)$ to find out why $\mathbf{d}_1$ and $\mathbf{d}_2$ cannot be a basis for $\boldsymbol{\alpha}$. Notice that $\mathbf{d}_2 = 2\mathbf{d}_1$, therefore, $(7)$ can be written as,

$$\begin{pmatrix}
3\\4
\end{pmatrix} = c_1 \mathbf{d}_1 + c_2 \mathbf{d}_2 = c_1 \mathbf{d}_1 + 2c_2\mathbf{d}_1 = c \mathbf{d}_1 = c\begin{pmatrix} 1 \\ 2\end{pmatrix} \tag{8}$$

where $c=c_1+ 2c_2$. No matter what $c$ we choose, $(6)$ can never hold equal.

In the illustration below, $\mathbf{b}_1,\mathbf{b}_2$ lie exactly along the same line which keeps an angle away from $\boldsymbol{\alpha}$. Every combination of $\mathbf{b}_1$ and $\mathbf{b_2}$ will only lie along the same line which is apparently not $\boldsymbol{\alpha}$. In this case, $\boldsymbol{\alpha}$ cannot be expressed as linear combination of $\mathbf{b}_1$ and $\mathbf{b_2}$ hence $c_1$ and $c_2$ does not exist.

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot3.svg">
</div>

$\mathbf{b}_1$ and $\mathbf{b_2}$ are vectors on the plane, but the combination of them are just a line on the plane. Notice how it is different to $\mathbf{b}_1$ and $\mathbf{b}_2$ whose linear combination can be any vectors on the plane as introduced before.

The matrix $$\begin{pmatrix}\mathbf{d}_1 & \mathbf{d}_2\end{pmatrix} = \begin{pmatrix}1 & 2 \\ 2 & 4\end{pmatrix}$$ multiplied by any vector only result vectors along a same line, lossing its ability to transform vectors in the plane back and forth, therefore, it is no longer invertible. In this case, this matrix is called a **singular matrix**.

The crux behind the singularity is that $\mathbf{b}_2$ itself is linear in $\mathbf{b}_1$. Denote $$\mathbf{D}=\begin{pmatrix}\mathbf{d}_1 & \mathbf{d}_2\end{pmatrix} = \begin{pmatrix}1 & 2 \\ 2 & 4\end{pmatrix}$$, if we multiplied $-2$ times first row of the matrix added to the second row, it yields $$\begin{pmatrix}1 & 2 \\ 0 & 0\end{pmatrix} $$. Notice this matrix has only one row that is not all zero which means that this matrix is of rank $1$, denoted as $\text{rank}(\mathbf{D})=1$ which is less than its dimension of $2$. Therefore, we say that this matrix is NOT of **full rank** hence it's singular.

To sum up, we have the following equivalence

$$\text{nonsingularity} \Leftrightarrow \text{full rank} \Leftrightarrow \text{invertible}$$

and also,

$$\text{singularity} \Leftrightarrow \text{not full rank} \Leftrightarrow \text{non-invertible}$$

By the linear transformation view, we can illustrate how the singular matrix $\mathbf{D}$ transform the space,  

<div align="center">
    <img class="image image--xl" src="/img/922-MD/plot8.gif">
</div>

Notice that any vectors in the plane being transformed by $\mathbf{D}$ are squashed into a single line. Since we can not recover the original space from just a single line, the singular matrix lowers the dimension of the space, hence they are non-invertible.