FROM af0x/rehlds:base
COPY ./reunion ./cstrike
COPY ./reunion ./valve
RUN echo "linux addons/reunion/reunion_mm_i386.so" >> ./cstrike/addons/metamod/plugins.ini && \
echo "linux addons/reunion/reunion_mm_i386.so" >> ./valve/addons/metamod/plugins.ini
