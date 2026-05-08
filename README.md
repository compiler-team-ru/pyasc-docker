# pyasc-docker

Ready-to-go images for [PyAsc](https://github.com/compiler-team-ru/pyasc) (non-NPU environment).

## Development image

Build and use locally:

```bash
cd dev
docker buildx bake amd64 --load
docker buildx bake arm64 --load
```

Build and push to the registry:

```bash
cd dev
docker buildx bake --push
```
