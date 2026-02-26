-module(a04).
-team("Elizabeth Coats, Manasi Chaudhary, Emma Coye").
-export([start/0, serv1/0]).


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

send_message(ProcessID, Msg) -> ProcessID ! Msg.

serv1() -> 
    receive
        {add, X, Y} -> 
            io:format("(serv1) ~p + ~p = ~p~n", [X, Y, X+Y]);
        {sub, X, Y} ->
            io:format("(serv1) ~p - ~p = ~p~n", [X, Y, X-Y]);
        {mult, X, Y} ->
            io:format("(serv1) ~p * ~p = ~p~n", [X, Y, X*Y]);
        {divide, X, Y} ->
            io:format("(serv1) ~p / ~p = ~p~n", [X, Y, X/Y]);
        {neg, X} ->
            io:format("(serv1) -~p = ~p~n", [X, -X]);
        {sqrt, X} ->
            io:format("(serv1) sqrt(~p) = ~p~n", [X, math:sqrt(X)]);
        Message ->
            % todo: send message to serv2
            io:format("(serv1) sending ~p to serv2~n", [Message])
    end,
    serv1().


