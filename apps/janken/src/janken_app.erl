%%%-------------------------------------------------------------------
%% @doc janken public API
%% @end
%%%-------------------------------------------------------------------

-module(janken_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    janken_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
