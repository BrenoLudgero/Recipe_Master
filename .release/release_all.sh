source ../.env

sudo su - $ROOT_USER <<EOF
    sh "$PWD"/release.sh -m "vanilla.yaml" -n "{package-name} {project-version}{nolib}{classic}"
    sh "$PWD"/release.sh -m "cataclysm.yaml" -n "{package-name} {project-version}{nolib}{classic}"
EOF
