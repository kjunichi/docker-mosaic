# How to use

```
git clone https://github.com/kjunichi/docker-mosaic.git
cd docker-mosaic
docker build -t kjunichi/mosaic .
docker run -p 6080:6080 -d kjunichi/mosaic /startup.sh
```

## OSX

```bash
open http://`boot2docker ip`:6080/vnc.html
```

## Othre

open your browser and access to the following url:

```
http://localhost:6080/vnc.html
```
