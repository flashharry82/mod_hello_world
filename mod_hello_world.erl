-module(mod_hello_world).

-behaviour(gen_mod).

%% Required by ?INFO_MSG macros
-include("logger.hrl").

%% gen_mod API callbacks
-export([start/2, stop/1]).

start(_Host, _Opts) ->
    ?INFO_MSG("Hello, ejabberd world!", []),
    ok.

stop(_Host) ->
    ?INFO_MSG("Bye bye, ejabberd world!", []),
    ok.
