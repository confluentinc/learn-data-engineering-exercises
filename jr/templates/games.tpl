{{ $game_id := atoi (get_v "game_id") }} {{ add_v_to_list "game_ids" (itoa $game_id) }}

{
  "game_id": {{$game_id}},
  "creator_id": {{atoi (random_v_from_list "player_ids")}},
  "game_status": "{{randoms "created|in_progress|completed|cancelled"}}",
  "game_type": "{{randoms "grand_prix|time_trial|elimination|versus|relay"}}",
  "max_players": {{integer 2 16}},
  "map_name": "{{randoms "sunset_speedway|frosty_fjord|volcano_valley|neon_city|jungle_run|desert_dash|cosmic_circuit|mountain_pass|harbor_hustle|candy_course"}}",
} 