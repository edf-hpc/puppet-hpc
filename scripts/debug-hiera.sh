#!/bin/bash

environment=production

scope_file=$(mktemp --tmpdir debug-hiera-scope-file_XXXXXX)

if [ -z "${scope_file}" ]
then
  echo "Fail to create temporary scope file" >&2
  exit 1
fi

cat > "${scope_file}" << EOF
environment: ${environment}
EOF

hiera -c /etc/puppet/hiera.yaml -y "${scope_file}" "${@}"

rm "${scope_file}"
