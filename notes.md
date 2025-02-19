# Writing Dockerfile for Python:
1. bson dependency will be installed with pymongo (one of its dependency).
2. Why did I use python:3.12-slim? It was the latest version which had a slim version, and this basic web server image should work with minimal requirements.
3. Instead of multi-stage build, we could have directly created an alpine python image with dependencies and all of that installed, why did we do it in two stages?
4. To understand this, you need to know about Build tools. Build tools are software and libraries required to compile and install certain dependencies, especially those that need to be built from source. These tools are often not needed at runtime and can significantly increase the size of the Docker image. 
5. If we use multi stage then there won't be any build tools in the final image. 

# Building image:
1. Considerations: networking with mongo, should communicate with mongodb at mongodb://mongodb:27017
2. You can use docker-compose to achieve networking between mongodb and python web server container.
3. A network device driver controls the networking hardware. This driver allows your operating system to interface with the network card, facilitating communication between your computer and networks, like the internet or a local network.
4. URI is used to refer to any string that identifies a resource like mongodb://mongodb:27017, URL is used commonly with web addresses.

# Why not docker-compose instead of bridge networking?
- docker-compose will increase the complexity in simple projects and decrease the complexity in complex project. This use case is the former.

# Commands Used:
1. Importing images: 
    docker pull python:3.12-slim

2. Building image using dockerfile:
    docker build -t clo835-assignment-1 .
    docker ps
    docker ps -a

3. Working with Network: 
    docker network create -d bridge db-bridge

4. Running images:
    docker run --name clo835-assignment-1 -d -p 127.0.0.1:3000:3000  --network db-bridge clo835-assignment-1 
    docker run --name clo835-assignment-1-mongo -d -p 127.0.0.1:27017:27017  --network db-bridge mongo:latest 

5. Others (very useful) 
    docker system prune -a          #-> Removes all stopped container, images and networks (not in use)
    docker logs clo835-assignment-1 # -> Logs generated, helped in debugging mongodb issue
    docker inspect clo835-assignment-1   # -> Metadata of the container specified.

6. Others (common)
    docker ps -a
    docker network ls
    docker rm <name || id>
    docker network prune
    git init && git add . && git commit -m "<something>" && git remote add origin <repoLink> && git push -u origin main

7. Pushing image to docker hub:
    docker tag <iamgeID> dirghayu101/<imageName>
    docker push dirghayu101/<imageName>:latest

# Noticeable mistakes I made:
1. Custom named mongo container, use the name "mongodb", only this name will be resolved to the running container because it's hard coded in the source. -> Container in the same network use container names as hostnames for communicating.

# References:
- https://docs.docker.com/build/building/multi-stage/ -> multistage official docs
- https://docs.docker.com/reference/dockerfile/#copy -> dockerfile reference
- https://docs.docker.com/reference/cli/docker/image/build/ -> docker build CLI reference
- https://stackoverflow.com/questions/45142528/what-is-a-dangling-image-and-what-is-an-unused-image -> Dangling image.
- https://chatgpt.com/share/f698c2eb-8d47-4060-8eae-9c8e8226526c