target "common" {
  context = "."
  dockerfile = "Dockerfile"
  tags = [
    "ghcr.io/compiler-team-ru/pyasc-docker/dev:cann-9.0.0",
    "ghcr.io/compiler-team-ru/pyasc-docker/dev:latest",
  ]
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
