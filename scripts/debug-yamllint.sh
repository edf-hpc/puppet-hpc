#!/bin/bash

puppet_env="${PUPPET_ENVIRONMENT:-production}"

hpc_puppet_hieradata_dir=/etc/puppet/environments/${puppet_env}/hieradata

yamllint_config="$(mktemp --tmpdir yamllint_config_XXXXX.yaml)"

if [ -z "${yamllint_config}" ]
then
  echo "ERROR: Could not create temporary file." >&2
  exit 1
fi

cat > "${yamllint_config}" << EOF
---

extends: default

rules:
  braces:
    level: warning
    max-spaces-inside: 1
  brackets:
    level: warning
    max-spaces-inside: 1
  colons:
    level: warning
    max-spaces-after: -1
  commas:
    level: warning
  comments: disable
  comments-indentation: disable
  document-start: disable
  empty-lines:
    level: warning
  hyphens:
    level: warning
  indentation:
    level: warning
    spaces: 2
    indent-sequences: consistent
  line-length: disable
  trailing-spaces: disable

EOF

yaml_files="$(find "${hpc_puppet_hieradata_dir}" -name "*.yaml")"

yamllint -c "${yamllint_config}" ${yaml_files}

rm "${yamllint_config}"
