FROM ubuntu:14.04
MAINTAINER Junichi Kajiwara<junichi.kajiwara@gmail.com>
RUN echo ""
RUN apt-get update

# 絶対ダイアログは出さない
ENV DEBIAN_FRONTEND noninteractive

# Mosaic本体のありか
ENV MOSAIC_SRC_URL ftp://ftp.ncsa.uiuc.edu/Web/Mosaic/Unix/source/Mosaic-src-2.7b5.tar.gz

# Mosaicに必要なライブラリを入れる
RUN apt-get install --no-install-recommends -y libmotif-dev libjpeg62-dev libpng12-dev zlib1g-dev
RUN apt-get install --fix-missing --no-install-recommends -y wget patch build-essential libxt-dev \
  libxmu-headers libxext-dev libxmu-dev git x11vnc python python-numpy unzip Xvfb openbox geany

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
RUN cd /root/work/ &&  patch -p0 < mosaic.patch && cd Mosaic-src && make
# Mosaicのインストール
RUN cp /root/work/Mosaic-src/src/Mosaic /usr/local/bin

# Set environment variables.
ENV HOME /root
# Define working directory.
WORKDIR /root
RUN apt-get install -y ca-certificates xterm
RUN cd /root && git clone https://github.com/kanaka/noVNC.git
RUN ln -s /usr/local/bin/Mosaic /usr/local/bin/x-www-browser
ADD startup.sh /startup.sh
RUN chmod 0755 /startup.sh

RUN mkdir /root/.vnc
RUN x11vnc -storepasswd 1234 ~/.vnc/passwd
#RUN bash -c 'echo "Mosaic" >> ~/.bashrc'

# Define default command.
CMD ["bash"]
EXPOSE 6080
