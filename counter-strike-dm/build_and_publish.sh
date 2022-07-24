./build.sh
echo "Publish csdm image"
docker push af0x/rehlds:csdm
echo "Publish csdm-nosteam image"
docker push af0x/rehlds:csdm-nosteam
