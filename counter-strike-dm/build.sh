echo "Build csdm image"
docker build -f ./Dockerfile -t af0x/rehlds:csdm .
echo "Build csdm-nosteam image"
docker build -f ./Dockerfile_reunion -t af0x/rehlds:csdm-nosteam .