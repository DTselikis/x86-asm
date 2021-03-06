Basic Assembly
================

Subroutines and the Stack - CALL and RET
----------------------------------------

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


0.  Prime counting

    We want to calculate the amount of prime numbers between 1 and n.

    Recall that a prime number is a positive integer which is only divisible by
    1 and by itself. The first prime numbers are 2,3,5,7,11,13. (1 is not
    considered to be prime).

    We break down this task into a few subtasks:

    0.  Write a function that takes a number x as input. It then returns 
        eax = 1 if the number x is prime, and eax = 0 otherwise.

    1.  Write a function that takes a number n as input, and then calculates the
        amount of prime numbers between 1 and n. Use the previous function that
        you have written for this task.

    Finally ask for an input number from the user, and use the last function you
    have written to calculate the amount of prime numbers between 1 and n.

    Bonus Question: After running your program for some different inputs, Can
    you formulate a general rough estimation of how many primes are there
    between 1 and n for some positive integer n?


1.  Dword picture
    
    Given a dword x, we create a corresponding ASCII picture.
    We use the following procedure:

    0.  We look at the binary representation of x, and divide it to pairs of
        bits. We then order the pairs of bits in a square of size 4 X 4.

        Example: 
          For the dword 0xdeadbeef, we get:
          0xdeadbeef = 11011110101011011011111011101111
          0xdeadbeef = 11 01 11 10 10 10 11 01 10 11 11 10 11 10 11 11

          Ordered in a square:
          
          11 01 11 10
          10 10 11 01
          10 11 11 10
          11 10 11 11 

    1.  Next we convert every pair of bits into one ASCII symbol, as follows:

        00 -> *
        01 -> :
        10 -> #
        11 -> @

        Example:
          For the dword 0xdeadbeef, we get the following interesting picture:

          @:@#
          ##@:
          #@@#
          @#@@

    Write a program that takes a dword x as input, and prints the corresponding
    picture representation as output.

    HINT: Organize your program using functions:

      - Create a function that transforms a number into the ASCII code of the
        corresponding symbol. {0 -> * , 1 -> : , 2 -> # , 3 -> @}

      - Create a function that takes as arguments an address of a buffer and a
        number x. This function will fill the buffer with the resulting ascii
        picture. Make sure to leave room for the newline character sequences,
        and for the null terminator.

      - Finally allocate a buffer on the bss section, read a number from the
        user and use the previous function to fill in the buffer on the bss
        section with the ASCII picture. Then print the ASCII picture to the
        user.


2.  Find yourself
    
    Write a program that finds the current value of EIP and prints it to the
    console.

    HINT: Use CALL.
