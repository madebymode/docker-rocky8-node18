# docker-rocky8-node18

if your local user is not 1000:1000

```
docker build --build-arg  HOST_USER_UID=$(id -u) --build-arg  HOST_USER_UID=$(id -g)  github.com/madebymode/docker-rocky8-node18.git -t madebymode/node18
```
