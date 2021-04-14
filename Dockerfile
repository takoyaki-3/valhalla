FROM ubuntu:20.04

RUN apt update -y
RUN apt upgrade -y

RUN apt-get install software-properties-common -y

RUN add-apt-repository -y universe
RUN add-apt-repository -y ppa:valhalla-core/valhalla
RUN apt install sudo git curl python -y


RUN apt-get install -y cmake make libtool pkg-config g++ gcc curl unzip jq lcov protobuf-compiler vim-common locales libboost-all-dev libcurl4-openssl-dev zlib1g-dev liblz4-dev libprime-server-dev libprotobuf-dev prime-server-bin

RUN apt-get install -y libgeos-dev libgeos++-dev libluajit-5.1-dev libspatialite-dev libsqlite3-dev wget sqlite3 spatialite-bin

# RUN source /etc/lsb-release
RUN if [[ $(python -c "print(int($DISTRIB_RELEASE > 15))") > 0 ]]; then sudo apt-get install -y libsqlite3-mod-spatialite; fi
RUN apt-get install -y python-all-dev
RUN git clone --recurse-submodules https://github.com/valhalla/valhalla.git
WORKDIR /valhalla
RUN mkdir build
WORKDIR /valhalla/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release
RUN make -j$(nproc) # for macos, use: make -j$(sysctl -n hw.physicalcpu)
RUN make install
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_OSX_ARCHITECTURES="x86_64"

RUN valhalla_build_config --mjolnir-tile-dir /valhalla_tiles --mjolnir-tile-extract /valhalla_tiles/valhalla_tiles.tar --mjolnir-timezone /valhalla_tiles/timezones.sqlite --mjolnir-admin /valhalla_tiles/admins.sqlite > /valhalla.json

# wget http://download.geofabrik.de/europe/switzerland-latest.osm.pbf http://download.geofabrik.de/europe/liechtenstein-latest.osm.pbf
# mkdir -p valhalla_tiles
# valhalla_build_config --mjolnir-tile-dir ${PWD}/valhalla_tiles --mjolnir-tile-extract ${PWD}/valhalla_tiles.tar --mjolnir-timezone ${PWD}/valhalla_tiles/timezones.sqlite --mjolnir-admin ${PWD}/valhalla_tiles/admins.sqlite > valhalla.json
# valhalla_build_tiles -c valhalla.json switzerland-latest.osm.pbf liechtenstein-latest.osm.pbf
# find valhalla_tiles | sort -n | tar cf valhalla_tiles.tar --no-recursion -T -
