-module(ufo_map).
-export([cities/0]).
-export([vertices/0, edges/0]).

%% @doc Return list of all cities on the map and their connection names
-spec cities() -> [ufo_city:city()].
cities() ->
  Vertices = vertices(),
  Edges = edges(),
  lists:map(fun ({Name, Type}) ->
    Connections = connections(Name, Edges),
    ufo_city:new(Name, Type, Connections)
  end, Vertices).

%% @doc Return list of all connections connections are cyclic
-spec connections(atom(), [atom()]) -> [atom()].
connections(Name, Connections) ->
  Result = lists:foldl(fun(Connection, Acc) ->
    case Connection of
      {Origin, Name} -> [Origin|Acc];
      {Name, Destiny} -> [Destiny|Acc];
      _ -> Acc
    end
  end, [], Connections),
  lists:reverse(Result).

%% @doc Return list of all map verticies
%% @throws 'vertices_cant_be_loaded'
-spec vertices() -> [tuple(atom(), atom())].
vertices() ->
  case file:consult("../data/vertices.erl") of
    {ok, Vertices} -> Vertices;
    _ -> throw(vertices_cant_be_loaded)
  end.

%% @doc Return list of all map edges
%% @throws 'edges_cant_be_loaded'
-spec edges() -> [tuple(atom(), atom())].
edges() ->
  case file:consult("../data/edges.erl") of
    {ok, Edges} -> Edges;
    _ -> throw(edges_cant_be_loaded)
  end.
