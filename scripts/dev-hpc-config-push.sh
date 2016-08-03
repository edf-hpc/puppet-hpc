#!/bin/bash

script_dir="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"

puppethpc_dir="$(dirname "${script_dir}")"
hpcprivate_dir="$(dirname "${puppethpc_dir}")/hpc-privatedata"
environment='production'
version='latest'
destination='/admin/public/http/mirror/hpc-config'

# Order is important, first has more priority
generic_modules_sources=(
  "${puppethpc_dir}/puppet-config/cluster"
  "${puppethpc_dir}/puppet-config/modules"
  "${puppethpc_dir}/puppet-config/modules_3rdparty"
  '/usr/share/puppet/modules'
)

private_modules_sources=( )

private_hieradata_dir="${hpcprivate_dir}/hieradata"
generic_hieradata_dir="${puppethpc_dir}/hieradata"

generic_manifests_dir="${puppethpc_dir}/puppet-config/manifests"

private_files_dir="${hpcprivate_dir}/files"

private_hiera_yaml="${hpcprivate_dir}/hiera.yaml"

echo "## Creating env structure"

tmp_dir="$(mktemp -d --tmpdir "puppet-config-${environment}-XXXX")"

if [ -z "${tmp_dir}" ]
then
  echo "Failed to create temp directory." >&2
  exit 1
fi

mkdir "${tmp_dir}/${environment}"

echo "## Creating env modules generic"

mkdir "${tmp_dir}/${environment}/modules_generic"
for source in "${generic_modules_sources[@]}"
do
  cp -fa ${source}/* "${tmp_dir}/${environment}/modules_generic"
done

echo "## Creating env modules private"

mkdir "${tmp_dir}/${environment}/modules_private"
for source in "${private_modules_sources[@]}"
do
  cp -fa ${source}/* "${tmp_dir}/${environment}/modules_private"
done

echo "## Creating env hieradata"

mkdir "${tmp_dir}/${environment}/hieradata"
cp -a "${private_hieradata_dir}" "${tmp_dir}/${environment}/hieradata/private"
cp -a "${generic_hieradata_dir}" "${tmp_dir}/${environment}/hieradata/generic"

cp -a "${generic_manifests_dir}" "${tmp_dir}/${environment}/manifests"

echo "## Creating env config"

cat > "${tmp_dir}/${environment}/environment.conf" << EOF
modulepath=modules_private:modules_generic
manifest=manifests/cluster.pp
EOF

echo "## Building Destination"

if [ -n "${destination}" ] && [ -n "${environment}" ] && [ -n "${version}" ] 
then
  rm -rf "${destination}/${environment}/${version}"
fi

mkdir -p "${destination}/${environment}/${version}"

(
  cd "${tmp_dir}"
  tar cJf "${destination}/${environment}/${version}/puppet-config-environment.tar.xz" "${environment}"
)

cp -a "${private_files_dir}" "${destination}/${environment}/${version}/files"

cp -a "${private_hiera_yaml}" "${destination}/${environment}/${version}/hiera.yaml"

echo "## Cleaning"

if [ -d "${tmp_dir}" ] 
then
  rm -rf "${tmp_dir}"
fi
