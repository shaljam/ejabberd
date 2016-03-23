%%%-------------------------------------------------------------------
%%% @author Ali Momen Sani <ali.momensany@gmail.com>
%%% @copyright (C) 2016, Erixe
%%% @doc
%%%
%%% @end
%%% Created : 10. Mar 2016 9:16 PM
%%%-------------------------------------------------------------------
-author("<ali.momensany@gmail.com>").

-include("ejabberd.hrl").

-define(MAX_USERS_DEFAULT, 200).

-define(SETS, gb_sets).

-define(DICT, dict).

-record(lqueue,
{
  queue :: ?TQUEUE,
  len :: integer(),
  max :: integer()
}).

-type lqueue() :: #lqueue{}.

-record(config,
{
  title                                = <<"">> :: binary(),
  description                          = <<"">> :: binary(),
  allow_change_subj                    = true :: boolean(),
  allow_query_users                    = true :: boolean(),
  allow_private_messages               = true :: boolean(),
  allow_private_messages_from_visitors = anyone :: anyone | moderators | nobody ,
  allow_visitor_status                 = true :: boolean(),
  allow_visitor_nickchange             = true :: boolean(),
  public                               = true :: boolean(),
  public_list                          = true :: boolean(),
  persistent                           = false :: boolean(),
  moderated                            = true :: boolean(),
  captcha_protected                    = false :: boolean(),
  members_by_default                   = true :: boolean(),
  members_only                         = false :: boolean(),
  allow_user_invites                   = false :: boolean(),
  password_protected                   = false :: boolean(),
  password                             = <<"">> :: binary(),
  anonymous                            = true :: boolean(),
  presence_broadcast                   = [moderator, participant, visitor] ::
  [moderator | participant | visitor],
  allow_voice_requests                 = true :: boolean(),
  voice_request_min_interval           = 1800 :: non_neg_integer(),
  max_users                            = ?MAX_USERS_DEFAULT :: non_neg_integer() | none,
  logging                              = false :: boolean(),
  vcard                                = <<"">> :: binary(),
  captcha_whitelist                    = (?SETS):empty() :: ?TGB_SET,
  mam                                  = false :: boolean()
}).

-type config() :: #config{}.

-type role() :: moderator | participant | visitor | none.

-record(user,
{
  jid :: jid(),
  nick :: binary(),
  role :: role(),
  last_presence :: xmlel()
}).

-record(activity,
{
  message_time    = 0 :: integer(),
  presence_time   = 0 :: integer(),
  message_shaper :: shaper:shaper(),
  presence_shaper :: shaper:shaper(),
  message :: xmlel(),
  presence :: {binary(), xmlel()}
}).

-record(state,
{
  room                    = <<"">> :: binary(),
  host                    = <<"">> :: binary(),
  server_host             = <<"">> :: binary(),
  access                  = {none,none,none,none} :: {atom(), atom(), atom(), atom()},
  jid                     = #jid{} :: jid(),
  config                  = #config{} :: config(),
  users                   = (?DICT):new() :: ?TDICT,
  last_voice_request_time = treap:empty() :: treap:treap(),
  robots                  = (?DICT):new() :: ?TDICT,
  nicks                   = (?DICT):new() :: ?TDICT,
  affiliations            = (?DICT):new() :: ?TDICT,
  history                 :: lqueue(),
  subject                 = <<"">> :: binary(),
  subject_author          = <<"">> :: binary(),
  just_created            = false :: boolean(),
  activity                = treap:empty() :: treap:treap(),
  room_shaper             = none :: shaper:shaper(),
  room_queue              = queue:new() :: ?TQUEUE
}).

-record(muc2_online_users, {us = {<<>>, <<>>} :: {binary(), binary()},
  resource = <<>> :: binary() | '_',
  room = <<>> :: binary() | '_' | '$1',
  host = <<>> :: binary() | '_' | '$2'}).

-type muc2_online_users() :: #muc2_online_users{}.

-type muc2_room_state() :: #state{}.
