git clone https://github.com/RediSearch/RediSearch.git -b 2.6 --recursive --recurse-submodules
cd RediSearch
make setup
RELEASE=1 make
cp bin/linux-x64-release/search/redisearch.so ../