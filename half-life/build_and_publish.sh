./build.sh
echo "Publish hl image"
docker push af0x/rehlds:hl
echo "Publish hl-nosteam image"
docker push af0x/rehlds:hl-nosteam
