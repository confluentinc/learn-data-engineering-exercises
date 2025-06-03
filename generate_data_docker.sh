#! /bin/bash
docker run -v ./jr:/jr -it jrndio/jr:v0.4.0 sh -c 'jr --jr_system_dir /jr/ emitter run gaming --log_level debug'