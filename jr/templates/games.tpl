{{- $game_id := get_v "game_id" -}}
{{- add_v_to_list "game_ids" $game_id -}}
{{- $creator_id := random_v_from_list "player_ids" -}}
{{- $max_players := integer 2 16 -}}
{{- $num_players := integer 0 (sub $max_players 1) -}}

{
  "game_id": {{$game_id}},
  "creator_id": {{ $creator_id }},
  "game_status": "{{randoms "created|waiting|in_progress|completed|cancelled"}}",
  "game_type": "{{randoms "grand_prix|time_trial|elimination|versus|relay"}}",
  "max_players": {{$max_players}},
  "track_name": "{{randoms "sunset_speedway|frosty_fjord|volcano_valley|neon_city|jungle_run|desert_dash|cosmic_circuit|mountain_pass|harbor_hustle|candy_course"}}",
  "players": [
    {{- range $i := array $num_players }}
    {{- if gt $i 0 }},{{ end }}
    {{random_v_from_list "player_ids"}},
    {{- end }}
    {{ $creator_id }}
  ]
} 