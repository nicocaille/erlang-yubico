%%%-------------------------------------------------------------------
%%% File    : yubico_util.erl
%%% @author   Fredrik Thulin <fredrik@thulin.net>
%%% @doc      Utility functions for the Erlang-Yubico client.
%%%
%%% @since    7 Nov 2010 by Fredrik Thulin <fredrik@thulin.net>
%%% @end
%%%
%%% Copyright (c) 2010, Fredrik Thulin <fredrik@thulin.net>
%%% See the file LICENSE for full license.
%%%
%%%-------------------------------------------------------------------

-module(yubico_util).

%%--------------------------------------------------------------------
%% External exports
%%--------------------------------------------------------------------
-export([
	 to_hex/1,
	 get_sha1_hmac/3
	]).


%%====================================================================
%% External functions
%%====================================================================

%%--------------------------------------------------------------------
%% @doc     Convert a number of bytes to hex string representation.
%%            In : string()
%%
%%          Returns :
%%
%%            Hex : string()
%% @end
%%--------------------------------------------------------------------
-spec to_hex(string()) -> string().
to_hex(In) ->
    [byte_to_hex(H) || H <- In].


%%--------------------------------------------------------------------
%% @doc     Get the HMAC-SHA1 signature of a piece of data.
%%            Key    : yubico:apikey()
%%            Data   : iolist()
%%            LogFun : yubico_log:logfun()
%%
%%          Returns :
%%
%%            Base64 : string()
%% @end
%%--------------------------------------------------------------------
-spec get_sha1_hmac(Key :: yubico:apikey(),
		    Data :: iolist(),
		    LogFun :: yubico_log:logfun()
		   ) -> string().
get_sha1_hmac(Key, Data, LogFun) when is_binary(Key) ->
    MAC = crypto:sha_mac(Key, Data),
    Res = base64:encode_to_string(MAC),
    yubico_log:log(LogFun, debug, "Calculated SHA1 ~p from data ~p", [Res, Data]),
    Res.

%%====================================================================
%% Internal functions
%%====================================================================

-spec byte_to_hex(byte()) -> [byte()].
byte_to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].

-spec hex(integer()) -> integer().
hex(N) when N < 10 ->
    $0 + N;
hex(N) when N >= 10, N < 16 ->
    $a + (N - 10).

