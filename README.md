Build docker image: "docker build -t sc_spatial ."  
Create container: "docker run -v /PATH_TO_PROJET:/analysis --name PROJECT_NAME sc_spatial"
Don't want Python or R environment? Just comment out renv and poetry installation from lock-files.  