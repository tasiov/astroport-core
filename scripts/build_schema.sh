#!/usr/bin/env bash

set -e
set -o pipefail

projectPath=$(cd "$(dirname "${0}")" && cd ../ && pwd)
declare -a skipDirs=("pair_astro_xastro" "pair_concentrated_inj" "tokenomics" "periphery" "incentives")

process_directory() {
  local dir=$1
  local projectPath=$2

  skip=false
  for skipDir in "${skipDirs[@]}"; do
    if [[ "$dir" == *"$skipDir"* ]]; then
      skip=true
      break
    fi
  done
  
  if [ "$skip" == false ]; then
    cd $dir
    echo $dir
    cargo schema
    first_file=$(find "$dir/schema" -maxdepth 1 -type f | head -n 1)
    filename="$(basename $first_file .json)"
    mkdir -p $projectPath/schema/$filename
    cp schema/$filename.json $projectPath/schema/$filename/$filename.json
    rm -rf schema
    cd "$projectPath"
  fi
}

for c in "$projectPath"/contracts/*; do
    process_directory "$c" "$projectPath"
done

for c in "$projectPath"/contracts/tokenomics/*; do
  process_directory "$c" "$projectPath"
done

for c in "$projectPath"/contracts/periphery/*; do
  process_directory "$c" "$projectPath"
done
