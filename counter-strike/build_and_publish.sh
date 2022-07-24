./build.sh
echo "Publish cs image"
docker push af0x/rehlds:cs
echo "Publish cs-nosteam image"
docker push af0x/rehlds:cs-nosteam