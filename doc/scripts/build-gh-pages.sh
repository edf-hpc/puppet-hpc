#!/bin/bash
docdir="$(dirname $(dirname $(readlink -f ${BASH_SOURCE[0]})))"

puppet_hpc_current_git="$(dirname "${docdir}")" 

temp_base="$(mktemp -d --tmpdir puppet_hpc_build_gh_pagesXXXXX)"

puppet_hpc_dir="${temp_base}/puppet-hpc-master"
puppet_hpc_gh_pages="${temp_base}/puppet-hpc-gh-pages"


git_user_name="$(cd ${puppet_hpc_current_git} ; git config user.name)"
git_user_email="$(cd ${puppet_hpc_current_git} ; git config user.email)"

git clone "${puppet_hpc_current_git}" "${puppet_hpc_dir}"
git clone -b gh-pages "${puppet_hpc_current_git}" "${puppet_hpc_gh_pages}"

rm -rf ${docdir}/gh-pages

mkdir ${docdir}/gh-pages
mkdir ${docdir}/gh-pages/modules

(
  cd ${docdir}
  make

  cp puppet_hpc_reference-0.1.html ${docdir}/gh-pages/puppet_hpc_reference-0.1.html
  cp puppet_hpc_reference-0.1.pdf ${docdir}/gh-pages/puppet_hpc_reference-0.1.pdf
)

module_list="$(find "${puppet_hpc_dir}/puppet-config/modules" -mindepth 1 -maxdepth 1 -name '[^.]*' -type d -printf '%f\n' |sort)"

(
  cd "${puppet_hpc_dir}/puppet-config/cluster/profiles"
  puppet strings
  cp -r doc "${docdir}/gh-pages/profiles"
)

for i in ${module_list}
do 
  (
    echo "##$i"
    cd "${puppet_hpc_dir}/puppet-config/modules/$i"
    puppet strings
    cp -r doc "${docdir}/gh-pages/modules/$i"
  )
done

cat > "${docdir}/gh-pages/index.html" << EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Puppet HPC Documentation</title>
<style type="text/css" media="screen">
body { background: #e7e7e7; font-family: Verdana, sans-serif; font-size: 11pt; }
#page { background: #ffffff; margin: 50px; border: 2px solid #c0c0c0; padding: 10px; }
#header { background: #4b6983; border: 2px solid #7590ae; text-align: center; padding: 10px; color: #ffffff; }
#header h1 { color: #ffffff; }
#body { padding: 10px; }
span.tt { font-family: monospace; }
span.bold { font-weight: bold; }
a:link { text-decoration: none; font-weight: bold; color: #C00; background: #ffc; }
a:visited { text-decoration: none; font-weight: bold; color: #999; background: #ffc; }
a:active { text-decoration: none; font-weight: bold; color: #F00; background: #FC0; }
a:hover { text-decoration: none; color: #C00; background: #FC0; }
</style>
</head>

<body>
<div id="page">
  <div id="header">
  <h1> Puppet HPC Documentation </h1>
  </div>

  <div id="body">
  <h2> Documentations </h2>
  <ul>
  <li> Puppet HPC Configuration </li>
    <ul>
    <li><a href="puppet_hpc_reference-0.1.html">HTML</a></li>
    <li><a href="puppet_hpc_reference-0.1.pdf">PDF</a></li>
    </ul>
  <br/>

  <li> Puppet Profiles </li>
    <ul>
    <li> <a href="profiles/">Profiles </a></li>
    </ul>
  <br/>

  <li> Puppet Generic Modules </li>
    <ul>
EOF

for i in ${module_list}
do
    cat >> "${docdir}/gh-pages/index.html" << EOF
    <li> <a href="modules/${i}/index.html">${i}</a> </li>
EOF
done

cat >> "${docdir}/gh-pages/index.html" << EOF
    </ul>
  <br/>

</div>
</body>
</html>
EOF


if [ -n "${puppet_hpc_gh_pages}" ]
then
  (
    cd "${puppet_hpc_gh_pages}"
    rm -rf *
    cp -r ${docdir}/gh-pages/* .
    git add *
    git commit -m "Automatic doc regen" --author="${git_user_name} <${git_user_email}>"
  )
  (
    cd ${docdir}
    git fetch "${puppet_hpc_gh_pages}" gh-pages:gh-pages
  )
  rm -rf "${temp_base}"
fi

