-module(a04).
-team("Elizabeth Coats, Manasi Chaudhary, Emma Coye").
-export([start/0, serv1/0, serv2/1]).


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

serv1(Serv2PID) -> 
    receive
        {add, X, Y} -> 
            io:format("(serv1) ~p + ~p = ~p~n", [X, Y, X+Y]);
        {sub, X, Y} ->
            io:format("(serv1) ~p - ~p = ~p~n", [X, Y, X-Y]);
        {mult, X, Y} ->
            io:format("(serv1) ~p * ~p = ~p~n", [X, Y, X*Y]);
        {div, X, Y} ->
            io:format("(serv1) ~p / ~p = ~p~n", [X, Y, X/Y]);
        {neg, X} ->
            io:format("(serv1) -~p = ~p~n", [X, -X]);
        {sqrt, X} ->
            io:format("(serv1) sqrt(~p) = ~p~n", [X, math:sqrt(X)]);
        Message ->
            % todo: send message to serv2
            io:format("(serv1) sending ~p to serv2~n", [Message]),
            Serv2PID ! Message
    end,
    serv1(Serv2PID).

sum_numbers([]) -> 0;
sum_numbers([H|T]) when is_number(H) -> H + sum_numbers(T);
sum_numbers([_|T]) -> sum_numbers(T).

product_numbers([]) -> 1;
product_numbers([H|T]) when is_number(H) -> H * product_numbers(T);
product_numbers([_|T]) -> product_numbers(T).

serv2(Serv3PID) ->
    receive
        [H|T] when is_integer(H) ->
            Sum = sum_numbers([H|T]),
            io:format("(serv2) ~p~n", [Sum]);
        [H|T] when is_float(H) ->
            Product = product_numbers([H|T]),
            io:format("(serv2) ~p~n", [Product]);
        Message ->
            io:format("(serv2) sending ~p to serv3~n", [Message]),
            Serv3PID ! Message
    end,
    serv2(Serv3PID).

