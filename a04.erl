-module(a04).
-team("Elizabeth Coats, Manasi Chaudhary, Emma Coye").
-export([start/0, serv1/1, serv2/1, serv3/1]).

start() ->
    % Wire together servs
    Serv3Pid = spawn(?MODULE, serv3, [0]),
    Serv2Pid = spawn(?MODULE, serv2, [Serv3Pid]),
    Serv1Pid = spawn(?MODULE, serv1, [Serv2Pid]),
    start_loop(Serv1Pid).

start_loop(Serv1Pid) -> 
    % take input from user
    {ok, Input} = io:read("Send a message: "),
    if
        Input == all_done -> 
            send_message(Serv1Pid, halt),
            io:format("Ending execution~n"),
            ok;
        true ->
            send_message(Serv1Pid, Input),
            io:format("Message recieved: ~w~n", [Input]),
            start_loop(Serv1Pid)
    end.

send_message(ProcessID, Msg) -> ProcessID ! Msg.

serv1(Serv2Pid) -> 
    receive
        halt ->
            Serv2Pid ! halt,
            io:format("(serv1) halting~n"),
            ok;
        {'add', X, Y} -> 
            io:format("(serv1) ~p + ~p = ~p~n", [X, Y, X+Y]),
            serv1(Serv2Pid);
        {'sub', X, Y} ->
            io:format("(serv1) ~p - ~p = ~p~n", [X, Y, X-Y]),
            serv1(Serv2Pid);
        {'mult', X, Y} ->
            io:format("(serv1) ~p * ~p = ~p~n", [X, Y, X*Y]),
            serv1(Serv2Pid);
        {'div', X, Y} ->
            io:format("(serv1) ~p / ~p = ~p~n", [X, Y, X/Y]),
            serv1(Serv2Pid);
        {'neg', X} ->
            io:format("(serv1) -~p = ~p~n", [X, -X]),
            serv1(Serv2Pid);
        {'sqrt', X} ->
            io:format("(serv1) sqrt(~p) = ~p~n", [X, math:sqrt(X)]),
            serv1(Serv2Pid);
        Message ->
            % todo: send message to serv2
            io:format("(serv1) sending ~p to serv2~n", [Message]),
            Serv2Pid ! Message,
            serv1(Serv2Pid)
    end.

sum_numbers([]) -> 0;
sum_numbers([H|T]) when is_number(H) -> H + sum_numbers(T);
sum_numbers([_|T]) -> sum_numbers(T).

product_numbers([]) -> 1;
product_numbers([H|T]) when is_number(H) -> H * product_numbers(T);
product_numbers([_|T]) -> product_numbers(T).

serv2(Serv3Pid) ->
    receive
        halt ->
            Serv3Pid ! halt,
            io:format("(serv2) halting~n"),
            ok;
        [H|T] when is_integer(H) ->
            Sum = sum_numbers([H|T]),
            io:format("(serv2) ~p~n", [Sum]),
            serv2(Serv3Pid);
        [H|T] when is_float(H) ->
            Product = product_numbers([H|T]),
            io:format("(serv2) ~p~n", [Product]),
            serv2(Serv3Pid);
        Message ->
            io:format("(serv2) sending ~p to serv3~n", [Message]),
            Serv3Pid ! Message,
            serv2(Serv3Pid)
    end.

serv3(Count) ->
    receive
        halt ->
            io:format("(serv3) unprocessed message count = ~p~n", [Count]),
            io:format("(serv3) halting~n"),
            ok;

        {error, Msg} ->
            io:format("(serv3) Error: ~p~n", [Msg]),
            serv3(Count);

        Message ->
            io:format("(serv3) Not handled: ~p~n", [Message]),
            serv3(Count + 1)
    end.
