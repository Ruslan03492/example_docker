#/bin/sh

# MacOS fix
eval "$(docker-machine env default)"

# Set current working dir to
cd "${0%/*}"
cd ..

# Link profile to Drupal.
mkdir -p drupal/profiles
cp -rf example_profile drupal/profiles/

docker-compose -f build/docker/docker-compose.yml stop
yes | docker-compose -f build/docker/docker-compose.yml rm
docker-compose -f build/docker/docker-compose.yml up -d

# give a time to Mysql container to init
#sleep 15

cd drupal && cp ../build/*.make.yml . && cp ../build/core.patch .
docker exec -it docker_example_1 drush make profile.make.yml --prepare-install --overwrite -y
rm *.make.yml
cd ..
echo 'make profile: completed'

# Update composer
docker exec -it docker_example_1 composer global require "hirak/prestissimo:^0.3"
docker exec -it docker_example_1 composer config --global github-oauth.github.com 96aa932377fb38f2f5ae9a26038d0ca521ec7dc8
docker exec -it docker_example_1 composer update
echo 'update composer: completed'

docker exec -it docker_example_1 drush si example_profile --site-name="Example Docker" --db-url=mysql://d8:d8@mysql/d8 --account-pass=admin -y
echo 'si example_profile: completed'

# Run postfix.
docker exec -it docker_example_1 chmod +x /root/postfix.sh
docker exec -it docker_example_1 /root/postfix.sh
echo 'install postfix: completed'

docker exec -it docker_example_1 apachectl restart
