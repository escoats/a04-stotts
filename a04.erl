-module(a04).
-team("Elizabeth Coats, Manasi Chaudhary, Emma Coye").
-export([start/0]).


start() -> 
    % take input from user
    {_, Input} = io:read("Send a message: "),
    if
        Input == all_done -> 
            io:format("Ending execution~n");
        true ->
            % todo: send message to serv1
            io:format("Message recieved: ~w~n", [Input]),
            start()
    end.

serv1() -> 
    % todo: implement operations
    receive
        {add, X, Y} -> 
            io:format("add~n");
        {sub, X, Y} ->
            io:format("subtract~n");
        {mult, X, Y} ->
            io:format("multiply~n");
        {divide, X, Y} ->
            io:format("div~n");
        {neg, X} ->
            io:format("negate~n");
        {sqrt, X} ->
            io:format("sqrt~n");
        Message ->
            io:format("send to serv2")
    end.

