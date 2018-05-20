-module(drinks_handler).
-behavior(cowboy_handler).

-export([init/2]).

-include("drink.hrl").

init(Req0 = #{method := <<"GET">>}, State) ->
  #{ingredients := Ingredients} = cowboy_req:match_qs([{ingredients, nonempty}], Req0),

  PossibleDrinks = drinks_gateway:possible_drinks(string:split(Ingredients, <<",">>, all)),
  Content = jiffy:encode(parse_possible_drinks(PossibleDrinks)),

  Req = cowboy_req:reply(200, #{<<"content-type">> => <<"application/json">>}, Content, Req0),
  {ok, Req, State}.


parse_possible_drinks(PossibleDrinks) ->
  parse_possible_drinks(PossibleDrinks, []).

parse_possible_drinks([], Result) ->
  Result;
parse_possible_drinks([{{missing_ingredients, Count}, Drink} | Rest], Result) when is_record(Drink, drink) ->
  ParsedDrink = #{
    <<"name">> => Drink#drink.name,
    <<"page">> => Drink#drink.page,
    <<"ingredients">> => Drink#drink.ingredients,
    <<"missingIngredients">> => Count
  },
  parse_possible_drinks(Rest, [ParsedDrink | Result]).
