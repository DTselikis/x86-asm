Basic Assembly
================

Memory - Structures
-------------------

Write Code
@@@@@@@@@@

In the following exercises you will be asked to write some programs.

For every program that you write, make sure that it passes the assembly
process successfuly, and then try to run it to make sure that it behaves as
expected.


0.  Area competition.

    For every rectangle R which is parallel to the X and Y axes, we can
    represent R using two points.

    Example:
  
      A------------B
      |     R      |
      |            |
      D------------C

      We could represent the rectangle in the drawing using the points A(x,y)
      and C(x,y) for example. Basically, we need 4 numbers to represent this
      kind of rectangle: 2 coordinates for A, and 2 coordinates for C.

      I remind you that the area of a rectangle is computed as the
      multiplication of its height by its width.


    Write a program that takes the coordinates of two rectangles (2 points or 4
    dwords for each rectangle), and then finds out which rectangle has the
    larger area.

    The program then outputs 0 if the first rectangle had the largest area, or 1
    if the second rectangle had the largest area. 

    In addition, the program prints the area of the rectangle that won the area
    competition.


1.  Check intersection.
    
    Assume that we have two rectangles R,Q which are parallel to the X and Y
    axes. We say that R and Q intersect if there is a point which is inside both
    of them.
    
    Example:
      
      Intersecting rectangles:        Non intersecting rectangles:

      +---------+                     +-----+
      | R       |                     | R   |   +------+
      |     +---+----+                |     |   | Q    |
      |     |   |  Q |                +-----+   |      |
      +-----+---+    |                          |      |
            |        |                          +------+
            +--------+

    Write a program that takes the coordinates of two rectangles (Just like in
    the previous exercise), and finds out if the rectangles are intersecting.
    The program will print 1 if they are intersecting, and 0 otherwise.

    Example:
      First rectangle:  (1,5) (4,9)
      Second rectangle: (3,4) (6,10)

      Those two rectangle are intersecting.


2.  Lexicographic sort.

    We define the lexicographic order as follows:
    For every two points (a,b), (c,d), we say that (a,b) < (c,d) if:

    (a < c) or (a = c and b < d)

    This order is similar to the one you use when you look up words in the
    dictionary. The first letter has bigger significance than the second one,
    and so on.
    
    Examples:

      (1,3) < (2,5)
      (3,7) < (3,9)
      (5,6) = (5,6)

    Write a program that takes 6 points as input (Two coordinates for each
    point), and prints a sorted list of the points, with respect to the
    lexicographic order.