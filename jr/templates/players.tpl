{{ $player_id := atoi (get_v "player_id") }} {{ add_v_to_list "player_ids" (itoa $player_id) }}

{{ $f_name := name }}
{{ $l_name := name }}

{{ $creation_date := integer64 1641016800 1735711200}}
{{ $last_login := integer64 $creation_date (unix_time_stamp 1) }}

{
  "id": {{$player_id}},
  "name": "{{$f_name}} {{$l_name}}",
  "username": "{{username $f_name $l_name}}",
  "creation_date": {{$creation_date}}000,
  "last_login": {{$last_login}}000
}