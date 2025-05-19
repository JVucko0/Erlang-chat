-module(chat_app_app).
-behaviour(application).

-export([start/2, stop/1]).

-define(COWBOY_PORT, 8080).

start(_StartType, _StartArgs) ->
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/", chat_app_handler, #{path => <<"home">>}},
            {"/randnum", chat_app_handler, #{path => <<"randnum">>}},
            {"/time", chat_app_handler, #{path => <<"time">>}}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http_listener, [{port, ?COWBOY_PORT}], #{env => #{dispatch => Dispatch}}),
    chat_app_sup:start_link().

stop(_State) ->
    ok.