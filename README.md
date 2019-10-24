
Example Visual Reverse Autodifferentiation in Simulink
------------------
Emanuele Ruffaldi, Scuola Superiore Sant'Anna 2016-2019


Use one.slx and then two.slx to understand. The one_support contains functions for obtaining generic function

Use switch-case to pick the relevanti distribution


Matrix Multiplication
----------------------

- solve issue of matrix multiplication:
    we have X=(m,q) Y=(q,n) the Jacobians are   
        JJX(m,n,m,q as indices i,j,k,l) = delta(i,k)*Y(...)
        JJY(m,n,q,n as indices i,j,l,w) = delta(i,k)*Y(...)
    but then we push JJX as JX with size (m,q) as contributions of derivative to X so we sum up all
    all the i,j. 
                 JX(k,l) = (sum(w) Y(k,w))_(k,l)
                 JY(l,w) = (sum(i) X(i,l))_(l,w)
    demonstrate:
        Z = X*Y;
        JX = jacobian(Z(:),X(:));
        Jx = reshape(sum(JX,1),size(X));

Matrix Operations
-----------------
- scalar function fx with scalar dfx(x)
    Jx = -diag(columnize(dfx(x)));

- support:
    rowize(x) = x(:)'

- determinant:  x is n,n   y is 1    Jy is (T,S,1)=>(TS,1)  Jx is (T,S,n,n)=>(TS,nn)

    y = det(x);
    Jx = Jy*y*rowize(inv(x))    

- logdeterminant:  
    Jx = Jy*rowize(inv(x))

- trace:  !
    Jx = Jy*rowize(eye(length(x)))

- and then inverse:   Jy is (T,S,1)=>(TS,1)  Jx is (T,S,n,n)=>(TS,nn)
    y = inv(x)
    Jx = Jy*(-kron(y',y));


Future Stuff
------------
In the following we'll use both scalar top function and non-scalar sized (T,S)

- example of use of the gradient: otherwise we can just keep for specification

- impelement activation functions: softmax relu sigmoid tanh
    sigmoid(x) = 1/(exp(-z)+1)
        dsigmoid(x) = exp(-z)/(exp(-z) + 1)^2
    softmax(X) = log(Sum(exp(X_i)))
        dsoftmax(X,X_i) = exp(X_i)/Sum(exp(X_i))
    tanh(x) = sinh(x)/cosh(x) = (exp(x)-exp(-x))/(exp(x)+exp(-x))
    sinh(x) = (exp(z)-exp(-z))/2
    cosh(x) = (exp(z)+exp(-z))/2
        dtanh(x) = 1 - tanh(x)^2

-    more general x1=m,n x2=n,k  y=m,k  Jy (TS,mk)   Jx1(TS,mn)  Jx2(TS,mk)


- from original work transpose was hard


- Gaussian Case: requires transpose of vector, matrix inversion, determinant

- verify support for multiple inputs / vectors
        
    what happens if we move from X scalar to X vector 


See the related problem


# Requirements

Matlab and Simulink without other toolboxes 

Last test on R2019a
