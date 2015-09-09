
sudo apt-get --assume-yes install byacc flex bison libssl-dev
sudo apt-get --assume-yes install pkg-config libusb-dev m4
sudo apt-get --assume-yes install pkg-config libusb-dev 
sudo apt-get --assume-yes install zlib1g-dev libncurses5-dev
sudo apt-get --assume-yes install libffi-dev
sudo apt-get --assume-yes install libbz2-dev

#Install setup tools
install_setuptools()
{
    wget --no-check-certificate https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
    if[ $? -ne 0 ];
    then
        echo "setuptools installation failed!!!";
        exit -1;
    else
        echo "Successfully installed setuptools!";
    fi
    return 0;
}


if[ $# eq 0 ]
then
    echo "Please stackdb base directory!!!";
	exit -1;
fi

STACKDB_DIR=$1;
install_setuptools();
install_python_sudo();
install_pysimplesoap();


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

cd STACKDB_DIR
wget http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.23.zip
unzip gsoap_2.8.23.zip
cd ./gsoap-2.8
./configure && make && sudo make install



install_python_sudo()
{
    cd STACKDB_DIR
    wget https://fedorahosted.org/releases/s/u/suds/python-suds-0.4.tar.gz
    tar xvfz python-suds-0.4.tar.gz
    cd python-suds-0.4 && python2 setup.py build && sudo python2 setup.py install
    if [ $? -ne 0 ]
    then
        echo "Python sudo installation failed!!!";
        exit -1;
    else
        echo "Successfully installed Python Sudo";
    fi

    return 0;
}


vmi(insatall_dir)
{
    git clone http://git-public.flux.utah.edu/git/a3/vmi.git
    if [ $? -ne 0 ]
    then 
        echo "failed to clone vmi!!!";
        exit -1;
    else
        echo "Cloned VMI successfully!";
    fi
    return 0;
}

install_pysimplesoap(install_dir)
{
    cd $install_dir;
    wget https://pysimplesoap.googlecode.com/files/PySimpleSOAP-1.10.zip
    ret_wget=$?
    patch -p1 < $install_dir/vmi/xml/etc/pysimplesoap-soap-env.patch
    ret_patch=$?
    if [ $ret_wget -ne 0 ] || [ $ret_patch -ne 0 ]
    then 
        echo "pySimpleSoap or Patching to pySimpleSoap failed!";
        #exit -1;
    else
        echo "Successfully installed pySimpleSoap";
    fi

    unzip PySimpleSOAP-1.10.zip
    cd $insatll_dir/PySimpleSOAP-1.10
    python2 setup.py build && sudo python2 setup.py install

    if [ $? -ne 0 ]
    then
        echo "PySimpleSoap installation failed!!!";
        exit -1;
    else
        echo "PySimpleSoap installed successfully!";
    fi
    return 0;
}

