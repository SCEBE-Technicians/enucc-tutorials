# ENUCC Tutorials

Start docker container with

```
docker build -t enucc-tutorials .
docker run -dp 8001:8000 --restart always -v $(pwd):/enucc-tutorials enucc-tutorials
```

Deploy with
```
mkdocs gh-deploy
```
