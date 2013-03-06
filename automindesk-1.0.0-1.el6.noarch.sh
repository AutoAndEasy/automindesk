#!/bin/bash

################ Script Info ################		

## Program: Auto Min Desktop V1.0
## Author:Chier Xuefei
## Date: 2013-03-03
## Update:None


################ Env Define ################

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin:~/sbin
LANG=C
export PATH
export LANG

################ Var Setting ################

VNCPass="admin123"

InputVar=$*
HomeDir="/tmp/automindesk"
BasePkg="wget expect xorg-x11-server-Xorg xorg-x11-xinit mesa-dri-drivers xorg-x11-twm xterm tigervnc-server"
AppendPkg=" Terminal "

##
if [ -z "`echo $InputVar|grep 'without\-fluxbox'`" ]; then
        AppendPkg=$AppendPkg" fluxbox "
fi
if [ -z "`echo $InputVar|grep 'without\-firefox'`" ]; then
        AppendPkg=$AppendPkg" firefox "
fi

################ Func Define ################ 
function _info_msg() {
_header
echo -e " |                                                                |"
echo -e " |                 Thank you for use automindesk!                 |"
echo -e " |                                                                |"
echo -e " |                         Version: 1.0.0                         |"
echo -e " |                                                                |"
echo -e " |                     http://www.idcsrv.com                      |"
echo -e " |                                                                |"
echo -e " |                   Author:翅儿学飞(chier xuefei)                |"
echo -e " |                      Email:myregs@126.com                      |"
echo -e " |                         QQ:1810836851                          |"
echo -e " |                         QQ群:61749648                          |"
echo -e " |                                                                |"
echo -e " |                                                                |"
echo -e " |          Usage:--without-firefox disable install firefox       |"
echo -e " |                --without-fluxbox disable install fluxbox DE    |"
echo -e " |                                                                |"
echo -e " |          Hit [ENTER] to continue or ctrl+c to exit             |"
echo -e " |                                                                |"
printf " o----------------------------------------------------------------o\n"	
 read entcs 
clear
}

function _end_msg() {
echo -e "###################################################################"
echo ""
echo -e "   Your VNC Pass IS: ${VNCPass}"
echo ""
echo -e "   Please reboot and then run 'ibus-setup' in Desktop"
echo ""
echo -e "###################################################################"
echo ""
echo ""
_header
echo -e " |                                                                |"
echo -e " |                 Thank you for use automindesk!                 |"
echo -e " |                                                                |"
echo -e " |                The software has been installed!                |"
echo -e " |                                                                |"
echo -e " |                     http://www.idcsrv.com                      |"
echo -e " |                                                                |"
echo -e " |                   Author:翅儿学飞(chier xuefei)                |"
echo -e " |                      Email:myregs@126.com                      |"
echo -e " |                         QQ:1810836851                          |"
echo -e " |                         QQ群:61749648                          |"
echo -e " |                                                                |"
printf " o----------------------------------------------------------------o\n"
}



function _header() {
	printf " o----------------------------------------------------------------o\n"
	printf " | :: AutoMinDesk                             v1.0.0 (2013/03/03) |\n"
	printf " o----------------------------------------------------------------o\n"	
}

##Program Function

################ Main ################
clear
_info_msg

if [ `id -u` != "0" ]; then
echo -e "You need to be be the root user to run this script.\nWe also suggest you use a direct root login, not su -, sudo etc..."
exit 1
fi

if [ ! -d $HomeDir ]; then
	mkdir -p $HomeDir
fi

cd $HomeDir || exit 1

yum -y install $BasePkg

wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh epel-release-6-8.noarch.rpm 
yum -y install $AppendPkg "@Chinese support"

##defalut install firefox
if [ -z "`echo $InputVar|grep 'without\-firefox'`" ]; then
	wget http://fpdownload.macromedia.com/get/flashplayer/pdc/11.2.202.273/flash-plugin-11.2.202.273-release.x86_64.rpm
	rpm -ivh flash-plugin-11.2.202.273-release.x86_64.rpm
fi

############  Soft Conf  ############

expect << EOF
spawn bash -c "vncserver"
expect "*Password:"
send "${VNCPass}\r"
expect "Verify:"
send "${VNCPass}\r"
expect eof
EOF

chkconfig --add vncserver
chkconfig --level 35 vncserver on

cp ~/.vnc/xstartup ~/.vnc/xstartup.bak

echo '#!/bin/sh' > ~/.vnc/xstartup
echo '#make by chier xuefei' >> ~/.vnc/xstartup
echo '[ -r /etc/sysconfig/i18n ] && . /etc/sysconfig/i18n' >> ~/.vnc/xstartup
echo 'export LANG' >> ~/.vnc/xstartup
echo 'export SYSFONT' >> ~/.vnc/xstartup
echo 'vncconfig -iconic &' >> ~/.vnc/xstartup
echo 'unset SESSION_MANAGER' >> ~/.vnc/xstartup
echo 'unset DBUS_SESSION_BUS_ADDRESS' >> ~/.vnc/xstartup
echo 'OS=`uname -s`' >> ~/.vnc/xstartup
echo 'if [ $OS = '\''Linux'\'' ]; then' >> ~/.vnc/xstartup
echo '  case "$WINDOWMANAGER" in' >> ~/.vnc/xstartup
echo '    *gnome*)' >> ~/.vnc/xstartup
echo '      if [ -e /etc/SuSE-release ]; then' >> ~/.vnc/xstartup
echo '        PATH=$PATH:/opt/gnome/bin' >> ~/.vnc/xstartup
echo '        export PATH' >> ~/.vnc/xstartup
echo '      fi' >> ~/.vnc/xstartup
echo '      ;;' >> ~/.vnc/xstartup
echo '  esac' >> ~/.vnc/xstartup
echo 'fi' >> ~/.vnc/xstartup
echo '[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources' >> ~/.vnc/xstartup
echo 'xsetroot -solid grey' >> ~/.vnc/xstartup
echo 'xterm -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &' >> ~/.vnc/xstartup
if [ -z "`echo $InputVar|grep 'without\-fluxbox'`" ]; then
	echo 'fluxbox &' >> ~/.vnc/xstartup
else
        echo 'twm &' >> ~/.vnc/xstartup
fi
echo 'ibus-daemon &' >> ~/.vnc/xstartup

if [ -z "`echo $InputVar|grep 'without\-fluxbox'`" ]; then
        echo 'fluxbox &' >> ~/.xinitrc
else
        echo 'twm &' >> ~/.xinitrc
fi

echo "export GTK_IM_MODULE=ibus" >> /etc/bashrc
echo "export XMODIFIERS=@im=ibus" >> /etc/bashrc
echo "export QT_IM_MODULE=ibus" >> /etc/bashrc

_end_msg
############  Clean Cache  ############
rm -rf ${HomeDir}
