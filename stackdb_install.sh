sudo apt-get --assume-yes install pkg-config libusb-dev
sudo apt-get --assume-yes install zlib1g-dev libncurses5-dev
sudo apt-get --assume-yes install libffi-dev
sudo apt-get --assume-yes install libbz2-dev



wget http://ftp.acc.umu.se/pub/gnome/sources/glib/2.45/glib-2.45.7.tar.xz
tar xvf glib-2.45.7.tar.xz
cd glib-2.45.7
./configure --prefix=/opt/vmi/glib
make && make install
cd ~/stackdb


#
wget https://fedorahosted.org/releases/e/l/elfutils/0.163/elfutils-0.163.tar.bz2 --no-check-certificate
tar xvfj elfutils-0.163.tar.bz2
cd elfutils-0.163
./configure --prefix=/opt/vmi/elfutils --with-zlib --with-bzlib \
        --enable-debugpred
make && make install
