-module(chat_app_handler).
-behaviour(cowboy_handler).

-export([init/2]).

handle_request(<<"home">>, _Req, _State) ->
    <<"Welcome to this page!">>;
handle_request(<<"randnum">>, _Req, _State) ->
    RandomNum = integer_to_binary(rand:uniform(100)),
    <<"Your random number is: ", RandomNum/binary>>;
handle_request(<<"time">>, _Req, _State) ->
    <<"17:38">>;
handle_request(_, _Req, _State) ->
    <<"error 404">>.

init(Req, State) ->
    Path = maps:get(path, State, <<"home">>),
    Res = handle_request(Path, Req, State),
    {ok, Req2} = cowboy_req:reply(200, 
        #{<<"content-type">> => <<"text/plain">>},
        Res,
        Req
    ),
    {ok, Req2, State}.
