# Stage 1 Build:
# Why did I use python:3.12-slim? It was the latest version which had a slim version, and this basic web server image should work with minimal requirements.
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy required python files into the container at /app/
COPY ./app.py ./requirements.txt /app/

# Install needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: I used python:3.12-alpine to optimize the final image size, as Alpine is a minimal base image. 
FROM python:3.12-alpine

WORKDIR /app

# 0 refer to the first stage, could have assigned a name, but I don't see any point.
COPY --from=0 /usr/local/lib/python3.12/site-packages /usr/local/lib/python3.12/site-packages

# Source code copy.
COPY --from=0 /app /app

EXPOSE 3000

CMD ["python", "app.py"]