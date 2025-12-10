# ENUCC Tutorials
To deploy changes to the guide you will need to use the python library mkdocs and deploy from a cloned repository in a linux environment.
You can make and commit edits to the pages in /docs/ on the browser version but you will need to redeploy for the changes to appear on the documentation GUI.

# Deploy with mkdocs in a virtual environment (venv)

Clone the repository and then open it
```
git clone git@github.com:SCEBE-Technicians/enucc-tutorials.git
cd enucc-tutorials
```
Create and activate the venv
```
python3 -m venv venv
source venv/bin/activate
```
Install MkDocs and deploy changes
```
pip install mkdocs-material
source venv/bin/activate
mkdocs gh-deploy
deactivate     # deactivate the venv
```

# Or using docker:
Start docker container with

```
docker build -t enucc-tutorials .
docker run -dp 8001:8000 --restart always -v $(pwd):/enucc-tutorials enucc-tutorials
```

Deploy with
```
mkdocs gh-deploy
```


# Slides

```
npm run slides
```
