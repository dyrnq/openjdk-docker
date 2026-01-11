#!/usr/bin/env bash
set -Eeo pipefail

base_image="${base_image:-}"
version="${version:-8u472-b08}";
push="${push:-false}"
repo="${repo:-dyrnq}"
image_name="${image_name:-jenkins}"
platforms="${platforms:-linux/amd64,linux/arm64/v8}"
curl_opts="${curl_opts:-}"



while [ $# -gt 0 ]; do
    case "$1" in
        --base-image|--base)
            base_image="$2"
            shift
            ;;
        --version|--ver)
            version="$2"
            shift
            ;;
        --push)
            push="$2"
            shift
            ;;
        --curl-opts)
            curl_opts="$2"
            shift
            ;;
        --platforms)
            platforms="$2"
            shift
            ;;
        --repo)
            repo="$2"
            shift
            ;;
        --image-name|--image)
            image_name="$2"
            shift
            ;;
        --*)
            echo "Illegal option $1"
            ;;
    esac
    shift $(( $# > 0 ? 1 : 0 ))
done





for pkg in "jdk" "jre"; do
latest_tag=" --tag $repo/$image_name:${pkg}${version}-debian"
docker buildx build \
--platform ${platforms} \
--output "type=image,push=${push}" \
--build-arg version="${version}" \
--build-arg pkg=$pkg \
--file ./8/jdk/debian/Dockerfile.hotspot.releases.full . \
$latest_tag

done