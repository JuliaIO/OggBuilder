using BinaryBuilder

platforms = [
  BinaryProvider.Windows(:i686),
  BinaryProvider.Windows(:x86_64),
  BinaryProvider.Linux(:i686, :glibc),
  BinaryProvider.Linux(:x86_64, :glibc),
  BinaryProvider.Linux(:aarch64, :glibc),
  BinaryProvider.Linux(:armv7l, :glibc),
  BinaryProvider.Linux(:powerpc64le, :glibc),
  BinaryProvider.MacOS()
]

sources = [
    "https://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz" =>
    "c2e8a485110b97550f453226ec644ebac6cb29d1caef2902c007edab4308d985",
]

script = raw"""
cd $WORKSPACE/srcdir/libogg-1.3.3

./configure --prefix=$prefix --host=${target}
make -j${nproc}
make install
"""

products = prefix -> [
  LibraryProduct(prefix, "libogg"),
]

# Be quiet unless we've passed `--verbose`
verbose = "--verbose" in ARGS
ARGS = filter!(x -> x != "--verbose", ARGS)

# Choose which platforms to build for; if we've got an argument use that one,
# otherwise default to just building all of them!
build_platforms = platforms
if length(ARGS) > 0
    build_platforms = platform_key.(split(ARGS[1], ","))
end
info("Building for $(join(triplet.(build_platforms), ", "))")


autobuild(pwd(), "Ogg", build_platforms, sources, script, products; verbose=verbose)
