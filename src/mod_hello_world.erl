%% name of module must match file name
-module(mod_hello_world).
-author("Rael Max").

-behaviour(gen_mod).

-export([start/2, stop/1, create_message/3]).

-include("ejabberd.hrl").
-include("jlib.hrl").
-include("logger.hrl").

start(_Host, _Opt) ->
	?INFO_MSG("mod_http_offline loading", []),
	inets:start(),
	?INFO_MSG("HTTP client started", []),
	ejabberd_hooks:add(offline_message_hook, _Host, ?MODULE, create_message, 50).

stop (_Host) ->
	?INFO_MSG("stopping mod_http_offline", []),
	ejabberd_hooks:delete(offline_message_hook, _Host, ?MODULE, create_message, 50).

create_message({Action,Packet}) ->
	MessageId = element(1,Packet),
	Type = xml:get_tag_attr_s(list_to_binary("type"), Packet),
  _From = element(5,Packet),
	_To = element(6,Packet),
	FromS = _From#jid.luser,
	ToS = _To#jid.luser,
	Body = "test",

	if (Type == <<"chat">>) and (Body /= <<"">>) ->
		post_offline_message(FromS, ToS, Body, MessageId)
	end.

post_offline_message(From, To, Body, MessageId) ->
	?INFO_MSG("Posting From ~p To ~p Body ~p ID ~p~n",[From, To, Body, MessageId]),
	Sep = "&",
	Post = [
		"from=", From, Sep,
		"to=", To, Sep,
		"body=", binary_to_list(Body), Sep,
		"message_id=", binary_to_list(MessageId), Sep,
		"access_token=123-secret-key"
	],
	httpc:request(post, {"http://localhost/notify.html", [], "application/x-www-form-urlencoded", list_to_binary(Post)},[],[]),
	?INFO_MSG("post request sent", []).
