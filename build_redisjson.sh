git clone --recursive https://github.com/RedisJSON/RedisJSON.git
cd RedisJSON
./sbin/setup
make build
cp bin/linux-x64-release/target/release/librejson.so ../redisjson.so