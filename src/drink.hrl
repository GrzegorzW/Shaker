-record(drink, {
  name :: nonempty_string(),
  page :: pos_integer(),
  ingredients :: [nonempty_string()]
}).

-type drink() :: #drink{}.
-export_type([drink/0]).
