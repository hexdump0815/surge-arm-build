apt-get install build-essential libcairo-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util-dev

git clone https://github.com/surge-synthesizer/surge.git
cd surge
git checkout release_1.8.1
git submodule update --init --recursive
patch -p1 < /compile/doc/surge/remove-parallel-option.patch
patch -p1 < /compile/doc/surge/install-to-usr-local.patch
patch -p1 < /compile/doc/surge/adjust-cmake.patch

# if the vst2-sdk headers are available - otherwise ignore this line
export VST2SDK_DIR=/compile/source/vcvrack-dockerbuild-v0/vst2-sdk

# armv7l
cp /compile/doc/surge/arm-armv7l.cmake /compile/source/surge/cmake/arm-native.cmake
# aarch64
cp /compile/doc/surge/arm-aarch64.cmake /compile/source/surge/cmake/arm-native.cmake
./build-linux.sh --project=vst2 build
./build-linux.sh --project=vst3 build
./build-linux.sh --project=lv2 build
./build-linux.sh --project=headless build
rm -rf /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless /usr/local/lib/vst/Surge.so
./build-linux.sh --project=vst2 install
./build-linux.sh --project=vst3 install
./build-linux.sh --project=lv2 install
./build-linux.sh --project=headless install
# armv7l
tar czf /tmp/surge-1.8.1.armv7l.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
tar czf /tmp/surge-vst-1.8.1.armv7l.tar.gz /usr/local/lib/vst/Surge.so
# aarch64
tar czf /tmp/surge-1.8.1.aarch64.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
tar czf /tmp/surge-vst-1.8.1.aarch64.tar.gz /usr/local/lib/vst/Surge.so
# x86_64
tar czf /tmp/surge-1.8.1.x86_64.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
tar czf /tmp/surge-vst-1.8.1.x86_64.tar.gz /usr/local/lib/vst/Surge.so
