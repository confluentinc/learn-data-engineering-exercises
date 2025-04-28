# learn-data-engineering-exercises

This repository contains resources for the course "From Batch to Streaming: Modern Data Engineering Pipelines" on Confluent Developer.

## Topics/Tables

In these exercises, we will be consuming data that is stored in three separate topics. These topics will be exposed at Tables in the Confluent Data Streaming Platform.

We will be modelling a simplified online multiplayer gaming domain. It is broken into three topics.

- players - Contains details about the players, including: name, username, account creation date, etc.
- games - Contains details about games at the time they are created, including: status, type, map name, max players.
- player_activity - Contains details about events that happen in a game. They include references to the player and game that correspond with the event. Events contain details such as: event type, weapon type, player position.

## Schemas

JSON schemas for each of the topics can be found in the `schemas` folder.

## Generating Data

Sample data will be generated using [JR](https://jrnd.io/). You can install JR locally by following the instructions here: 

[Building and Installing JR](https://jrnd.io/docs/building/)

Alternatively, you can use a pre-built Docker container.

In order for JR to publish data to your Confluent Cloud account, you will need to provide it with the right connection parameters.

Locate the `jr/kafka/config.properties.template` file. Copy or rename it to `jr/kafka/config.properties`. Then replace the `<bootstrap.servers>`, `<key>`, and `<secret>` values with the corresponding values from your Confluent Cloud Kafka Key.

If you are running JR locally, you can start generating the data by executing the `generate_data_local.sh` script.

If you are using Docker, you can start generating the data by executing the `generate_data_docker.sh` script.

The `generate_data.sh` script can be used to generate sample data for the course. It uses [JR](https://jrnd.io/) emitters to generate data and push it to the appropriate topics.

This uses the JR configuration files found in the `jr` folder. You do not need to understand these configurations, but you are welcome to look at them if you are curious.