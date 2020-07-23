#!/bin/bash
# Build Charm++ and its AMR library.

./build charm++ multicore-linux-x86_64 clang -j6

cd src/libs/ck-libs/amr/
make
cd -
