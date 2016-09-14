#!/bin/bash

script_dir="$(readlink -f $(dirname "${BASH_SOURCE[0]}"))"

puppethpc_dir="$(dirname "${script_dir}")"
hpcprivate_dir="$(dirname "${puppethpc_dir}")/hpc-privatedata"
environment="${CONFIG_ENVIRONMENT:-production}"
version='latest'
cluster_name="${CLUSTER_NAME:-eole}"
destination_host="${DESTINATION_HOST:-service1}"
destination_path="${DESTINATION_PATH:-/var/admin/public/http/mirror/hpc-config}"
destination="${destination_host}:${destination_path}"
destination_cmd=( "ssh" "${destination_host}" )

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

private_manifests_dir="${hpcprivate_dir}/puppet-config/${cluster_name}/manifests"

private_files_dir="${hpcprivate_dir}/files/${cluster_name}"

private_hiera_yaml="${hpcprivate_dir}/puppet-config/${cluster_name}/hiera.yaml"

private_facts_yaml="${hpcprivate_dir}/puppet-config/${cluster_name}/hpc-config-facts.yaml"

private_puppet_conf="${hpcprivate_dir}/puppet-config/${cluster_name}/puppet.conf"

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
  # -L: dereference symlinks
  cp -faL ${source}/* "${tmp_dir}/${environment}/modules_generic"
done

echo "## Creating env modules private"

mkdir "${tmp_dir}/${environment}/modules_private"
for source in "${private_modules_sources[@]}"
do
  # -L: dereference symlinks
  cp -faL ${source}/* "${tmp_dir}/${environment}/modules_private"
done

echo "## Creating env hieradata"

mkdir "${tmp_dir}/${environment}/hieradata"
cp -a "${private_hieradata_dir}" "${tmp_dir}/${environment}/hieradata/private"
cp -a "${generic_hieradata_dir}" "${tmp_dir}/${environment}/hieradata/generic"

if [ -d "${private_manifests_dir}" ] 
then
	cp -a "${private_manifests_dir}" "${tmp_dir}/${environment}/manifests"
else
	cp -a "${generic_manifests_dir}" "${tmp_dir}/${environment}/manifests"
fi

echo "## Creating env config"

cat > "${tmp_dir}/${environment}/environment.conf" << EOF
modulepath=modules_private:modules_generic
manifest=manifests/cluster.pp
EOF

echo "## Building Destination"

if [ -n "${destination}" ] && [ -n "${environment}" ] && [ -n "${version}" ] 
then
  "${destination_cmd[@]}" rm -rf "${destination_path}/${environment}/${version}"
fi

"${destination_cmd[@]}" mkdir -p "${destination_path}/${environment}/${version}"

(
  cd "${tmp_dir}"
  tar cJf "puppet-config-environment.tar.xz" "${environment}"
  scp -q "puppet-config-environment.tar.xz" "${destination}/${environment}/${version}"
)

scp -qr "${private_files_dir}" "${destination}/${environment}/${version}/files"

scp -q "${private_hiera_yaml}" "${destination}/${environment}/${version}/hiera.yaml"

scp -q "${private_facts_yaml}" "${destination}/${environment}/${version}/hpc-config-facts.yaml"

scp -q "${private_puppet_conf}" "${destination}/${environment}/${version}/puppet.conf"

echo "## Cleaning"

if [ -d "${tmp_dir}" ] 
then
  rm -rf "${tmp_dir}"
fi
