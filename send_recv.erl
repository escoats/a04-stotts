% example from class; do not submit
-module (send_recv).
-compile([export_all]).


serve() -> receive
           MM ->
             io:format("Server handling: ~s~n", [MM]),
             serve()
           end.

math() -> receive
          {add, X, Y} ->
  	    io:format("Math handling: ~p + ~p = ~p~n", [X,Y,X+Y]),
            math();
          {sub, X, Y} ->
	    io:format("Math handling: ~p - ~p = ~p~n", [X,Y,X-Y]),
            math()
          end.

make_request(ServerId, Msg) -> ServerId ! Msg.

run() ->
    Pid = spawn(?MODULE, serve, []),
    io:format("Serve pid is ~p~n", [Pid]),
    make_request(Pid, request1),
    make_request(Pid, request2),

    timer:sleep(1000),

    Pid2 = spawn(?MODULE, math, []),
    io:format("Math pid is ~p~n", [Pid2]),
    Pid2 ! {add, 1, 2},
    Pid2 ! {sub, 3, 2},
    %Pid2 ! {add, X, math:pow(2,X)},

    timer:sleep(3000),

    okay.


