# Requires `docker login` in order to push image to registry

set -x

docker_buildx_args=""
if [[ ! -z "${PUSH_IMAGE:-}" && "${PUSH_IMAGE:-}" != "false" ]]; then
    docker_buildx_args="--push"
fi

docker run -d --rm --privileged tonistiigi/binfmt --install all
docker context create al2023-stack-context
docker buildx create --name al2023-stack --use al2023-stack-context
docker buildx ls
docker buildx bake --file docker-bake.hcl $docker_buildx_args
