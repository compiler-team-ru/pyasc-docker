variable "IMAGE_NAME" {
  default = "ghcr.io/compiler-team-ru/pyasc/dev"
}

variable "IMAGE_TAGS" {
  default = ["latest", "cann-9.2.0"]
  type = list(string)
}

target "common" {
  context = "."
  dockerfile = "Dockerfile"
  tags = [for tag in IMAGE_TAGS: "${IMAGE_NAME}:${tag}"]
}

target "amd64" {
  inherits = ["common"]
  platforms = ["linux/amd64"]
  args = {
    CCACHE_ARCHIVE_URL = "https://github.com/ccache/ccache/releases/download/v4.13.6/ccache-4.13.6-linux-x86_64-glibc.tar.xz"
    CANN_TOOLKIT_URL = "https://ascend-cann-open.obs.cn-north-4.myhuaweicloud.com/CANN/CANN%209.2.0/Ascend-cann_9.2.0_linux-x86_64.run"
    LLVM_ARCHIVE_URL = "https://cann-ai.obs.cn-north-4.myhuaweicloud.com/llvm/llvm-19.1.7-x86_64.tar.xz"
  }
}

target "arm64" {
  inherits = ["common"]
  platforms = ["linux/arm64"]
  args = {
    CCACHE_ARCHIVE_URL = "https://github.com/ccache/ccache/releases/download/v4.13.6/ccache-4.13.6-linux-aarch64-glibc.tar.xz"
    CANN_TOOLKIT_URL = "https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%209.2.0/Ascend-cann-toolkit_9.2.0_linux-aarch64.run"
    LLVM_ARCHIVE_URL = "https://cann-ai.obs.cn-north-4.myhuaweicloud.com/llvm/llvm-19.1.7-aarch64.tar.xz"
  }
}

group "default" {
  targets = ["amd64", "arm64"]
}

variable "LOCAL_GATEWAY" {
  default = "http://host.docker.internal:8000"
}

target "common-local" {
  extra-hosts = {
    "host.docker.internal" = "172.17.0.1"
  }
}

target "amd64-local" {
  inherits = ["common-local", "amd64"]
  args = {
    CCACHE_ARCHIVE_URL = "${LOCAL_GATEWAY}/ccache-4.13.6-linux-x86_64-glibc.tar.xz"
    CANN_TOOLKIT_URL = "${LOCAL_GATEWAY}/Ascend-cann_9.2.0_linux-x86_64.run"
    LLVM_ARCHIVE_URL = "${LOCAL_GATEWAY}/llvm-19.1.7-x86_64.tar.xz"
  }
}

target "arm64-local" {
  inherits = ["common-local", "arm64"]
  args = {
    CCACHE_ARCHIVE_URL = "${LOCAL_GATEWAY}/ccache-4.13.6-linux-aarch64-glibc.tar.xz"
    CANN_TOOLKIT_URL = "${LOCAL_GATEWAY}/Ascend-cann-toolkit_9.2.0_linux-aarch64.run"
    LLVM_ARCHIVE_URL = "${LOCAL_GATEWAY}/llvm-19.1.7-aarch64.tar.xz"
  }
}

group "local" {
  targets = ["amd64-local", "arm64-local"]
}
