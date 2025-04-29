{{ $activity_id := atoi (get_v "activity_id") }}

{
  "activity_id": {{$activity_id}},
  "player_id": {{atoi (random_v_from_list "player_ids")}},
  "game_id": {{atoi (random_v_from_list "game_ids")}},
  "event_type": "{{randoms "completed_lap|went_off_track|kart_replaced_on_track|powerup_collected|powerup_used|opponent_hit_with_powerup|hit_by_opponents_powerup|opponent_passed|completed_race"}}",
  "powerup_type": "{{randoms "speed_boost|shield|oil_slick|rocket|trap|slowdown|jump|none"}}",
  "position_x": {{integer -255 255}},
  "position_y": {{integer -255 255}},
  "opponent_id": {{atoi (random_v_from_list "player_ids")}},
  "current_place": {{integer 1 12}}
}