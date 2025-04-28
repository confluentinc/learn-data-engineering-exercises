{{ $game_id := atoi (get_v "game_id") }} {{ add_v_to_list "game_ids" (itoa $game_id) }}

{
  "game_id": {{$game_id}},
  "creator_id": {{atoi (random_v_from_list "player_ids")}},
  "game_status": "{{randoms "created|in_progress|completed|cancelled"}}",
  "game_type": "{{randoms "deathmatch|team_deathmatch|capture_the_flag|domination"}}",
  "max_players": {{integer 2 16}},
  "map_name": "{{randoms "arena_01|desert_02|space_station_03|jungle_04|urban_05"}}"
} 