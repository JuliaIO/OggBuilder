using BinaryBuilder

# Collection of sources required to build Ogg
name = "Ogg"
version = v"1.3.3"
sources = [
    "https://downloads.xiph.org/releases/ogg/libogg-$(version).tar.gz" =>
    "c2e8a485110b97550f453226ec644ebac6cb29d1caef2902c007edab4308d985",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libogg-*/

./configure --prefix=$prefix --host=${target}
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    # Windows
    Windows(:i686),
    Windows(:x86_64),

    # linux
    Linux(:i686, :glibc),
    Linux(:x86_64, :glibc),
    Linux(:aarch64, :glibc),
    Linux(:armv7l, :glibc),
    Linux(:powerpc64le, :glibc),

    # musl
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),

    # The BSD's
    FreeBSD(:x86_64),
    MacOS(:x86_64),
]

# The products that we will ensure are always built
products = prefix -> [
    LibraryProduct(prefix, "libogg", :libogg),
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
