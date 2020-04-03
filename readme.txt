# the armv7l gcc options are from https://github.com/mapbox/protozero/issues/33#issuecomment-155596773
# with the wrong options it will give a bus error when running and even when building the lv2 plugin

# see also: https://github.com/surge-synthesizer/surge/pull/1606#issuecomment-607493825

apt-get install build-essential libcairo-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util-dev

git clone https://github.com/surge-synthesizer/surge.git
cd surge
git checkout release_1.6.6
git submodule update --init --recursive

find * -type f -exec /compile/doc/surge/simde-ify.sh {} \;

git clone https://github.com/nemequ/simde.git
# looks like that speical version is no longer needed
#cd simde
#git checkout a61e88057c90ceb4b0b2cf5182919717bbb0496b
#cd ..

export PATH=$PATH:/compile/source/premake-5.0.0-alpha14/bin/release
export VST2SDK_DIR=/compile/source/vcvrack-dockerbuild-v0/vst2-sdk

# armv7l
#patch -p0 < /compile/doc/surge/surge-armv7l.patch
# aarch64
#patch -p0 < /compile/doc/surge/surge-aarch64.patch
./build-linux.sh premake
# armv7l - neon version does crash with unaligned access
#sed -i 's, -m64,,g;s,-msse2,-march=armv7-a -mfpu=neon -mno-unaligned-access,g;s,-O3,-O3 -g,g;s,c++14,c++17,g;s,FORCE_INCLUDE +=,FORCE_INCLUDE += -Isimde/simde,g' surge-*.make
#sed -i 's, -m64,,g;s,-msse2,-march=armv7-a -mfpu=vfpv3-d16 -mno-unaligned-access,g;s,FORCE_INCLUDE +=,FORCE_INCLUDE += -Isimde/simde,g' surge-*.make
# aarch64
#sed -i 's,-msse2,-march=native -mcpu=native,g' surge-*.make
./build-linux.sh build
./build-linux.sh install
# armv7l
#tar czf /tmp/surge-1.6.6.armv7l.tar.gz /usr/local/share/Surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lxvst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
# aarch64
#tar czf /tmp/surge-1.6.6.aarch64.tar.gz /usr/local/share/Surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lxvst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
