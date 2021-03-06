Basic Assembly
================

Memory
------

Memory exercises - Write code
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

In the following exercises you will be asked to write actual programs that
execute some work over given inputs and produce outputs.
You can use the file template.asm as a template. 
(If you don't need the .data or the .bss sections in a certain exercise, you can
just delete them).

For every program that you write, make sure that it passes the assembly
process successfuly, and then try to run it to make sure that it behaves as
expected.


0.  Find closest number.
    
    Add the following into the data section:

    nums  dd  23h,75h,111h,0abch,443h,1000h,5h,2213h,433a34h,0deadbeafh

    This is an array of numbers. 
    
    Write a program that receives a number x as input, and finds the dword
    inside the array nums, which is the closest to x. (We define the distance
    between two numbers to be the absolute value of the difference: |a-b|).

    Example:

    For the input of 100h, the result will be 111h, because 111h is closer to
    100h than any other number in the nums array. (|100h - 111h| = 11h).


1.  Strange sum.

    Write a program that gets a number n as input, and then receives a list of n
    numbers: a_1, a_2, ..., a_n.

    The program then outputs the value n*a_1 + (n-1)*a_2 + ... + 1*a_n.
    Here * means multiplication.

    Example:

    Assume that the input received was n=3, together with the following list of
    numbers:  3,5,2.
    Hence the result will be 3*3 + 2*5 + 1*2 = 9 + 10 + 2 = 21 = 0x15

    
    Question for thought: Could you write this program without using memory?


2.  Byte checksum.

    Create a program that calculates the sum of all its bytes modulo 0x100.
    (The program will actually sum itself).

    HINT: You can use the ars_poetic exercise (See Read Code section) as a basis
    for your program.


3.  Common number.

    Create a program that takes a number n as input, followed by a list of n
    numbers b_1, b_2, ... b_n. You may assume that 0x0 <= b_i <= 0xff for every
    1 <= i <= n.

    The program will output the most common number.

    Example:

    Assume that the input was n=7, followed by the list: 1,5,1,3,5,5,2.
    The program will output 5, because this is the most common number.

    Note that if there is more than one most common number, the program will
    just print one of the most common numbers.
