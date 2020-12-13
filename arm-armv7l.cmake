set( LINUX_ON_ARM True )
set(LINUX_ON_ARM_COMPILE_OPTIONS
  -march=armv7
  -mfpu=vfpv3-d16
  -mno-unaligned-access
  -Wno-psabi
  -flax-vector-conversions
  )

