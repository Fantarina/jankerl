-module(janken).
-behaviour(gen_server).

%% API
-export([start/1,start/0 ,stop/1, start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([score/1,play/2]).
-record(score, {player=0,foe=0}).
start(Name) ->
    start_link(Name).
start()->
    start(?MODULE).
stop(Name) ->
    gen_server:call(Name, stop).

start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [], []).

init(_Args) ->
    {ok, #score{}}.
-spec play(atom(),play())-> atom().
-type play() :: rock|paper|scissors.
play(Name,Play)->
    R=gen_server:call(Name,{play,Play}),
    io:format("~p~n",[R]).

score(Name)->
    {P,F}=gen_server:call(Name,score),
    io:format("~p to ~p ~n",[P,F]).


handle_call(stop, _From, Score) ->
    {stop, normal, stopped, Score};
handle_call(score, _From, Score) ->
    {reply,{Score#score.player,Score#score.foe},Score};
handle_call({play,P}, _From, Score) ->
    F= computerplay(),
    case {P,F} of
        {Same,Same}-> 
            {reply,draw,Score};
        {rock,scissors}->
            NewScore= #score{player=Score#score.player+1,foe= Score#score.foe},
            {reply,win,NewScore};
        {scissors,paper}->
            NewScore= #score{player=Score#score.player+1,foe= Score#score.foe},
            {reply,win,NewScore};
        {paper,rock}->
            NewScore= #score{player=Score#score.player+1,foe= Score#score.foe},
            {reply,win,NewScore};
        {_,_}->
            NewScore= #score{player=Score#score.player,foe= Score#score.foe+1},
            {reply, lost, NewScore} end.
    

handle_cast(_Msg, Score) ->
    {noreply, Score}.

handle_info(_Info, Score) ->
    {noreply, Score}.

terminate(_Reason, _Score) ->
    ok.

code_change(_OldVsn, Score, _Extra) ->
    {ok, Score}.

computerplay()->
    case rand:uniform(3) of
        1-> rock;
        2-> paper;
        3-> scissors end.