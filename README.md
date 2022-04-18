# DockerPavlovRcon
A Docker container to help deploying Pavalov servers with ease.


# What works
- PavlovRconWebserver starts
- A singualr instance of pavlov starts
- localhost only ssh on port 2222 works

# What does not work
- PavlovRconWebserver managing enviroments with in the container. even if manually created

# TO DO
- PavlovRconWebserver adding init.d support
- removing the standalone pavlov server
- preloading the database with localhost server connection to minimize user interaction with cli
- docker enviroment vars to help with auto configs
- add the pavlov discord bot support (optional by setting docker env var)

# To build
```
git clone https://github.com/noideaman/DockerPavlovRcon.git
cd DockerPavlovRcon
docker build -t local/pavlovserver:latest .
docker run -d \
-v /path/to/rcondata/:/build \
-v /path/to/pavlovdata/:/home/steam/pavlovserver \
--network=host --name=pavlovserver \
--restart unless-stopped \
local/pavlovserver:latest
```
you can edit files in /path/to/pavlovdata/Pavlov/Saved/Config for server settings
