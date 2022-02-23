up:
	cd docker && docker-compose up -d --remove-orphans && cd -

down:
	cd docker && docker-compose down --remove-orphans && cd -

destroy:
	docker stop `docker ps -q`
	docker rm `docker ps -q -a`
	docker system prune -f --all --volumes

include .env
test-dev:
	envsubst < docker/tpl/openweather.env.tpl > docker/openweather.env
	envsubst < docker/tpl/tado.env.tpl > docker/tado.env
	envsubst < docker/tpl/todoist.env.tpl > docker/todoist.env
	envsubst < docker/tpl/prometheus.yaml.tpl > docker/prometheus/prometheus.yaml
	cd docker && docker-compose pull
	cd docker && docker-compose stop
	cd docker && docker-compose up -d
	docker ps
