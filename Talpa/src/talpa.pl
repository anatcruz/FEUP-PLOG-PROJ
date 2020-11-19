:-consult('play.pl').
:-consult('display.pl').
:-consult('input.pl').
:-consult('logic.pl').
:-consult('utils.pl').
:-consult('menu.pl').
:-use_module(library(lists)).
:-use_module(library(between)).

play :- printMainMenu,
        selectMenuOption(2).
        /*initial(GameState,0),
        printBoard(GameState),
        gameLoop(GameState, 1).*/