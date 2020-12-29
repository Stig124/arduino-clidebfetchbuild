#!/bin/bash

DPKGSIG_CACHE_PASS="true"
export DPKGSIG_CACHE_PASS
GPG_TTY="$(tty)"
export GPG_TTY
export DPKGSIG_KEYID="4348A10098DB05F6"

urlx64=https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_64bit.tar.gz
urlx86=https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_32bit.tar.gz
urlarmhf=https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_ARMv7.tar.gz
urlarm64=https://downloads.arduino.cc/arduino-cli/arduino-cli_latest_Linux_ARM64.tar.gz

if [ "$1" == "-m" ]; then
    echo -n "Version : "
    read -r VERSION
    urlx64=https://downloads.arduino.cc/arduino-cli/arduino-cli_"$VERSION"_Linux_64bit.tar.gz
    urlx86=https://downloads.arduino.cc/arduino-cli/arduino-cli_"$VERSION"_Linux_32bit.tar.gz
    urlarmhf=https://downloads.arduino.cc/arduino-cli/arduino-cli_"$VERSION"_Linux_ARMv7.tar.gz
    urlarm64=https://downloads.arduino.cc/arduino-cli/arduino-cli_"$VERSION"_Linux_ARM64.tar.gz
else 
    echo -n "Version : "
    read -r VERSION
fi

cd /tmp/debs || exit

    mkdir -p arduinocli_x64/DEBIAN
    mkdir -p arduinocli_x86/DEBIAN
    mkdir -p arduinocli_armhf/DEBIAN
    mkdir -p arduinocli_arm64/DEBIAN


    mkdir -p arduinocli_x64/usr/bin
    mkdir -p arduinocli_x86/usr/bin
    mkdir -p arduinocli_armhf/usr/bin
    mkdir -p arduinocli_arm64/usr/bin


    touch arduinocli_x64/DEBIAN/control
    touch arduinocli_x86/DEBIAN/control
    touch arduinocli_armhf/DEBIAN/control
    touch arduinocli_arm64/DEBIAN/control

    printf "Package: arduinocli\nVersion: " > arduinocli_x64/DEBIAN/control && echo "$VERSION" >> arduinocli_x64/DEBIAN/control && printf "Section: custom\nPriority: optional\nArchitecture: amd64\nEssential: no\nMaintainer: stigpro@outlook.fr\nDescription: Use Arduino on the CLI\n" >> arduinocli_x64/DEBIAN/control
    printf "Package: arduinocli\nVersion: " > arduinocli_x86/DEBIAN/control && echo "$VERSION" >> arduinocli_x86/DEBIAN/control && printf "Section: custom\nPriority: optional\nArchitecture: i386\nEssential: no\nMaintainer: stigpro@outlook.fr\nDescription: Use Arduino on the CLI\n" >> arduinocli_x86/DEBIAN/control
    printf "Package: arduinocli\nVersion: " > arduinocli_armhf/DEBIAN/control && echo "$VERSION" >> arduinocli_armhf/DEBIAN/control && printf "Section: custom\nPriority: optional\nArchitecture: armhf\nEssential: no\nMaintainer: stigpro@outlook.fr\nDescription: Use Arduino on the CLI\n" >> arduinocli_armhf/DEBIAN/control
    printf "Package: arduinocli\nVersion: " > arduinocli_arm64/DEBIAN/control && echo "$VERSION" >> arduinocli_arm64/DEBIAN/control && printf "Section: custom\nPriority: optional\nArchitecture: arm64\nEssential: no\nMaintainer: stigpro@outlook.fr\nDescription: Use Arduino on the CLI\n" >> arduinocli_arm64/DEBIAN/control

cd /tmp/debs/arduinocli_x64 || exit

    wget -O clix64.tar.gz "$urlx64"
    tar xzf clix64.tar.gz
    mv arduino-cli usr/bin
    rm clix64.tar.gz
    rm LICENSE.txt

cd /tmp/debs/arduinocli_x86 || exit

    wget -O clix86.tar.gz "$urlx86"
    tar xzf clix86.tar.gz
    mv arduino-cli usr/bin
    rm clix86.tar.gz
    rm LICENSE.txt

cd /tmp/debs/arduinocli_armhf || exit

    wget -O cliarmhf.tar.gz "$urlarmhf"
    tar xzf cliarmhf.tar.gz
    mv arduino-cli usr/bin
    rm cliarmhf.tar.gz
    rm LICENSE.txt

cd /tmp/debs/arduinocli_arm64 || exit

    wget -O cliarm64.tar.gz "$urlarm64"
    tar xzf cliarm64.tar.gz
    mv arduino-cli usr/bin
    rm cliarm64.tar.gz
    rm LICENSE.txt

cd /tmp/debs/ || exit

    dpkg-deb --build arduinocli_x64 || exit
    dpkg-deb --build arduinocli_x86 || exit
    dpkg-deb --build arduinocli_armhf || exit
    dpkg-deb --build arduinocli_arm64 || exit


if [[ -f "arduinocli_x64.deb" ]]; then
        export x64=0
        mv arduinocli_x64.deb /var/repositories/debs/arduinocli_"$VERSION"_x64.deb
    else
        export x64=1
fi

if [[ -f "arduinocli_x86.deb" ]]; then
        export x86=0
        mv arduinocli_x86.deb /var/repositories/debs/arduinocli_"$VERSION"_x86.deb
    else
        export x86=1
fi

if [[ -f "arduinocli_armhf.deb" ]]; then
        export armhf=0
        mv arduinocli_armhf.deb /var/repositories/debs/arduinocli_"$VERSION"_armhf.deb
    else
        export armhf=1
fi

if [[ -f "arduinocli_arm64.deb" ]]; then
        export arm64=0
        mv arduinocli_arm64.deb /var/repositories/debs/arduinocli_"$VERSION"_arm64.deb
    else
        export arm64=1
fi

if [ "$x64" == 0 ] && [ "$x86" == 0 ] && [ "$armhf" == 0 ] && [ "$arm64" == 0 ]; then
    cd /var/repositories/debs || exit
    dpkg-sig --sign builder arduinocli*.deb || echo "Sig failed" && exit
fi

cd /tmp/debs || exit

    rm -rf ./*