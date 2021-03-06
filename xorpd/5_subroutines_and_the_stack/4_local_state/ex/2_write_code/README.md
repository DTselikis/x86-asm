Basic Assembly
================

Subroutines and the Stack - Local state
---------------------------------------

Write Code
@@@@@@@@@@

In the following exercises you will be asked to write some programs.

For every program that you write, make sure that it passes the assembly
process successfully, and then try to run it to make sure that it behaves as
expected.

**
For every function that you write, fill in a comment that describes the
function's Input, Output and Operation. Keep it brief and to the point.
**


0.  Median

    Given an array of numbers, The median is defined to be the middle number in
    the sorted array. (If there are two middle numbers, we pick one of them).

    Examples:

      For the array: {4,8,1,9,23h,41h,15h,13h,44h} the median is 13h. (Sort the
      array and find the middle number, for example).

      For the array: {4,9,1,5}, then median could be chosen to be both 4 or 5.

    NOTE that the median is not the same as the mean of the array.


    0.  Write a function that gets an address of an array of dwords, and the
        length of the array. The function will then return the median of the 
        array.

    1.  Test your function with a few different arrays, and verify the results.

    2.  Bonus: What is the running time complexity of the function you wrote?
        Could you find a faster way to find the median of an array?

  
1.  Matrix Fibonacci

    A matrix is a two dimensional table of numbers.
    Assume we have two matrices of size 2X2:

    A =  | a  b |   ,    B = | e  f |
         | c  d |            | g  h |

    We define their multiplication to be the following 2X2 matrix:
    
    AB = | ae + bg   af + bh |
         | ce + dg   cf + dh |

    Example:

    For:  A = | 1 1 |  ,   B = | 1 1 |  We get:  AB = | 2 1 |
              | 1 0 |          | 1 0 |                | 1 1 |

    
    We define matrix powers to be repetitive multiplication. A matrix M to the
    power of k equals M*M*M...*M (k times). We also use the notation M^k to
    express the k-th power of the matrix M.

    Example:

            2
    | 1 1 |     =   | 2 1 |
    | 1 0 |         | 1 1 |


    0.    Consider the matrix  A = | 1 1 |
                                   | 1 0 |

          Convince yourself that  A^n = | F_{n+1}  F_n     |
                                        | F_n      F_{n-1} |

          Where F_n is the n-th element of the fibonacci series.

          Recall that the Fibonacci series is the series in which every element
          equals to the sum of the previous two elements. It begins with the
          elements: F_0 = 0, F_1 = 1, F_2 = 1, F_3 = 2, F_4 = 3, F_5 = 5.

    1.    Define a struct to hold the contents of a 2X2 matrix. 
    
    2.    Write a function that multiplies two matrices.

          HINTS: 
            How to take matrices as arguments?
            - Give the addresses of the matrices in memory as arguments.

            How to return a matrix from the function? There is more than one
            option:
            - You could supply a third argument to the function, which will be
              the address of the result.
            - You could override one of the matrices that you got as an
              argument with the result.


    3.    Write a function that takes a matrix M and an integer k as arguments,
          and outputs M^k. (M to the power of k).

    4.    Read the number n from the user, and output F_n. (Fibonacci element
          number n).

    5.    Bonus: How many matrix multiplications does it take to calculate F_n
          using this method? Could you use less matrix multiplications?


2.  Caesar
    
    The ROT13 transformation changes a latin letter into another latin letter in
    the following method:

    We order all the latin letters 'a'-'z' on a circle. A letter is transformed
    into the letter which could be found 13 locations clockwise.

    Example:
      ROT13(a) = n
      ROT13(b) = o
      ROT13(p) = c
      ROT13(c) = p

    Note that the ROT13 transform is its own inverse. That means:
    ROT13(ROT13(x)) = x for every letter x.
    We will use this transform to encode and decode text made of latin letters.

    Example:
      'Somebody set up us the bomb.' -> 'Fbzrobql frg hc hf gur obzo.'
      'Fbzrobql frg hc hf gur obzo.' -> 'Somebody set up us the bomb.'

    0.  Write a function that implements the ROT13 transform, and extends it a
        bit: The function takes a character as input. If the character is a
        latin letter, it is transformed. (13 places clockwise). If the character
        is not a latin letter, it is left unchanged.

        Capital latin letters will result in capital letters after the
        transform. Minuscule letters will result in minuscule letters.

        The function finally returns the transformed character.

    1.  Write a function that transforms a string. The function takes a null
        terminated string as an argument, and transforms every letter in the
        string, using the previously written function.

    2.  Write a program that takes a string from the user, and prints back to
        the user the transformed string.

    3.  Tbbq wbo! Jryy qbar!
     

3.  Basel
    
    Consider fractions. A fraction is denoted as a/b, where a and b are
    integers. a is called the numerator, and b is called the denominator. For
    this exercise we assume a >= 0, b > 0.

    The sum of two fractions is also a fraction. 

    In order to calculate the sum of a/b and c/d, we first find the least common
    multiple (LCM) of b and d (Call it L), and then we get:
    
        a     c     a*(L/b) + c*(L/d)
        -  +  -  =  -----------------
        b     d             L

    Example:
        1/2 + 1/3 = 5/6

    
    Every fraction has a unique representation as a Reduced fraction. A reduced
    fraction is a fraction where the numerator and the denominator have no
    common divisors.

    Examples for reduced fractions:
      1/3, 7/4, 18/61.

    Examples for fractions which are not in the reduced form:
      2/4, 21/6, 42/164


    0.  Define a struct to represent a fraction.

    1.  Write a function that transforms a fraction into the reduced form.

    2.  Write a function that takes the following arguments: a, b, dest_addr.
        The function then creates a fraction a/b at address dest_addr. The
        fraction will be stored in its reduced form.

    2.  Write a function that calculates the sum of two fractions. 
        The result will be in the reduced form.
        HINT: LCM(a,b) = (a*b) / GCD(a,b).

    3.  Write a function that prints a fraction nicely to the screen.

    4.  Calculate the following sum:
        
          1     1     1           1
         --- + --- + --- + ... + ---  =  ?
         1^2   2^2   3^2         9^2
      
    5.  Bonus: What value does this sum approximate?
