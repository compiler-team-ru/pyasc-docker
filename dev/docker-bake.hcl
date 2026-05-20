variable "IMAGE_NAME" {
  default = "ghcr.io/compiler-team-ru/pyasc/dev"
}

variable "IMAGE_TAGS" {
  default = ["latest", "cann-9.0.0"]
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
    CANN_TOOLKIT_URL = "https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%209.0.0/Ascend-cann-toolkit_9.0.0_linux-x86_64.run"
    LLVM_ARCHIVE_URL = "https://oaitriton.blob.core.windows.net/public/llvm-builds/llvm-86b69c31-ubuntu-x64.tar.gz"
  }
}

target "arm64" {
  inherits = ["common"]
  platforms = ["linux/arm64"]
  args = {
    CCACHE_ARCHIVE_URL = "https://github.com/ccache/ccache/releases/download/v4.13.6/ccache-4.13.6-linux-aarch64-glibc.tar.xz"
    CANN_TOOLKIT_URL = "https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%209.0.0/Ascend-cann-toolkit_9.0.0_linux-aarch64.run"
    LLVM_ARCHIVE_URL = "https://oaitriton.blob.core.windows.net/public/llvm-builds/llvm-86b69c31-ubuntu-arm64.tar.gz"
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
    CANN_TOOLKIT_URL = "${LOCAL_GATEWAY}/Ascend-cann-toolkit_9.0.0_linux-x86_64.run"
    LLVM_ARCHIVE_URL = "${LOCAL_GATEWAY}/llvm-86b69c31-ubuntu-x64.tar.gz"
  }
}

target "arm64-local" {
  inherits = ["common-local", "arm64"]
  args = {
    CCACHE_ARCHIVE_URL = "${LOCAL_GATEWAY}/ccache-4.13.6-linux-aarch64-glibc.tar.xz"
    CANN_TOOLKIT_URL = "${LOCAL_GATEWAY}/Ascend-cann-toolkit_9.0.0_linux-aarch64.run"
    LLVM_ARCHIVE_URL = "${LOCAL_GATEWAY}/llvm-86b69c31-ubuntu-arm64.tar.gz"
  }
}

group "local" {
  targets = ["amd64-local", "arm64-local"]
}
