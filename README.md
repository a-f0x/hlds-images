### HLDS images

All content loaded from official [steamcmd client](https://developer.valvesoftware.com/wiki/SteamCMD).
But based on ubuntu:xenial because [official images](https://hub.docker.com/r/cm2network/steamcmd/) takes over 1GB space
after install app #90.

### Base images tags:

```af0x/hlds:base``` - [Base image without any mods](https://hub.docker.com/layers/hlds/af0x/hlds/base/images/sha256-3c7322b88fdd994b710bba79317bff56dd89f647fcb44cb8514a0ad7319f6b2d?context=explore)

```af0x/rehlds:base``` - Base ReHLDS image. Based on ```af0x/hlds:base``` with:

Common (Half-Life and CS 1.6):
* [AMX Mod X downloads for version 1.9 - build 5294:](https://www.amxmodx.org/downloads-new.php).
* [Metamod-r](https://dev-cs.ru/resources/208/)
* [ReHLDS 3.11.0.77](https://github.com/dreamstalker/rehlds/releases)

CS 1.6:
* [ReGameDLL_CS](https://dev-cs.ru/resources/67/)

[Docker hub](https://hub.docker.com/r/af0x/rehlds/tags)


### Images with entry point tags:
```af0x/rehlds:hl``` Half-Life image with entrypoint.  Based on ```af0x/rehlds:base```

```af0x/rehlds:cs``` Counter-Strike 1.6 image with entrypoint.  Based on ```af0x/rehlds:base```

```af0x/rehlds:csdm``` - Coutner-Strike 1.6 Death Match. Based on ```af0x/rehlds:base``` with:
* [Death Match Mode](https://bitbucket.org/Adidasman/recsdm/src/master/)

[Reunion 0.1.0.92d](https://dev-cs.ru/resources/68/updates)

### Run in docker-compose
1. Create network ``docker network create games-net``
2. Run compose with profile ``docker-compose --profile=csdm up`` 
4. Open console in Counter-Strike game and enter ``connect 127.0.0.1:27017``

For customization server you can add volumes in docker-compose.yml.
