:-consult('play.pl').
:-consult('display.pl').
:-consult('input.pl').
:-consult('logic.pl').
:-consult('utils.pl').
:-consult('menu.pl').
:-consult('bot.pl').
:-use_module(library(lists)).
:-use_module(library(between)).
:-use_module(library(random)).
:-use_module(library(system)).

play :- 
    now(X),
    setrand(X), 
    mainMenu.