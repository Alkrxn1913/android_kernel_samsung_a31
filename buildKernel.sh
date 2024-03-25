#!/bin/bash

# Written by Hakalle (Velosh) <hakalle@proton.me>.

# Clone GCC & Proton Clang.
#[[ -d "$(pwd)/gcc/" ]] || git clone https://github.com/VH-Devices/toolchains -b gcc-10.3.0 gcc --depth 1 >> /dev/null 2> /dev/null
#[[ -d "$(pwd)/clang/" ]] || git clone https://github.com/kdrag0n/proton-clang clang --depth 1 >> /dev/null 2> /dev/null

# Clone KernelSU
# patch -p1 < kernelsu.patch
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -s main

# Export KBUILD_BUILD_{USER,HOST} flags.
export KBUILD_BUILD_USER="RXN"
export KBUILD_BUILD_HOST="NetHunter"


# Export ARCH/SUBARCH flags.
export ANDROID_MAJOR_VERSION="s"
export ARCH="arm64"
export SUBARCH="arm64"

# Export CCACHE
export CCACHE_EXEC="$(which ccache)"
export CCACHE="${CCACHE_EXEC}"
export CCACHE_COMPRESS="1"
export USE_CCACHE="1"
$CCACHE -M 50G

# Export toolchain/clang/llvm flags
export CROSS_COMPILE="/usr/bin/aarch64-linux-android-"
export CLANG_TRIPLE="aarch64-linux-gnu-"
export CC="$clang"

# Export if/else outdir var
export WITH_OUTDIR=true

# Clear the console
clear

# Remove out dir folder and clean the source
if [ "${WITH_OUTDIR}" == true ]; then
   if [ -d "$(pwd)/a31" ]; then
      rm -rf a31
   fi
fi

# Build time
if [ "${WITH_OUTDIR}" == true ]; then
   if [ ! -d "$(pwd)/a31" ]; then
      mkdir a31
   fi
fi

if [ "${WITH_OUTDIR}" == true ]; then
   "${CCACHE}" make KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y --ignore-errors O="$(pwd)/a31" a31_ksu_defconfig
   "${CCACHE}" make KCFLAGS=-w CONFIG_SECTION_MISMATCH_WARN_ONLY=y --ignore-errors -j16 O="$(pwd)/a31"
fi
