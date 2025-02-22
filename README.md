# EnvContainer: Lightweight DevContainer Runtime

EnvContainer is a minimal yet powerful containerized environment for running **DevContainer** projects in a self-hosted manner, akin to GitHub Codespaces. It supports **Docker Swarm, Kubernetes, Nomad, and other orchestrators**, enabling flexible workspace creation anywhere.

## 🚀 Features

-   **Self-Hosted DevContainer Runtime**: Run DevContainer projects without relying on cloud providers.
-   **Portable & Lightweight**: Works on any platform supporting Docker, including Swarm, Kubernetes and Nomad.
-   **Automatic Configuration & Setup**:
    -   Clones user dotfiles from `DOT_URL` for personal settings and credentials.
    -   Clones repositories from `GIT_URL` into `/workspaces/<REPO_NAME>`.
    -   Runs `devcontainer up` to bootstrap the environment.
-   **Fully Automated & Headless**: Deployable in CI/CD pipelines or local environments.

## 🔧 Usage

### 1️⃣ Run in Docker

```sh
docker run -d --privileged \
    -e GIT_URL=https://github.com/user/repo.git \
    -e DOT_URL=https://github.com/user/dotfiles.git \
    -v envcontainer-home:/root \
    -v envcontainer-workspaces:/workspaces \
    -v envcontainer-containers:/var/lib/docker \
    ckoliber/envcontainer:latest
```

### 2️⃣ Deploy in Docker Swarm

```sh
docker service create --name devcontainer \
    --env GIT_URL=https://github.com/user/repo.git \
    --env DOT_URL=https://github.com/user/dotfiles.git \
    --mount type=volume,source=envcontainer-home,target=/root \
    --mount type=volume,source=envcontainer-workspaces,target=/workspaces \
    --mount type=volume,source=envcontainer-containers,target=/var/lib/docker \
    ckoliber/envcontainer:latest
```

### 3️⃣ Deploy in Kubernetes

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
    name: devcontainer
spec:
    replicas: 1
    selector:
        matchLabels:
            app: devcontainer
    template:
        metadata:
            labels:
                app: devcontainer
        spec:
            containers:
                - name: devcontainer
                  image: ckoliber/envcontainer:latest
                  env:
                      - name: GIT_URL
                        value: "https://github.com/user/repo.git"
                      - name: DOT_URL
                        value: "https://github.com/user/dotfiles.git"
                  volumeMounts:
                      - name: envcontainer-home
                        mountPath: /root
                      - name: envcontainer-workspaces
                        mountPath: /workspaces
                      - name: envcontainer-containers
                        mountPath: /var/lib/docker
                  securityContext:
                      privileged: true
            volumes:
                - name: envcontainer-home
                  persistentVolumeClaim:
                      claimName: envcontainer-home
                - name: envcontainer-workspaces
                  persistentVolumeClaim:
                      claimName: envcontainer-workspaces
                - name: envcontainer-containers
                  persistentVolumeClaim:
                      claimName: envcontainer-containers
```

## 🔒 Removing the `--privileged` Flag

By default, `EnvContainer` requires `--privileged` mode to run Docker-in-Docker (DinD) and DevContainers seamlessly. However, for enhanced security and isolation, you can replace `--privileged` with a specialized runtime such as **Sysbox, Firecracker, Kata Containers, or gVisor**.

### 1️⃣ Using **Sysbox** (Recommended for Rootless Containers)

[Sysbox](https://github.com/nestybox/sysbox) is a container runtime that enables secure, rootless containers capable of running Docker, Kubernetes, and systemd inside them.

**Docker Standalone (Sysbox Runtime)**

```sh
docker run -d \
    --runtime=sysbox-runc \
    -e GIT_URL=https://github.com/user/repo.git \
    -e DOT_URL=https://github.com/user/dotfiles.git \
    -v envcontainer-home:/root \
    -v envcontainer-workspaces:/workspaces \
    -v envcontainer-containers:/var/lib/docker \
    ckoliber/envcontainer:latest
```

## 🎯 Use Cases

-   **Self-Hosted Codespaces**: Run development environments locally or on a private cloud.
-   **CI/CD Dev Environments**: Spin up DevContainers inside CI pipelines.
-   **Remote Development**: Host persistent workspaces for team collaboration.

## 📄 License

This project is licensed under the [MIT License](LICENSE.md).

## 🙌 Contributing

We welcome contributions! Feel free to open issues or submit pull requests.

## 📞 Support

For any questions or issues, feel free to open an issue on [GitHub](https://github.com/ckoliber/envcontainer).

---

🚀 **Start coding anywhere with EnvContainer!**
