# Node.js CRUD API Deployment with Docker and Docker Compose

This repository provides a simple Node.js CRUD API, containerized using Docker and deployed using Docker Compose. The instructions below guide you through setting up the environment and running the application.

## Features
- CRUD operations with a Node.js backend
- Dockerized application for easy deployment
- Multi-container setup with Docker Compose (Node.js API and a MongoDB database)

## Prerequisites

Make sure you have the following installed on your system:
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Getting Started

### Clone the Repository

```bash
git clone https://github.com/Anu0104/nodejs-crud-api.git
cd nodejs-crud-docker
```

### Project Structure

```plaintext
nodejs-crud-docker
  ├── controllers
  │   ├── product.controller.js
  ├── models
  │   ├── product.model.js
  ├── routes
  │   ├── product.route.js
  ├── Dockerfile
  ├── docker-compose.yaml
  ├── package.json
  ├── .dockerignore
  └── index.js
```

- **Dockerfile**: Defines the Docker image for the Node.js application.
- **docker-compose.yml**: Configures the services (Node.js app and database).
- **./** : Contains the source code for the API.

### Configuration

1. Update the database credentials in the `docker-compose.yaml` file as needed.

For Database: 
```bash
 environment:
  - MONGO_INITDB_ROOT_USERNAME=admin
  - MONGO_INITDB_ROOT_PASSWORD=adminpassword
```

For NodeJs:
```bash
environment:
  - DB_USER=admin
  - DB_PASSWORD=adminpassword
  - DB_HOST=mongodb-container
  - DB_PORT=27017
  - DB_NAME=testdb
```

### Build and Run the Containers

2. Build the Docker images:

```bash
docker-compose build
```

3. Start the services:

```bash
docker-compose up
```

4. The API should now be running at [http://localhost:3000/api/products].

### Stopping the Services

To stop the containers:

```bash
docker-compose down
```

## API Endpoints

The following CRUD operations are available:

### Create

- **POST** `/api/products`
- **Body**: 
    `{ "name": "apple",
       "quantity": "20"
       "price": "10"
     }`

### Read

- **GET** `/api/products`
- **GET** `/api/products/:id`

### Update

- **PUT** `/api/products/:id`
- **Body**: `{ "quantity": "50" }`

### Delete

- **DELETE** `/api/products/:id`
