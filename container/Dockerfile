FROM debian:forky-slim AS environment

RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential python3 gcc-arm-none-eabi libnewlib-arm-none-eabi libstdc++-arm-none-eabi-newlib ca-certificates ninja-build ccache git curl \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN curl -L https://github.com/Kitware/CMake/releases/download/v4.1.2/cmake-4.1.2-linux-x86_64.sh -o cmake.sh \
 && chmod +x cmake.sh \
 && ./cmake.sh --skip-license --prefix=/usr/local \
 && rm cmake.sh

WORKDIR /usr/local/src

RUN git clone --depth 1 --recurse-submodules --shallow-submodules --single-branch --jobs 8 https://github.com/raspberrypi/pico-sdk.git --branch 2.2.0
ENV PICO_SDK_PATH /usr/local/src/pico-sdk

RUN git clone --depth 1 --recurse-submodules --shallow-submodules --single-branch --jobs 8 https://github.com/raspberrypi/picotool.git --branch 2.2.0 \
 && mkdir picotool/build \
 && cd picotool/build \
 && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Release \
 && cmake --build . --parallel \
 && cmake --install . \
 && cd ../.. \
 && rm -r picotool

FROM environment AS builder

ARG USER_NAME
ARG HOME_DIR
ARG USER_ID
ARG GROUP_ID
ARG SRC_DIR

RUN apt-get update \
 && apt-get install -y --no-install-recommends tini clangd clang-tools clang-format lldb \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN groupadd -g ${GROUP_ID} ${USER_NAME} \
 && useradd -m -d ${HOME_DIR} -u ${USER_ID} -g ${GROUP_ID} -s /bin/bash ${USER_NAME}

USER ${USER_NAME}

WORKDIR ${SRC_DIR}

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/bin/sleep", "infinity"]
