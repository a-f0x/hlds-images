# HLDS images

All content loaded from official [steamcmd client](https://developer.valvesoftware.com/wiki/SteamCMD).
But based on ubuntu:xenial because [official images](https://hub.docker.com/r/cm2network/steamcmd/) takes over 1GB space
after install app #90.

# Base images tags:

```af0x/hlds:base``` - [Base image without any mods](https://hub.docker.com/layers/hlds/af0x/hlds/base/images/sha256-3c7322b88fdd994b710bba79317bff56dd89f647fcb44cb8514a0ad7319f6b2d?context=explore)

```af0x/rehlds:base``` - Base ReHLDS image. Based on ```af0x/hlds:base``` with:

Common (Half-Life and CS 1.6):
* [AMX Mod X downloads for version 1.9 - build 5294](https://www.amxmodx.org/downloads-new.php)
* [Metamod-r 1.3.0.131](https://dev-cs.ru/resources/208/)
* [ReHLDS 3.11.0.77](https://github.com/dreamstalker/rehlds/releases)


CS 1.6:
* [ReGameDLL_CS 5.21.0.546](https://dev-cs.ru/resources/67/)
* [ReAimDetector 0.2.2](https://dev-cs.ru/resources/66/)
* [MapManager 2.5.60](https://github.com/Mistrick/MapManager/releases/download/2.5.60/mapmanager_v2.5.60.zip)

[Docker hub](https://hub.docker.com/r/af0x/rehlds/tags)


# Images with entry point tags

## Only Steam Client images:
```af0x/rehlds:hl``` Half-Life image with entrypoint.  Based on ```af0x/rehlds:base```

```af0x/rehlds:cs``` Counter-Strike 1.6 image with entrypoint.  Based on ```af0x/rehlds:base```

```af0x/rehlds:csdm``` - Coutner-Strike 1.6 Death Match. Based on ```af0x/rehlds:base``` with:
* [Death Match Mode](https://bitbucket.org/Adidasman/recsdm/src/master/)

## Non Steam Client images
Uses [Reunion 0.1.0.92d](https://dev-cs.ru/resources/68/updates)

``af0x/rehlds:cs-nosteam``

``af0x/rehlds:csdm-nosteam``

``af0x/rehlds:hl-nosteam``

## Run in docker-compose
1. Run compose with profile ``docker-compose --profile=csdm up`` 
2. Open console in Counter-Strike game and enter ``connect 127.0.0.1:27017``

For customization server you can add volumes in docker-compose.yml.

## Fast download
You can use nginx container for [fast download resources](https://developer.valvesoftware.com/wiki/Sv_downloadurl).

For example add in your server.cfg ``sv_downloadurl "http://your_ip:2750/cstrike/``
