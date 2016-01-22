#!/bin/bash

set -euo pipefail

echo "/usr/local/lib" > /etc/ld.so.conf.d/libc.conf

export MAKEFLAGS="-j$[$(nproc) + 1]"
export SRC=/usr/local
export PKG_CONFIG_PATH=${SRC}/lib/pkgconfig

sudo apt-get update
sudo apt-get -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev curl git wget mercurial libx264-dev

# yasm
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s http://www.tortall.net/projects/yasm/releases/yasm-${YASM_VERSION}.tar.gz | \
              tar zxvf - -C . && \
              cd ${DIR}/yasm-${YASM_VERSION} && \
              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --docdir=${DIR} -mandir=${DIR}&& \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# x265
DIR=$(mktemp -d) && cd ${DIR} && \
              hg clone https://bitbucket.org/multicoreware/x265 && \
              cd x265/build/linux && \

              #curl -s https://bitbucket.org/multicoreware/x265/get/${X265_VERSION}.tar.gz | tar zxvf - -C . && \
              #cd multicoreware-*/source && \
              PATH="${SRC}/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="${DIR}" -DENABLE_SHARED:bool=off ../../source && \
              #cmake -G "Unix Makefiles" . && \
              #make  && \
              make && \
              make install && \
              make distclean

# libogg
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz | tar zxvf - -C . && \
              cd libogg-${OGG_VERSION} && \
              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-shared --docdir=/dev/null && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# libopus
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s http://downloads.xiph.org/releases/opus/opus-${OPUS_VERSION}.tar.gz | tar zxvf - -C . && \
              cd opus-${OPUS_VERSION} && \
              autoreconf -fiv && \
              ./configure --prefix="${SRC}" --disable-shared && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# libvorbis
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz | tar zxvf - -C . && \
              cd libvorbis-${VORBIS_VERSION} && \
              ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
              --disable-shared --datadir=${DIR} && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# libtheora
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.bz2 | tar jxvf - -C . && \
              cd libtheora-${THEORA_VERSION} && \
              ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
              --disable-shared --datadir=${DIR} && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# libvpx
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | tar zxvf - -C . && \
              cd libvpx-${VPX_VERSION} && \
              ./configure --prefix="${SRC}" --enable-vp8 --enable-vp9 --disable-examples && \
              make && \
              make install && \
              make clean && \
              rm -rf ${DIR}

# libmp3lame
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -L -s http://downloads.sourceforge.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | tar zxvf - -C . && \
              cd lame-${LAME_VERSION} && \
              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-shared --enable-nasm && \
              make && \
              make install && \
              make distclean&& \
              rm -rf ${DIR}


# faac + http://stackoverflow.com/a/4320377
DIR=$(mktemp -d) &&  cd ${DIR} && \
              curl -L -s http://downloads.sourceforge.net/faac/faac-${FAAC_VERSION}.tar.gz | tar zxvf - -C . && \
              cd faac-${FAAC_VERSION} && \
              sed -i '126d' common/mp4v2/mpeg4ip.h && \
              ./bootstrap && \
              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" && \
              make && \
              make install &&\
              rm -rf ${DIR}

# xvid
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -L -s  http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz | tar zxvf - -C .&& \
              cd xvidcore/build/generic && \
              ./configure --prefix="${SRC}" --bindir="${SRC}/bin" && \
              make && \
              make install&& \
              rm -rf ${DIR}


# fdk-aac
DIR=$(mktemp -d) && cd ${DIR} && \
              curl -s https://codeload.github.com/mstorsjo/fdk-aac/tar.gz/v${FDKAAC_VERSION} | tar zxvf - -C . && \
              cd fdk-aac-${FDKAAC_VERSION} && \
              autoreconf -fiv && \
              ./configure --prefix="${SRC}" --disable-shared && \
              make && \
              make install && \
              make distclean && \
              rm -rf ${DIR}

# ffmpeg
DIR=$(mktemp -d) && cd ${DIR} && \
              wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
              tar xjvf ffmpeg-snapshot.tar.bz2 && \
              cd ffmpeg && \
              ./configure --prefix="${SRC}" --extra-cflags="-I${SRC}/include" \
              -pkg-config-flags="--static" \
              --extra-ldflags="-L${SRC}/lib" --bindir="${SRC}/bin" \
              --extra-libs=-ldl --enable-version3 --enable-libfaac --enable-libmp3lame --enable-libass \
              --enable-libx264 --enable-libxvid --enable-gpl --enable-libfreetype \
              --enable-postproc --enable-nonfree --enable-avresample --enable-libfdk-aac \
              --disable-debug --enable-small --enable-openssl --enable-libtheora \
              --enable-libx265 --enable-libopus --enable-libvorbis --enable-libvpx && \
              export PATH="${DIR}/bin:$PATH" && \
              make && \
              make install && \
              make distclean && \
              hash -r && \
              #cd tools && \
              #make qt-faststart && \
              #cp qt-faststart ${SRC}/bin && \
              #rm -rf ${DIR}



