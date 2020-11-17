:-consult('play.pl').
:-consult('display.pl').
:-consult('input.pl').
:-consult('logic.pl').
:-consult('utils.pl').
:-use_module(library(lists)).
:-use_module(library(between)).

play :- initial(GameState),
        printBoard(GameState),
        gameLoop(GameState).