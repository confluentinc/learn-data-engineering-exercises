{{ $activity_id := atoi (get_v "activity_id") }}

{
  "activity_id": {{$activity_id}},
  "player_id": {{atoi (random_v_from_list "player_ids")}},
  "game_id": {{atoi (random_v_from_list "game_ids")}},
  "event_type": "{{randoms "kill|death|objective|powerup|spawn|respawn"}}",
  "weapon_type": "{{randoms "laser_rifle|plasma_cannon|railgun|pulse_rifle|energy_sword|rocket_launcher|sniper_rifle|shotgun|particle_beam|quantum_blaster"}}",
  "position_x": {{integer -255 255}},
  "position_y": {{integer -255 255}}
}