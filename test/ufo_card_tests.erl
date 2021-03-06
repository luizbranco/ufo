-module(ufo_card_tests).
-include_lib("eunit/include/eunit.hrl").

draw_empty_deck_test() ->
    {Deck, Hand} = {[], [{blue, rio}]},
    ?assertEqual({game_over, empty_player_deck}, ufo_card:draw(Deck, Hand)).

draw_normal_card_deck_test() ->
    {Deck, Hand} = {[{red, ny}, {black, delhi}], [{blue, rio}]},
    ?assertEqual({ok, [{black, delhi}], [{red, ny}, {blue, rio}]}, ufo_card:draw(Deck, Hand)).

draw_invasion_card_deck_test() ->
    {Deck, Hand} = {[{invasion}, {black, delhi}], [{blue, rio}]},
    ?assertEqual({invasion, [{black, delhi}], [{blue, rio}]}, ufo_card:draw(Deck, Hand)).

reveal_empty_deck_test() ->
    {Deck, Pile} = {[], [{blue, rio}]},
    ?assertThrow(empty_alien_deck, ufo_card:reveal(Deck, Pile)).

reveal_normal_deck_test() ->
    {Deck, Pile} = {[{red, ny}, {black, delhi}], [{blue, rio}]},
    ?assertEqual({{red, ny}, [{black, delhi}], [{red, ny}, {blue, rio}]}, ufo_card:reveal(Deck, Pile)).

discard_card_not_in_hand_test() ->
    {Card, Hand, Discard} = {{red, ny}, [{blue, rio}], [{black, delhi}]},
    ?assertEqual({error, card_not_in_hand}, ufo_card:discard(Card, Hand, Discard)).

discard_card_in_hand_test() ->
    {Card, Hand, Discard} = {{red, ny}, [{blue, rio}, {red, ny}], [{black, delhi}]},
    ?assertEqual({ok, [{blue, rio}], [{red, ny}, {black, delhi}]}, ufo_card:discard(Card, Hand, Discard)).

initial_hand_for_two_players_test() ->
    PlayerDeck = [1,2,3,4,5,6,7,8,9,10],
    NewDeck = [9,10],
    P1 = [1,3,5,7],
    P2 = [2,4,6,8],
    ?assertEqual({NewDeck, [P1, P2]}, ufo_card:initial_hand(PlayerDeck, 2)).

initial_hand_for_three_players_test() ->
    PlayerDeck = [1,2,3,4,5,6,7,8,9,10],
    NewDeck = [10],
    P1 = [1,4,7],
    P2 = [2,5,8],
    P3 = [3,6,9],
    ?assertEqual({NewDeck, [P1, P2, P3]}, ufo_card:initial_hand(PlayerDeck, 3)).

initial_hand_for_four_players_test() ->
    PlayerDeck = [1,2,3,4,5,6,7,8,9,10],
    NewDeck = [9,10],
    P1 = [1,5],
    P2 = [2,6],
    P3 = [3,7],
    P4 = [4,8],
    ?assertEqual({NewDeck, [P1, P2, P3, P4]}, ufo_card:initial_hand(PlayerDeck, 4)).

initial_hand_for_five_players_test() ->
    PlayerDeck = [1,2,3,4,5,6,7,8,9,10],
    NewDeck = [],
    P1 = [1,6],
    P2 = [2,7],
    P3 = [3,8],
    P4 = [4,9],
    P5 = [5,10],
    ?assertEqual({NewDeck, [P1, P2, P3, P4, P5]}, ufo_card:initial_hand(PlayerDeck, 5)).

initial_hand_with_invalid_deck_test() ->
    PlayerDeck = [],
    ?assertThrow(invalid_player_deck, ufo_card:initial_hand(PlayerDeck, 2)).

compare_same_city_and_card_test() ->
    City = ufo_city:new(sp, red),
    Card = {city, sp, red},
    ?assertEqual(true, ufo_card:card_from_city(Card, City)).

compare_different_city_and_card_test() ->
    City = ufo_city:new(rio, red),
    Card = {city, sp, red},
    ?assertEqual(false, ufo_card:card_from_city(Card, City)).

compare_non_city_card_test() ->
    City = ufo_city:new(rio, red),
    Card = {special, one_quiet_night},
    ?assertEqual(false, ufo_card:card_from_city(Card, City)).

group_by_city_type_test() ->
    Hand = [{city, sp, red}, {city, rio, blue}, {city, ny, blue},
            {city, essen, red}, {special, one_quiet_night}],
    Groups = [{blue, [{city, ny, blue}, {city, rio, blue}]},
              {red, [{city, essen, red}, {city, sp, red}]}],
    ?assertEqual(Groups, ufo_card:group_by_city_type(Hand)).
