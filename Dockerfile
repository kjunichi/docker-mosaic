FROM ubuntu:14.04
MAINTAINER Junichi Kajiwara<junichi.kajiwara@gmail.com>
RUN apt-get update

# 絶対ダイアログは出さない
ENV DEBIAN_FRONTEND noninteractive

# Mosaic本体のありか
ENV MOSAIC_SRC_URL ftp://ftp.ncsa.uiuc.edu/Web/Mosaic/Unix/source/Mosaic-src-2.7b5.tar.gz

# Mosaicに必要なライブラリを入れる
RUN apt-get install -y libmotif-dev libjpeg62-dev libpng12-dev zlib1g-dev
RUN apt-get install -y wget patch build-essential

# 絶対ダイアログは出さないを戻しとく
ENV DEBIAN_FRONTEND dialog

# ヘッダやライブラリを検出できる場所に置く
RUN mkdir /root/mosaicLibs && cp /usr/include/jpeglib.h /usr/include/png.h /root/mosaicLibs/
RUN cd /usr/lib/x86_64-linux-gnu/ && cp libz.a libjpeg.a libpng.a /root/mosaicLibs/

# ローカルファイルの持ち出し
RUN mkdir /root/work
# mosaicのパッチ
ADD mosaic/mosaic.patch /root/work/mosaic.patch
# stdio.hの差し替え
ADD mosaic/stdio.h /usr/include/stdio.h

# パッチ当て
RUN cd /root/work/ && wget $MOSAIC_SRC_URL && tar xvf Mosaic-src-2.7b5.tar.gz
RUN apt-get install -y libxt-dev libxmu-headers libxext-dev libxmu-dev
RUN cd /root/work/ &&  patch -p0 < mosaic.patch && cd Mosaic-src && make
# Mosaicのインストール
RUN cp /root/work/Mosaic-src/src/Mosaic /usr/local/bin

RUN apt-get install -y git x11vnc python python-numpy unzip Xvfb openbox geany
RUN cd /root && git clone https://github.com/kanaka/noVNC.git
ADD startup.sh /startup.sh
RUN chmod 0755 /startup.sh

# Set environment variables.
ENV HOME /root
# Define working directory.
WORKDIR /root
run mkdir /root/.vnc
run x11vnc -storepasswd 1234 ~/.vnc/passwd
run bash -c 'echo "Mosaic" >> ~/.bashrc'

# Define default command.
CMD ["bash"]
EXPOSE 6080
