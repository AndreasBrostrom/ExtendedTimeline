#!/bin/bash
set -e

VERSION=$*
PROJECT_NAME="ExtendedTimeline" 
PROJECT_FILES=("common" "events" "gfx" "interface" "localisation" "descriptor.mod" "LICENSE" "README.md", "thumbnail.png")

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PROJECT_ROOT_DIR="$(dirname "$SCRIPT_DIR")"

cd $PROJECT_ROOT_DIR

mkdir -p $PROJECT_ROOT_DIR/release/$PROJECT_NAME

#python3 $SCRIPT_DIR/make.py

echo "Making release"
for I in ${PROJECT_FILES[@]}
do
  [ -d "$I" ] || [ -f "$I" ] && echo "  copying: $I for release"
  [ -d "$I" ] || [ -f "$I" ] && cp -Rp "$I" "$PROJECT_ROOT_DIR/release/$PROJECT_NAME/."
done

echo "Writing descriptor.mod"
sed -i "s/0.0.0/${VERSION}/" $PROJECT_ROOT_DIR/release/$PROJECT_NAME/descriptor.mod
sed -i "s/ DevBuild//" $PROJECT_ROOT_DIR/release/$PROJECT_NAME/descriptor.mod
sed -i "s/UTNH/Ultimate Tech Tree : New Horizon/" $PROJECT_ROOT_DIR/release/$PROJECT_NAME/descriptor.mod

[ -f "$PROJECT_ROOT_DIR/release/$PROJECT_NAME/README.md" ] && echo "Writing README.md"
[ -f "$PROJECT_ROOT_DIR/release/$PROJECT_NAME/README.md" ] && sed -i "s/# EXTENDED TIMELINE/# EXTENDED TIMELINE v${VERSION}/" $PROJECT_ROOT_DIR/release/$PROJECT_NAME/README.md
[ -f "$PROJECT_ROOT_DIR/release/$PROJECT_NAME/README.md" ] && sed -i "2,8d" $PROJECT_ROOT_DIR/release/$PROJECT_NAME/README.md

echo "Building archive"
cd $PROJECT_ROOT_DIR/release/
zip $PROJECT_NAME.zip -r $PROJECT_NAME
