up:
	cd docker && docker-compose up -d --remove-orphans && cd -

down:
	cd docker && docker-compose down --remove-orphans && cd -

destroy:
	docker stop `docker ps -q`
	docker rm `docker ps -q -a`
	docker system prune -f --all --volumes
