#!/bin/bash

TARGET=$1

wget -r -np -nH --cut-dirs=7 -P $1 -A stage3-amd64-hardened-[0-9]*T[0-9]*Z.tar.xz* https://ftp-stud.hs-esslingen.de/pub/Mirrors/gentoo/releases/amd64/autobuilds/current-stage3-amd64-hardened/


