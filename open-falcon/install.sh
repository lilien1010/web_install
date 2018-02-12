#/bin/bash

DOWNLOAD="https://github.com/open-falcon/of-release/releases/download/v0.1.0/open-falcon-v0.1.0.tar.gz"
cd $WORKSPACE

mkdir ./tmp
#下载
wget $DOWNLOAD -O open-falcon-latest.tar.gz

#解压
tar -zxf open-falcon-latest.tar.gz -C ./tmp/
for x in `find ./tmp/ -name "*.tar.gz"`;do \
    app=`echo $x|cut -d '-' -f2`; \
    mkdir -p $app; \
    tar -zxf $x -C $app; \
done
