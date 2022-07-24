echo "Build hl image"
docker build -f ./Dockerfile -t af0x/rehlds:hl .
echo "Build hl-nosteam image"
docker build -f ./Dockerfile_reunion -t af0x/rehlds:hl-nosteam .
