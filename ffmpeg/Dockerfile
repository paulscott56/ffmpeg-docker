# ffmpeg - http://ffmpeg.org/download.html
#
# Based on Dockerfile by jrottenburg
#
# Version     N-77987-g5776344
# From https://trac.ffmpeg.org/wiki/CompilationGuide/Centos
#
# https://hub.docker.com/r/paulscott56/ffmpeg/
#
# ffmpeg version N-77987-g5776344 Copyright (c) 2000-2016 the FFmpeg developers
# built with gcc 4.6 (Ubuntu/Linaro 4.6.4-6ubuntu2)
#  configuration: --prefix=/home/paul/dockerImages/ffmpeg_build --pkg-config-flags=--static --extra-cflags=-I/home/paul/dockerImages/ffmpeg_build/include --extra-ldflags=-L/home/paul/dockerImages/# # #  ffmpeg_build/lib --bindir=/home/paul/bin --enable-gpl --enable-libass --enable-libfdk-aac --enable-libfreetype 
#  --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libx265 --enable-nonfree
#  libavutil      55. 14.100 / 55. 14.100
#  libavcodec     57. 22.100 / 57. 22.100
#  libavformat    57. 22.100 / 57. 22.100
#  libavdevice    57.  0.100 / 57.  0.100
#  libavfilter     6. 26.100 /  6. 26.100
#  libswscale      4.  0.100 /  4.  0.100
#  libswresample   2.  0.101 /  2.  0.101
#  libpostproc    54.  0.100 / 54.  0.100
#
#
FROM          ubuntu:14.04
MAINTAINER    Paul Scott <pscott209@gmail.com>


CMD           ["--help"]
ENTRYPOINT    ["ffmpeg"]
WORKDIR       /tmp/workdir


ENV           FFMPEG_VERSION=N-77987-g5776344 \
              YASM_VERSION=1.3.0   \
              OGG_VERSION=1.3.2    \
              VORBIS_VERSION=1.3.5 \
              THEORA_VERSION=1.1.1 \
              LAME_VERSION=3.99.5  \
              OPUS_VERSION=1.1.1   \
              FAAC_VERSION=1.28    \
              VPX_VERSION=1.5.0    \
              XVID_VERSION=1.3.4   \
              FDKAAC_VERSION=0.1.4 \
              X265_VERSION=1.8


# See https://github.com/jrottenberg/ffmpeg/blob/master/run.sh
COPY          run.sh /tmp/run.sh

RUN           /tmp/run.sh && ffmpeg -buildconf

