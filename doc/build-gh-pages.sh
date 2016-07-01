#!/bin/bash
docdir="$(dirname $(readlink -f ${BASH_SOURCE[0]}))"
puppet_hpc_dir="$(dirname "${docdir}")"

rm -rf ${docdir}/gh-pages

mkdir ${docdir}/gh-pages
mkdir ${docdir}/gh-pages/modules

make

cp PuppetHPCConfiguration.html ${docdir}/gh-pages/PuppetHPCConfiguration.html
cp PuppetHPCConfiguration.pdf ${docdir}/gh-pages/PuppetHPCConfiguration.pdf

module_list="$(find "${puppet_hpc_dir}/puppet-config/modules" -mindepth 1 -maxdepth 1 -name '[^.]*' -type d -printf '%f\n')"

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

cat > gh-pages/index.html << EOF
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
    <li><a href="PuppetHPCConfiguration.html">HTML</a></li>
    <li><a href="PuppetHPCConfiguration.pdf">PDF</a></li>
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
    cat >> gh-pages/index.html << EOF
    <li> <a href="modules/${i}/index.html">${i}</a> </li>
EOF
done

cat >> gh-pages/index.html << EOF
    </ul>
  <br/>

</div>
</body>
</html>
EOF

