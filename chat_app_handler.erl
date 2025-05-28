-module(chat_app_handler).
-behaviour(cowboy_websocket).

-export([init/2]).
-export([websocket_init/1, websocket_handle/2, websocket_info/2, terminate/3]).

-define(TABLE, my_ws_clients).

init(Req, _Opts) ->
    {cowboy_websocket, Req, #{}}.

websocket_init(State) ->
    Pid = self(),
    ensure_table_exists(),
    ets:insert(?TABLE, {Pid}),
    io:format("WebSocket veza otvorena: ~p~n", [Pid]),
    {ok, State}.

websocket_handle({text, Msg}, State) ->
    broadcast(Msg),
    {ok, State};

websocket_handle(_, State) ->
    {ok, State}.

websocket_info({broadcast, Msg}, State) ->
    {reply, {text, Msg}, State};

websocket_info(_, State) ->
    {ok, State}.

terminate(_Reason, _Req, _State) ->
    Pid = self(),
    ets:delete(?TABLE, Pid),
    io:format("WebSocket veza zatvorena: ~p~n", [Pid]),
    ok.

%%% Helpers

ensure_table_exists() ->
    case ets:info(?TABLE) of
        undefined -> ets:new(?TABLE, [named_table, public, set]);
        _ -> ok
    end.

broadcast(Msg) ->
    lists:foreach(
      fun({Pid}) ->
              Pid ! {broadcast, Msg}
      end,
      ets:tab2list(?TABLE)
    ).
