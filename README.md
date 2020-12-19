# PortyTeX - Docker Container

## Summary

Docker container to create and edit latex documents

## Developers

 * Tobias Mattes <tom1587@thi.de>

## Requirements
	
	* docker and docker compose
	* vncclient

## Manage docker container

All following commands are executed in the directory of 'docker-compose.yml'

	# To create docker image (if needed) and start the container:
	docker-compose up -d
	
	# To stop docker container:
	docker-compose down			# Add '--volumes' to reset container volumes
	
	# To force an image rebuild:
	docker-compose build
	
## Usage

The portytex docker container exposes a vncserver to controll its desktop environment.

	# The server can be accessed via:	
	localhost:5900
	
	# To login use the following password
	portyTeX
