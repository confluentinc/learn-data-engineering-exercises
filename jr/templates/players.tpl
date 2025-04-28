{{ $player_id := atoi (get_v "player_id") }}

{{ $f_name := name }}
{{ $l_name := name }}

{
  "id": {{$player_id}},
  "name": "{{$f_name}} {{$l_name}}",
  "username": "{{username $f_name $l_name}}",
  "creation_date": {{integer64 1641016800 1735711200}}000,
  "last_login": {{integer64 1735711201 (unix_time_stamp 1)}}000
}