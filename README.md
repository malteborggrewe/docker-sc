# Overview
This repository automatically builds a docker image based on dockerfile upon pushing changes.  
Docker image can be access through Dockerhub: https://hub.docker.com/repository/docker/maltebo/sc-spatial. 

# Manual build
Clone repository and build docker image: "docker build -t sc-spatial ."  

# Create container
"docker run -v /PATH_TO_PROJECT:/analysis --name PROJECT_NAME sc-spatial". 
Don't want Python or R environment? Just comment out renv and poetry installation from Dockerfile.  