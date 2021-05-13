apt-get install build-essential libcairo-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util-dev

git clone https://github.com/surge-synthesizer/surge-extra-content.git
cd surge-extra-content
git checkout afc591cc06d9adc3dc8dc515a55c66873fa10296
cd ..
git clone https://github.com/surge-synthesizer/surge.git
cd surge
git checkout release_1.9.0
git submodule update --init --recursive
patch -p1 < /compile/doc/surge/remove-parallel-option.patch
patch -p1 < /compile/doc/surge/install-to-usr-local.patch
patch -p1 < /compile/doc/surge/adjust-cmake.patch

# if the vst2-sdk headers are available - otherwise ignore this line
export VST2SDK_DIR=/compile/source/vcvrack-dockerbuild-v0/vst2-sdk

# armv7l - the .cmake file does not seem to work - thus the export after
cp /compile/doc/surge/arm-armv7l.cmake /compile/source/surge/cmake/arm-native.cmake
export CXXFLAGS="-march=armv7 -mfpu=vfpv3-d16 -mno-unaligned-access -Wno-psabi -Wno-attribute -flax-vector-conversions" CFLAGS="-march=armv7 -mfpu=vfpv3-d16 -mno-unaligned-access -Wno-psabi -Wno-attribute -flax-vector-conversions"
# aarch64 - the .cmake file does not seem to work - thus the export after
cp /compile/doc/surge/arm-aarch64.cmake /compile/source/surge/cmake/arm-native.cmake
export CXXFLAGS="-march=armv8-a -mtune=cortex-a53 -Wno-psabi -flax-vector-conversions" CFLAGS="-march=armv8-a -mtune=cortex-a53 -Wno-psabi -flax-vector-conversions"
./build-linux.sh --project=vst2 build
./build-linux.sh --project=vst3 build
./build-linux.sh --project=lv2 build
./build-linux.sh --project=headless build
rm -rf /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless /usr/local/lib/vst/Surge.so
./build-linux.sh --project=vst2 install
./build-linux.sh --project=vst3 install
./build-linux.sh --project=lv2 install
./build-linux.sh --project=headless install
cp -r /compile/source/surge-extra-content/Skins/royal-surge.surge-skin /usr/local/share/surge/skins
# armv7l
tar czf /tmp/surge-1.9.0.armv7l.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
tar czf /tmp/surge-vst-1.9.0.armv7l.tar.gz /usr/local/lib/vst/Surge.so
# aarch64
tar czf /tmp/surge-1.9.0.aarch64.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
tar czf /tmp/surge-vst-1.9.0.aarch64.tar.gz /usr/local/lib/vst/Surge.so
# x86_64
tar czf /tmp/surge-1.9.0.x86_64.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
tar czf /tmp/surge-vst-1.9.0.x86_64.tar.gz /usr/local/lib/vst/Surge.so
