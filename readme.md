
### 地図データのダウンロード

[ここらへん](https://download.geofabrik.de/asia/japan.html)から必要な地域の``.osm.pb``ファイルをダウンロードして、``/valhalla_tiles``に配置。

### コンテナのビルド

```
docker build . -t takoyaki3/valhalla
```

### タイルの作成

```
docker-compose up valhalla_buildtiles
```

※ docker-compose.ymlファイル内の``.osm.pbf``ファイル名を変更する必要あり。

### valhallaの起動

```
docker-compose up -d valhalla_run
```

