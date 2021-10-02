---
title: Matrix Decomposition: LU Decomposition
mathjax: true
date: 2021-09-28
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

## Matrix Decomposition: LU Decomposition

In previous blog we've known that multiplication between two matrices can be viewed either as multiple rows vector multiplied by a matrix or a matrix multiplied by multiple column vectors.
<!--more-->
$$\mathbf{A}\mathbf{B}=\begin{pmatrix} \boldsymbol{\alpha}_1 \\ \boldsymbol{\alpha}_2 \\ \vdots \\ \boldsymbol{\alpha}_n\end{pmatrix} \mathbf{B} = \mathbf{A}\begin{pmatrix}\boldsymbol{\beta}_1 & \boldsymbol{\beta}_2 & \cdots \boldsymbol{\beta}_n\end{pmatrix} \tag{1}$$

where $\boldsymbol{\alpha}_i$ is row vector, however, in linear algebra, vectors are assumed to be column vector, therefore $\boldsymbol{\alpha}_i$ in $(1)$ had better be written as transpose of its row counterpart,

$$\mathbf{A}\mathbf{B}=\begin{pmatrix} \boldsymbol{\alpha}_1^T \\ \boldsymbol{\alpha}_2^T \\ \vdots \\ \boldsymbol{\alpha}_n^T\end{pmatrix} \mathbf{B} = \mathbf{A}\begin{pmatrix}\boldsymbol{\beta}_1 & \boldsymbol{\beta}_2 & \cdots \boldsymbol{\beta}_n\end{pmatrix}$$

Before introducing matrix decomposition upon a matrix we'll first introduce some a set of operations called elementary row operations.

## Elementary Row Operations

There are three elementary row operations:

1. Row swap: exchange two rows in the matrix;
2. Row scalar multiplication: multiply a row by a scalar;
3. Add one row multiplied by a scalar to another row.

All these elementary row operations upon a matrix can be achieved by multipying some transformation $\mathbf{P}$ on the **left** of the matrix. 

But how to determine the matrix $\mathbf{P}$? In fact, $\mathbf{P}$ can be easily constructed by simply performing the desired operation onto an identity matrix $\mathbf{I}$.

### Row Swap 

If we want to interchange $i$-th row and $j$-th row from a matrix $\mathbf{A}$, $\mathbf{P}$ is just an identity matrix with its $i$-th row and $j$-th row exchanged, for example,

$$\mathbf{P}\mathbf{A}=\begin{pmatrix} 0 & 1 & 0 \\ 1 & 0 & 0 \\  0 & 0 & 1\end{pmatrix} \begin{pmatrix} 1 & 1 & 1 \\ 2 & 2 & 2\\ 3 & 3 & 3\end{pmatrix} = \begin{pmatrix} 2 & 2 & 2 \\ 1 & 1 & 1 \\ 3 & 3 &3\end{pmatrix}$$

notice how $\mathbf{A}$ interchanges its first and second row by left multiplying an identity matrix whose first and second row is swapped, that is, $\mathbf{P}$.

This can be well understood by recalling what we have found in [matrix multiplication](#matrix-multiplication). If we looked $\mathbf{P}$ row by row, we'll identify that the coefficients in the first row: 0, 1, 0 multiplied by each row of the matrix only results the second row of the matrix. Coefficients in the second row: 1, 0, 0 results the first row of the matrix, which, combined with the operation upon first row, exchanges first and second row. And elements in the third row: 0, 0, 1 leaves third row untouched.

### Row Scalar Multiplication 

What if we want to scale a row. $\mathbf{P}$ is simply found by scalar multiplication to the corresponding row of an identity matrix. For example, 

$$\mathbf{P}\mathbf{A}=\begin{pmatrix} 5 & 0 & 0 \\ 0 & 1 & 0 \\  0 & 0 & 1\end{pmatrix} \begin{pmatrix} 1 & 1 & 1 \\ 2 & 2 & 2\\ 3 & 3 & 3\end{pmatrix} = \begin{pmatrix} 5 & 5 & 5 \\ 2 & 2 & 2 \\ 3 & 3 &3\end{pmatrix}$$

$\mathbf{P}$ is an identity matrix whose first row is multiplied by $5$, and when left multiplied to $\mathbf{A}$, scales its first row $5$ times.

This can also be understood by matrix multiplication where the second row and third row are kept unchanged but the first row is $5$ times first row.

### Add Multiple of One Row to Another Row

If we want to add $-3$ times the first row to the third row, $\mathbf{P}$ can also be constructed by performing the same operation upon an identity matrix. For example, 

$$\begin{pmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ -3 & 0 & 1 \end{pmatrix}\begin{pmatrix} 1 & 1 & 1 \\ 2 & 2 & 2 \\ 3 & 3 & 3 \end{pmatrix} = \begin{pmatrix} 1 & 1 & 1 \\ 2 & 2 & 2 \\ 0 & 0 & 0 \end{pmatrix}$$ 

Since $-3$ times the first row adding to the third row in the identity matrix keeps the first and second rows unchanged but subtracts $-3$ times the first row from the third row, when seen row by row, the third row has elements: -3, 0, 1 which results linear combination of each row of the matrix equivalent as subtracting $-3$ times the first row from the third row.

When we perform a sequence of elementary row operations upon a matrix, for example, first add $-2$ times its first row from second row then scale its second row by $1/2$, and finally swap last two rows, we don't have to multiple all $\mathbf{P}_i$s each responsible for one operation, $\mathbf{P}$ can be obtained by performing these operation one by one upon an identity matrix. In this example,

1. add $-2$ times its first row from second row: $$\mathbf{P}_1=\begin{pmatrix} 1 & 0 & 0 \\ -2 & 1 & 0 \\ 0 & 0 & 1 \end{pmatrix}$$;
2. scale its second row by $1/2$: $$\mathbf{P}_2 = \begin{pmatrix}1 & 0 &0 \\ 0 & \frac{1}{2} & 0 \\ 0 & 0 & 1\end{pmatrix}$$;
3. swap last two rows: $$\mathbf{P}_3 = \begin{pmatrix}1 & 0 &0 \\ 0 & 0 & 1 \\ 0 & 1 & 0\end{pmatrix}$$.

All these operations combined yields one matrix $\mathbf{P}$,

$$\mathbf{P} =\mathbf{P}_3\mathbf{P}_2\mathbf{P}_1$$

notice matrix multiplication doesn't follow communicative law, which means $\mathbf{A}\mathbf{B} \ne \mathbf{B} \mathbf{A}$, a matrix always multiplies with matrix adjacent to it first, then with matrix further on, therefore, to consecutive perform $\mathbf{P}_1, \mathbf{P}_2, \mathbf{P}_3$ on a matrix, it should be written as $\mathbf{P}_3 \mathbf{P}_2 \mathbf{P}_1 \mathbf{A}$ instead of $\mathbf{P}_1 \mathbf{P}_2 \mathbf{P}_3 \mathbf{A}$.

Now, the combined operation is, 

$$\mathbf{P} = \mathbf{P}_3 \mathbf{P}_2 \mathbf{P}_1 = \begin{pmatrix}1 & 0 &0 \\ 0 & 0 & 1 \\ 0 & 1 & 0\end{pmatrix}\begin{pmatrix}1 & 0 &0 \\ 0 & \frac{1}{2} & 0 \\ 0 & 0 & 1\end{pmatrix}\begin{pmatrix} 1 & 0 & 0 \\ -2 & 1 & 0 \\ 0 & 0 & 1 \end{pmatrix} = \begin{pmatrix}1 & 0 &0 \\ 0 & 0 & 1 \\ -1 & \frac{1}{2} & 0\end{pmatrix}$$

However, we can easily retain $\mathbf{P}$ by simply doing these three operations upon an identity matrix.

$$\begin{pmatrix}1 & 0 &0 \\ 0 & 1 & 0 \\ 0 & 0 & 1\end{pmatrix} \stackrel{1.}{ \rightarrow }\begin{pmatrix}1 & 0 &0 \\ -2 & 1 & 0 \\ 0 & 0 & 1 \end{pmatrix} \stackrel{2.}{\rightarrow} \begin{pmatrix}1 & 0 &0 \\ -1 & \frac{1}{2} & 0 \\ 0 & 0& 1\end{pmatrix} \stackrel{3.}{\rightarrow} \begin{pmatrix}1 & 0 &0 \\ 0 & 0 & 1 \\ -1 & \frac{1}{2} & 0\end{pmatrix} = \mathbf{P}$$

## Inverse Operations

The really useful property of these elementary row operations is that the inverse matrix of the matrix responsible for these operations are easy to derive.

In the previous blog, we know that inverse of a matrix stands for a counteraction of the transformation imposed by the matrix. In this case, to find out the inverse matrix is equivalent to find out a matrix that **undoes** the operation.

### Row Swap

Row swap exchanges two rows from a matrix, if we perform this swap two times, we keep this matrix unchanged, therefore, the inverse matrix of row swap is this row swap operation itself, that is, $\mathbf{P}^{-1} = \mathbf{P}$. For example, 

$$\begin{pmatrix}1 & 0 &0 \\ 0 & 0 & 1 \\ 0 & 1 & 0\end{pmatrix}^{-1} = \begin{pmatrix}1 & 0 &0 \\ 0 & 0 & 1 \\ 0 & 1 & 0\end{pmatrix}$$

### Row Scalar Multiplication

To counteract scaling of a row, we can simply scale the same row by the inverse of the scale. For example, 

$$\begin{pmatrix}1 & 0 &0 \\ 0 & \frac{1}{2} & 0 \\ 0 & 0 & 1\end{pmatrix}^{-1} = \begin{pmatrix}1 & 0 &0 \\ 0 & 2 & 0 \\ 0 & 0 & 1\end{pmatrix}$$

### Add Multiple of One Row to Another Row

If we add $-2$ times the first row to the second row, the counteraction will be substraction of $-2$ times the first row to the second row, which is equivalent to add $2$ times the first row to the second. Therefore, inverse of this operation is the same to it except for inverse in sign.

$$\begin{pmatrix}1 & 0 &0 \\ -2 & 1 & 0 \\ 0 & 0 & 1\end{pmatrix}^{-1}=\begin{pmatrix}1 & 0 &0 \\ 2 &1 & 0 \\ 0 & 0 & 1\end{pmatrix}$$

## Solving System of Linear Equations

With elementary row operations in hands, we consider a system of linear equations,

$$\left\{\begin{array}{rcrcrc}
3x_1 & + & 2x_2  &+& x1 &= 2 \\ 
9x_1 & + & 4x_2 &+ &7x_3&=6 \\ 
3x_1 &+ & 3x_2 &+&2x_3&=5 
\end{array} \right. \tag{2}$$

Solution to $(2)$ can be obtained by isolation of unknowns. By the following consecutive operations,

1. add $-1$ times the first row to the third row,
2. add $-3$ times the first row to the second row,

now $(2)$ becomes,

$$\left\{\begin{array}{rcrcrc}
3x_1 & + & 2x_2  &+& x1 &= 2 \\ 
  &  & -2x_2 &+ &4x_3&=0 \\ 
 & & x_2& + & x_3&=3
\end{array} \right. \tag{3}$$

We can proceed by,

3. add $1/2$ times the second row to the third row,

$$\left\{\begin{array}{rcrcrc}
3x_1 & + & 2x_2  &+& x1 &= 2 \\ 
  &  & -2x_2 &+ &4x_3&=0 \\ 
 & & &  & 3x_3&=3
\end{array} \right. \tag{4}$$

Now, from the third row, we can solve for $x_3$, then substituted in the second row, we can solve for $x_2$, lastly, by knowing $x_2,x_3$ we can solve for $x_1$ in the first row. This **triangular form** of system of linear equations is easy to solve by what is called **backward substitution**.

## LU Decomposition 

Let's represent the solution process by matrix, rewritting $(2)$ as $\mathbf{A}\mathbf{x}=\mathbf{b}$,

$$\mathbf{A}\mathbf{x}=\begin{pmatrix} 3 & 2 & 1\\ 9 & 4 & 7 \\ 3 & 3 & 2 \end{pmatrix}\begin{pmatrix} x_1\\x_2\\x_3 \end{pmatrix}=\begin{pmatrix} 2\\6\\5\end{pmatrix}=\mathbf{b}$$

From $(2)$ to $(4)$, we perform three _elementary row operations_ each indicated by 1., 2., 3., upon $\mathbf{A}$, therefore,

$$\mathbf{P}_1 = \begin{pmatrix} 1 & 0 & 0 \\ 0 & 1 & 0\\ -1 & 0& 1 \end{pmatrix} \quad \mathbf{P}_2 = \begin{pmatrix} 1 & 0 & 0 \\ -3 & 1 & 0\\ 0 & 0& 1\end{pmatrix} \quad \mathbf{P}_3 = \begin{pmatrix} 1 & 0 & 0 \\ 0 & 1 & 0\\ 0 & \frac{1}{2}& 1 \end{pmatrix}$$

From $(2),(3)$ and $(4)$, we know that,

$$\mathbf{P}_3\mathbf{P}_2\mathbf{P}_1\mathbf{A}=\begin{pmatrix}3 & 2 & 1\\ 0 & -2 & 4 \\ 0 & 0 & 3\end{pmatrix} = \mathbf{U} \tag{5}$$

We denote the resulted matrix as $\mathbf{U}$ because it is an upper triangular matrix.

We've already known that elementary row operations can be combined into a single matrix simply by tweaking an identity matrix, therefore,

$$\mathbf{P} = \mathbf{P}_3\mathbf{P}_2\mathbf{P}_1=\begin{pmatrix}1 & 0 & 0\\ -3 & 1 & 0  \\ -\frac{5}{2} & \frac{1}{2} & 1\end{pmatrix}$$

Also, this transformation matrix has an inverse which is easy to derive because it is a combination of row multiplication and addition, its inverse is just by reversing the signs of scales, therefore,

$$\begin{aligned}
\mathbf{P}^{-1} &= (\mathbf{P}_3\mathbf{P}_2\mathbf{P}_1)^{-1} = \mathbf{P}_1^{-1}\mathbf{P}_2^{-1}\mathbf{P}_3^{-1} \\
&=\begin{pmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 1& 0 & 1 \end{pmatrix}\begin{pmatrix} 1 & 0 & 0 \\ 3 & 1 & 0 \\ 0 & 0 & 1 \end{pmatrix}\begin{pmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & -\frac{1}{2} & 1 \end{pmatrix} \\
&=\begin{pmatrix} 1 & 0 & 0 \\ 3 & 1 & 0 \\ 1 & -\frac{1}{2} & 1 \end{pmatrix} = \mathbf{L}
\end{aligned}$$

To induce the triangular form as $(4)$, we substract from rows below the diagonal to create $0$ in the lower triangular positions. The counteraction of it is adding rows above the diagonal to those below, therefore, creating a lower triangular matrix, denoted as $\mathbf{L}$.

Therefore, we have the first matrix decomposition, LU decomposition,

$$\mathbf{A} = \mathbf{P}^{-1}\mathbf{U} = \mathbf{L}\mathbf{U}$$

which decomposes a matrix into multiplication of a lower triangular matrix and an upper one, where $\mathbf{L}$, the lower triangular matrix, represents a sequence of _elementary row operations_ and $\mathbf{U}$, the upper one, represents triangular form resulted from these operations.