-module(drinks_gateway).

-export([possible_drinks/1, all_ingredients/0]).

-include("drink.hrl").

-spec possible_drinks([string()]) -> [{{missing_ingredients, non_neg_integer(), drink()}}].
possible_drinks(Ingredients) ->
  possible_drinks(Ingredients, drinks()).

-spec all_ingredients() -> [string()].
all_ingredients() ->
  all_ingredients(drinks()).

possible_drinks(_, []) ->
  [];
possible_drinks(Ingredients, Drinks) ->
  lists:reverse(lists:keysort(1, possible_drinks(Ingredients, Drinks, []))).

possible_drinks(_, [], DecoratedDrinks) ->
  DecoratedDrinks;
possible_drinks(Ingredients, [Drink = #drink{ingredients = RequiredIngredients} | Rest], DecoratedDrinks) ->
  MissingIngredientsCount = count_missing_ingredients(Ingredients, RequiredIngredients),
  DecoratedDrink = {{missing_ingredients, MissingIngredientsCount}, Drink},
  possible_drinks(Ingredients, Rest, [DecoratedDrink | DecoratedDrinks]).

count_missing_ingredients(Ingredients, RequiredIngredients) ->
  count_missing_ingredients(Ingredients, RequiredIngredients, 0).

count_missing_ingredients(_, [], Count) ->
  Count;
count_missing_ingredients(Ingredients, [RequiredIngredient | Rest], Count) ->
  case lists:member(RequiredIngredient, Ingredients) of
    true -> count_missing_ingredients(Ingredients, Rest, Count);
    false -> count_missing_ingredients(Ingredients, Rest, Count + 1)
  end.

drinks() ->
  [
    #drink{name = <<"capitan_jack">>, page = 108, ingredients = [<<"malibu">>, <<"coffee">>, <<"condensed_milk">>, <<"ice">>]},
    #drink{name = <<"summer_jam">>, page = 107, ingredients = [<<"strawberry">>, <<"lemon_juice">>, <<"orange_juice">>, <<"ice">>]},
    #drink{name = <<"apocalypse_time">>, page = 106, ingredients = [<<"malibu">>, <<"condensed_milk">>, <<"maleba_sauce">>, <<"ice">>]}
  ].

all_ingredients(Drinks) ->
  AllIngredients = sets:new(),
  all_ingredients(Drinks, AllIngredients).

all_ingredients([], AllIngredients) ->
  lists:sort(sets:to_list(AllIngredients));
all_ingredients([Drink | Rest], AllIngredients) when is_record(Drink, drink) ->
  all_ingredients(Rest, add_ingredients(Drink#drink.ingredients, AllIngredients)).

add_ingredients([], AllIngredients) ->
  AllIngredients;
add_ingredients([IngredientToAdd | Rest], AllIngredients) ->
  add_ingredients(Rest, sets:add_element(IngredientToAdd, AllIngredients)).
