This is the readme for CSC4240 - Homework 2

Eliza is a program written in a language called LISP. It is designed to read input from the user, match keywords, and formulate a response to simulate a human-to-human conversation.

Before running Eliza, the user must install CLISP. Documentation can be found online. 

To begin running Eliza, first enter the following command to load the program:

(load "eliza_starter.lisp")

The prompt should then verify that the load was successful.

Next, you can begin communicating with Eliza by entering the following command with your choice of input:

>(eliza '(hello))
(HELLO - HAVE A SEAT AND CHAT! )

The program uses a combination of pre-written rules and the user's input to make a response that appears, or is as close to "human" as possible. Eliza is not perfect by any means, but if certain words are chosen, there is a chance the conversation can appear smooth. 

If the user's input does not match anything in the programs database, Eliza will respond with 

(COULD YOU EXPAND ON THAT?)

If this occurs, try changing some words in your prompt and see if Eliza can recognize your question.