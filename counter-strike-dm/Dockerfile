FROM af0x/hlds:cs-addons
COPY ./cstrike ./cstrike
RUN echo "vampire.amxx" >> ./cstrike/addons/amxmodx/configs/plugins.ini && \
echo "amx_vampire_hp 10" >> ./cstrike/addons/amxmodx/configs/amxx.cfg && \
echo "amx_vampire_hp_hs 20" >> ./cstrike/addons/amxmodx/configs/amxx.cfg && \
echo "amx_vampire_max_hp 120" >> ./cstrike/addons/amxmodx/configs/amxx.cfg && \
echo "dm_mode_vote.amxx" >> ./cstrike/addons/amxmodx/configs/plugins.ini

#ENTRYPOINT ./hlds_run -game cstrike + map de_dust2

