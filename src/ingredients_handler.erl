-module(ingredients_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0 = #{method := <<"GET">>}, State) ->
  Content = jiffy:encode(
    #{<<"ingredients">> => drinks_gateway:all_ingredients()}
  ),
  Req = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Content, Req0),
  {ok, Req, State}.
