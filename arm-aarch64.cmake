set( LINUX_ON_ARM True )
set(LINUX_ON_ARM_COMPILE_OPTIONS
  -march=armv8-a
  -mtune=cortex-a53
  -Wno-psabi
  -flax-vector-conversions #FIXME - remove this
  )

