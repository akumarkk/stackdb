#Install all the necessary utils
install_utils()
{
	sudo apt-get --assume-yes install byacc flex bison libssl-dev default-jre default-jdk
	sudo apt-get --assume-yes install pkg-config libusb-dev m4 autoconf libtool libtool-bin
	sudo apt-get --assume-yes install pkg-config libusb-dev libglib2.0-dev
	sudo apt-get --assume-yes install zlib1g-dev libncurses5-dev
	sudo apt-get --assume-yes install libffi-dev
	sudo apt-get --assume-yes install libbz2-dev
	sudo apt-get --assume-yes install swig clips
	sudo apt-get --assume-yes build-dep clips
}


#Install setup tools
install_setuptools()
{
    wget --no-check-certificate https://bootstrap.pypa.io/ez_setup.py -O - | sudo python
    if [ $? -ne 0 ];
    then
        echo "setuptools installation failed!!!";
        exit -1;
    else
        echo "Successfully installed setuptools!";
    fi
    return 0;
}

build_stackdb()
{
    if [ $# -eq 0 ]
    then
        echo "Please stackdb base directory!!!" >&2;
	    exit -1;
    fi

    STACKDB_DIR=$1;
    cd $STACKDb_DIR;
    install_glib;
    install_elfutils;
    install_judy;
    install_gsoap;
    vmi;
    install_utils;
    install_setuptools;
    install_python_sudo;
    install_pysimplesoap;
    install_ant;
    install_axis;
    install_clipssrc;
    stackdb;
}


install_glib()
{
    cd $STACKDB_DIR;
    wget http://ftp.acc.umu.se/pub/gnome/sources/glib/2.45/glib-2.45.7.tar.xz
    tar xvf glib-2.45.7.tar.xz
    cd glib-2.45.7
    ./configure --prefix=/opt/vmi/glib
    make && sudo make install
    if [ $? -ne 0 ]
    then
        echo "glib installation failed!!!";
        exit -1;
    else
        echo "Successfully installed glib";
    fi

    return 0;
}



#
install_elfutils()
{
    cd $STACKDB_DIR
    wget https://fedorahosted.org/releases/e/l/elfutils/0.163/elfutils-0.163.tar.bz2 --no-check-certificate
    tar xvfj elfutils-0.163.tar.bz2
    cd elfutils-0.163
    ./configure --prefix=/opt/vmi/elfutils --with-zlib --with-bzlib \
        --enable-debugpred
    make && sudo make install
    if [ $? -ne 0 ]
    then
        echo "elfutils installation failed!!!";
        exit -1;
    else
        echo "Successfully installed elfutils";
    fi

    return 0;
}



install_distorm()
{

    cd $STACKDB_DIR
    git clone https://github.com/gdabah/distorm
    cd ./distorm/make/linux && make && sudo make install
    cd ../../
    sudo cp -pv include/* /usr/local/include/
    
    if [ $? -ne 0 ]
    then
        echo "Distorm installation failed!!!";
        exit -1;
    else
        echo "Successfully installed Distorm";
    fi

    return 0;
}


install_judy()
{
    cd $STACKDB_DIR
    wget http://sourceforge.net/projects/judy/files/judy/Judy-1.0.5/Judy-1.0.5.tar.gz
    tar xvfz Judy-1.0.5.tar.gz
    cd ./judy-1.0.5
    ./configure && make && sudo make install
    if [ $? -ne 0 ]
    then
        echo "Judy sudo installation failed!!!";
        exit -1;
    else
        echo "Successfully installed Judy";
    fi

    return 0;
}


install_gsoap()
{
    cd $STACKDB_DIR
    wget http://sourceforge.net/projects/gsoap2/files/gSOAP/gsoap_2.8.23.zip
    unzip gsoap_2.8.23.zip
    cd ./gsoap-2.8
    ./configure && make && sudo make install
    if [ $? -ne 0 ]
    then
        echo "Gsoap installation failed!!!";
        exit -1;
    else
        echo "Successfully installed Gsoap";
    fi

    return 0;
}


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


vmi()
{
    cd $STACKDB_DIR;
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

install_pysimplesoap()
{
    cd $STACKDB_DIR;
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
    cd $STACKDB_DIR/PySimpleSOAP-1.10
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

install_ant()
{
    cd $STACKDB_DIR;
    wget http://mirrors.koehn.com/apache//ant/binaries/apache-ant-1.9.6-bin.zip;
    unzip apache-ant-1.9.6-bin.zip
    sudo mv -f apache-ant-1.9.6 /opt/

    if [ $? -ne 0 ]
    then
        echo "PySimpleSoap installation failed!!!";
        exit -1;
    else
        echo "PySimpleSoap installed successfully!";
    fi
    return 0;
}

install_axis()
{
    cd $STACKDB_DIR;
    wget http://mirror.cogentco.com/pub/apache//axis/axis2/java/core/1.6.3/axis2-1.6.3-bin.zip;
    sudo unzip axis2-*-bin.zip -d /opt/
    if [ $? -ne 0 ]
    then
        echo "Axis installation failed!!!";
        exit -1;
    else
        echo "Axis installed successfully!";
    fi
    return 0;
}

install_clipssrc()
{
    cd $STACKDB_DIR;
    sudo apt-get build-dep clips;
    sudo apt-get source clips;
    cd clips-6.24/;
    sudo dpkg-buildpackage;

    cd $STACKDB_DIR;
    wget http://pkgs.fedoraproject.org/repo/pkgs/clips/clipssrc.tar.Z/ccba9d912375e57a1b7d9eba12da4198/clipssrc.tar.Z
    tar xvfz clipssrc.tar.Z
    sudo mv -f clipssrc /opt/
}

stackdb()
{
    cd $STACKDB_DIR;
    cd vmi && autoconf && cd ..;
    mkdir vmi.obj && cd vmi.obj

    ../vmi/configure --with-elfutils=/opt/vmi/elfutils --with-libvmi=/usr/local --disable-xenaccess --enable-libvmi --enable-soap --enable-asm --with-clipssrc=~/Desktop/stackdb/clips-6.24/clipssrc/ --with-glib=/opt/vmi/glib;
    if [ $? -ne 0 ]
    then 
        echo "stackdb : Configure failed";
        exit -1;
    else
        echo "Successfully configured stackdb";
    fi

    make && sudo make install;
    if [ $? -ne 0 ]
    then
        echo "stackdb : make failed";
        exit -1;
    else
        echo "Successfully build stackdb";
    fi
}

if [ $# -lt 1 ]
then
    echo "Stackdn directory not supplied";
    exit -1;
fi
echo "Building stackdb...";
log_file=$1/stackdb.log
echo "logfile : $log_file";
exec > $log_file;

build_stackdb $1;
