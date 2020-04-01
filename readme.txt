apt-get install build-essential libcairo-dev libxkbcommon-x11-dev libxkbcommon-dev libxcb-cursor-dev libxcb-keysyms1-dev libxcb-util-dev

export VST2SDK_DIR=/compile/source/vcvrack-dockerbuild-v0/vst2-sdk

git clone https://github.com/surge-synthesizer/surge.git
cd surge
git checkout release_1.6.6
git submodule update --init --recursive

git clone https://github.com/nemequ/simde.git
cd simde
git checkout a61e88057c90ceb4b0b2cf5182919717bbb0496b

find * -type f -exec /compile/source/vcvrack-dockerbuild-v1/simde-ify.sh {} \;

export PATH=$PATH:/compile/source/premake-5.0.0-alpha14/bin/release
# armv7l
#patch -p0 < /compile/doc/surge/surge-armv7l.patch
# aarch64
#patch -p0 < /compile/doc/surge/surge-aarch64.patch
./build-linux.sh build
# will fail
# armv7l
#patch -p0 < /compile/doc/surge/surge-armv7l-makefiles.patch
# aarch64
#patch -p0 < /compile/doc/surge/surge-aarch64-makefiles.patch
# now rerun after patching
./build-linux.sh build
# will fail at headless
# armv7l
#patch -p0 < /compile/doc/surge/surge-armv7l-headless.patch
# aarch64
#patch -p0 < /compile/doc/surge/surge-aarch64-headless.patch
# now rerun after patching
./build-linux.sh build
./build-linux.sh install
# armv7l
#tar czf /tmp/surge-1.6.6.armv7l.tar.gz /usr/local/share/Surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lxvst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
# aarch64
#tar czf /tmp/surge-1.6.6.aarch64.tar.gz /usr/local/share/Surge /usr/local/lib/vst3/Surge.vst3 /usr/local/lib/lxvst/Surge.so /usr/local/lib/lv2/Surge.lv2 /usr/local/bin/Surge-Headless
