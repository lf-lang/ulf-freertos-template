#!/usr/bin/env bash
set -e

build_pico_test() {
    local program=$1
    local target=$2
    local board=$3
    echo "========================================="
    echo "Building $program for $target on $board"
    echo "========================================="
    cmake -Bbuild \
      -DLF_MAIN=$program \
      -DPLATFORM_TARGET=$target \
      -DPICO_BOARD=$board
    cmake --build build -j "$(nproc)"
    rm -rf build src-gen
}

# Automatically discover all LF examples in src directory (excluding lib subdirectory)
EXAMPLES=()
for lf_file in src/*.lf; do
    if [ -f "$lf_file" ]; then
        # Extract filename without path and extension
        example=$(basename "$lf_file" .lf)
        EXAMPLES+=("$example")
    fi
done

echo "Found examples: " "${EXAMPLES[@]}"

echo "Testing Pico platform..."

TARGET=("pico")
BOARD=("pico_w")

for target in "${TARGET[@]}"; do
  for board in "${BOARD[@]}"; do
    echo ""
    echo "========================================"
    echo "Testing platform: $target on board: $board"
    echo "========================================"

    for example in "${EXAMPLES[@]}"; do
        build_pico_test "$example" "$target" "$board"
    done
  done
done

echo ""
echo "========================================"
echo "All tests completed successfully!"
echo "========================================"
