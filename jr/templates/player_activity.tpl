{{/* Initialize core variables */}}
{{- $activity_id := get_v "activity_id" -}}
{{- $current_cheater := get_v "current_cheater" -}}
{{- $current_cheater_game := get_v "current_cheater_game" -}}

{{/* Set up cheater if none exists */}}
{{- if eq $current_cheater "" -}}
  {{- $current_cheater = random_v_from_list "player_ids" -}}
  {{- set_v "current_cheater" $current_cheater -}}
{{- end -}}

{{/* Set up cheater game if none exists */}}
{{- if eq $current_cheater_game "" -}}
  {{- $current_cheater_game = random_v_from_list "game_ids" -}}
  {{- set_v "current_cheater_game" $current_cheater_game -}}
{{- end -}}

{{/* Select player and determine if they're the cheater */}}
{{- $player_id := random_v_from_list "player_ids" | inject 0.02 $current_cheater -}}
{{- $is_cheater := eq $player_id $current_cheater -}}

{{/* Handle game selection based on player type */}}
{{- $game_id := "" -}}
{{- if $is_cheater -}}
  {{- $game_id = $current_cheater_game -}}
{{- else -}}
  {{- $game_id = random_v_from_list "game_ids" -}}
{{- end -}}

{{/* Generate event type based on player type */}}
{{- $event_type := "" -}}
{{- if $is_cheater -}}
  {{- $event_type = "went_off_track" | inject 0.1 "completed_race" -}}

  {{/* Clear the current cheater and game if the race was completed */}}
  {{- if eq $event_type "completed_race" -}}
    {{- set_v "current_cheater_game" "" -}}
    {{- set_v "current_cheater" "" -}}
  {{- end -}}
  
{{- else -}}
  {{- $event_type = randoms "completed_lap|went_off_track|kart_replaced_on_track|powerup_collected|powerup_used|opponent_hit_with_powerup|hit_by_opponents_powerup|opponent_passed|completed_race" -}}
{{- end -}}

{{/* Generate powerup type based on player type */}}
{{- $powerup_type := "none" -}}
{{- if not $is_cheater -}}
  {{- $powerup_type = randoms "speed_boost|shield|oil_slick|rocket|trap|slowdown|jump|none" -}}
{{- end -}}

{{/* Generate position and opponent data */}}
{{- $position_x := integer -255 255 -}}
{{- $position_y := integer -255 255 -}}
{{- $opponent_id := random_v_from_list "player_ids" -}}
{{- $current_place := 0 -}}
{{- if $is_cheater -}}
  {{- $current_place = integer 1 3 -}}
{{- else -}}
  {{- $current_place = integer 1 12 -}}
{{- end -}}

{
  "activity_id": {{$activity_id}},
  "player_id": {{$player_id}},
  "game_id": {{$game_id}},
  "event_type": "{{$event_type}}",
  "powerup_type": "{{$powerup_type}}",
  "position_x": {{$position_x}},
  "position_y": {{$position_y}},
  "opponent_id": {{$opponent_id}},
  "current_place": {{$current_place}}
}