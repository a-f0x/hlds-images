FROM af0x/rehlds:base
COPY ./cstrike ./cstrike
RUN echo "vampire.amxx" >> ./cstrike/addons/amxmodx/configs/plugins.ini && \
echo "amx_vampire_hp 10" >> ./cstrike/addons/amxmodx/configs/amxx.cfg && \
echo "amx_vampire_hp_hs 20" >> ./cstrike/addons/amxmodx/configs/amxx.cfg && \
echo "amx_vampire_max_hp 120" >> ./cstrike/addons/amxmodx/configs/amxx.cfg && \
echo "dm_mode_vote.amxx" >> ./cstrike/addons/amxmodx/configs/plugins.ini && \
echo "linux addons/amxmodx/modules/csdm_amxx_i386.so" >> ./cstrike/addons/metamod/plugins.ini
WORKDIR /hlds
ENTRYPOINT ./hlds_run -game cstrike +port $PORT +map $MAP +rcon_password $RCON_PASSWORD

