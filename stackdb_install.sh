sudo apt-get --assume-yes install pkg-config libusb-dev m4
sudo apt-get --assume-yes install pkg-config libusb-dev 
sudo apt-get --assume-yes install zlib1g-dev libncurses5-dev
sudo apt-get --assume-yes install libffi-dev
sudo apt-get --assume-yes install libbz2-dev

STACKDB_DIR=$1
if[ $# eq 0 ]
    then
        echo "Please stackdb base directory!!!";
	exit -1;
fi

wget http://ftp.acc.umu.se/pub/gnome/sources/glib/2.45/glib-2.45.7.tar.xz
tar xvf glib-2.45.7.tar.xz
cd glib-2.45.7
./configure --prefix=/opt/vmi/glib
make && make install


#
cd STACKDB_DIR
wget https://fedorahosted.org/releases/e/l/elfutils/0.163/elfutils-0.163.tar.bz2 --no-check-certificate
tar xvfj elfutils-0.163.tar.bz2
cd elfutils-0.163
./configure --prefix=/opt/vmi/elfutils --with-zlib --with-bzlib \
        --enable-debugpred
make && make install


cd STACKDB_DIR
git clone https://github.com/gdabah/distorm
cd ./distorm/make/linux && make && sudo make install
cd ../../
sudo cp -pv include/* /usr/local/include/


cd STACKDB_DIR
 wget http://sourceforge.net/projects/judy/files/judy/Judy-1.0.5/Judy-1.0.5.tar.gz
tar xvfz Judy-1.0.5.tar.gz
cd ./judy-1.0.5
./configure && make && make install
