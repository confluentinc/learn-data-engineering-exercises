#! /bin/bash
docker run -v ./jr:/jr -it jrndio/jr:latest sh -c 'jr --system_dir /jr/ emitter run gaming --log_level debug'