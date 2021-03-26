#!/bin/bash

set -o pipefail

# config
image_name=$IMAGE_NAME
current_git_tag=${CURRENT_GIT_TAG}
custom_version=${CUSTOM_VERSION}
add_latest_tag=${ADD_LATEST_TAG:-true}
use_git_tag=${USE_GIT_TAG:-false}
repo_owner=${REPO_OWNER}

# Print config
echo "*** CONFIGURATION ***"
echo -e "\tIMAGE_NAME: ${image_name}"
echo -e "\tCURRENT_GIT_TAG: ${current_git_tag}"
echo -e "\tCUSTOM_VERSION: ${custom_version}"
echo -e "\tADD_LATEST_TAG: ${add_latest_tag}"
echo -e "\tUSE_GIT_TAG: ${use_git_tag}"
echo -e "\tREPO_OWNER: ${repo_owner}"

echo "Preparing Docker tags for repository"
          
IMAGE_ID=ghcr.io/$repo_owner/$image_name

# Change all uppercase to lowercase
IMAGE_ID=$(echo $IMAGE_ID | tr '[A-Z]' '[a-z]')

# Strip "v" prefix from tag name
VERSION_FROM_GIT_TAG=$(echo $current_git_tag | sed -e 's/^v//')

# Use Docker `latest` tag convention
LATEST_VERSION="latest"

TAG_CUSTOM="$IMAGE_ID:$custom_version"

TAG_FROM_GIT_TAG="$IMAGE_ID:$VERSION_FROM_GIT_TAG"

TAG_LATEST="$IMAGE_ID:$LATEST_VERSION"
TAGS_TO_ADD=""
[ $add_latest_tag == "true" ] && TAGS_TO_ADD="$TAG_LATEST"
[[ ! -z "$VERSION_FROM_INPUT" ]] && TAGS_TO_ADD="$TAGS_TO_ADD,$TAG_CUSTOM"          

[ $use_git_tag == "true" ] && TAGS_TO_ADD="$TAGS_TO_ADD,$TAG_FROM_GIT_TAG"


# Print created tags
echo "*** Created variables ***"
echo IMAGE_ID=$IMAGE_ID
echo VERSION_FROM_INPUT=$VERSION_FROM_INPUT
echo VERSION_FROM_GIT_TAG=$VERSION_FROM_GIT_TAG
echo LATEST_VERSION=$LATEST_VERSION
echo TAG_CUSTOM=$TAG_CUSTOM
echo TAG_FROM_GIT_TAG=$TAG_FROM_GIT_TAG
echo TAG_LATEST=$TAG_LATEST
echo TAGS_TO_ADD:${TAGS_TO_ADD}    

# set outputs

echo ::set-output name=tags::$TAGS_TO_ADD
echo ::set-output name=tag_from_git_tag::$TAG_FROM_GIT_TAG
echo ::set-output name=tag_latest::$TAG_LATEST
echo ::set-output name=tag_custom::$TAG_CUSTOM