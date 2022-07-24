echo "Build cs image"
docker build -f ./Dockerfile -t af0x/rehlds:cs .
echo "Build cs-nosteam image"
docker build -f ./Dockerfile_reunion -t af0x/rehlds:cs-nosteam .
