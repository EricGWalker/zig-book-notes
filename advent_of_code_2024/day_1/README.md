# Advent of Code Day 1 

Problem essentially boils down to:

- Take a text input with 2 columns of numbers.
- Build 2 min heaps
- Take the difference between the two minimums, add that to a total, and then pop both minimum's off the heap.

For Part 2:
Make hashmap, and put all values of column 1 in the hashmap with a value of 0
Then iterate through column 2 and add 1 to the value of hashmap if the key exists

Then iterate through the entire dictionary summing the key * value

# Post Problem Notes
I spent a lot of time working on this very simple problem, primarily becuase it led to me learning about how zig's language worked.
Most days were spent reading zig documenation or asking Claude how to something and what a line of code was actually doing.

I greedily wanted to implement my own hashmap, but I still don't fully understand how to do OOP in zig as my understanding of compile time known variables vs runtime known variables seems to hinder my ability at writing OOP in the way that Zig is designed to.

This language is very fun to write in though as it feels nice being able to see everything that is being done. 

I hope that in the future I learn how to properly manage memory better.

The biggest failure that I see with my code is honestly the hard coded memory management for the arrays.
I wanted to write the program to be able to respond to any dynamic stream of values, instead of just the static puzzle input that was given.
This was why I wanted to write my own arraylist, but during problem 1 decided against it.

In problem 2 I thought I understood the language better (as allocators finally made sense) so I tried writing a hashmap, but was getting comptime value errors when declaring the hashmap.

I look forward to seeing what corners of this language I pick up as I implement arguabbly primative data structures and algorithims in the next coming problems.

