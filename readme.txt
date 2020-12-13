apt-get install build-essential libcairo-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util-dev

git clone https://github.com/surge-synthesizer/surge.git
cd surge
git checkout release_1.7.1
git submodule update --init --recursive
patch -p1 < /compile/doc/surge/remove-parallel-option.patch
patch -p1 < /compile/doc/surge/install-to-usr-local.patch

# if the vst2-sdk headers are available - otherwise ignore this line
export VST2SDK_DIR=/compile/source/vcvrack-dockerbuild-v0/vst2-sdk

# x86_64
./build-linux.sh --project=vst3 build
./build-linux.sh --project=vst2 build
./build-linux.sh --project=lv2 build
./build-linux.sh --project=headless build
./build-linux.sh --project=vst3 install
./build-linux.sh --project=vst2 install
./build-linux.sh --project=lv2 install
./build-linux.sh --project=headless install
tar czf /tmp/surge-1.7.1.x86_64.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/vst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless

# armv7l
patch -p1 < /compile/doc/surge/armv7l-compile-fix.patch
cp /compile/doc/surge/arm-armv7l.cmake /compile/source/surge/cmake
cmake . -Bbuild -DARM_NATIVE=armv7l
cmake --build build --config Release --target Surge-VST3-Packaged
cmake --build build --config Release --target Surge-VST2-Packaged
cmake --build build --config Release --target Surge-LV2-Packaged
cmake --build build --config Release --target surge-headless
rm -rf /usr/local/share/surge
mkdir -p /usr/local/share/surge
cp -a resources/data/* /usr/local/share/surge
rm -rf /usr/local/lib/vst3/Surge.vst3
mkdir -p /usr/local/lib/vst3
cp -a build/surge_products/Surge.vst3 /usr/local/lib/vst3
mkdir -p /usr/local/lib/vst
cp -a build/surge_products/Surge.so /usr/local/lib/vst
rm -rf /usr/local/lib/lv2/Surge.lv2
mkdir -p /usr/local/lib/lv2
cp -a build/surge_products/Surge.lv2 /usr/local/lib/lv2
cp -a build/surge_products/surge-headless /usr/local/bin
tar czf /tmp/surge-1.7.1.armv7l.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/vst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless

# aarch64
cp /compile/doc/surge/arm-aarch64.cmake /compile/source/surge/cmake
cmake . -Bbuild -DARM_NATIVE=aarch64
cmake --build build --config Release --target Surge-VST3-Packaged
cmake --build build --config Release --target Surge-VST2-Packaged
cmake --build build --config Release --target Surge-LV2-Packaged
cmake --build build --config Release --target surge-headless
rm -rf /usr/local/share/surge
mkdir -p /usr/local/share/surge
cp -a resources/data/* /usr/local/share/surge
rm -rf /usr/local/lib/vst3/Surge.vst3
mkdir -p /usr/local/lib/vst3
cp -a build/surge_products/Surge.vst3 /usr/local/lib/vst3
mkdir -p /usr/local/lib/vst
cp -a build/surge_products/Surge.so /usr/local/lib/vst
rm -rf /usr/local/lib/lv2/Surge.lv2
mkdir -p /usr/local/lib/lv2
cp -a build/surge_products/Surge.lv2 /usr/local/lib/lv2
cp -a build/surge_products/surge-headless /usr/local/bin
tar czf /tmp/surge-1.7.1.aarch64.tar.gz /usr/local/share/surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/vst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
