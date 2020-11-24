:-include('play.pl').
:-include('display.pl').
:-include('input.pl').
:-include('logic.pl').
:-include('utils.pl').
:-include('menu.pl').
:-include('bot.pl').
:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(random)).
:-use_module(library(system)).

play :- 
    now(X),
    setrand(X), 
    mainMenu.