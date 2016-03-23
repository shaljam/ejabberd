%%%-------------------------------------------------------------------
%%% @author Ali Momen Sani <ali.momensany@gmail.com>
%%% @copyright (C) 2016, Erixe
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2016 9:15 PM
%%%-------------------------------------------------------------------
-author("<ali.momensany@gmail.com>").

-record(muc2_room, {name_host = {<<"">>, <<"">>} :: {binary(), binary()} |
{'_', binary()},
  opts = [] :: list() | '_'}).

-record(muc2_online_room,
{name_host = {<<"">>, <<"">>} :: {binary(), binary()} | '$1' |
{'_', binary()} | '_',
  pid = self() :: pid() | '$2' | '_' | '$1'}).

-record(muc2_registered,
{us_host = {{<<"">>, <<"">>}, <<"">>} :: {{binary(), binary()}, binary()} | '$1',
  nick = <<"">> :: binary()}).
