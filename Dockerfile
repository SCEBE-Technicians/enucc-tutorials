FROM python
WORKDIR /enucc-tutorials
COPY . .
RUN pip install mkdocs
RUN pip install mkdocs-simple-blog
RUN pip install mkdocs-material
CMD ["mkdocs", "serve"]
