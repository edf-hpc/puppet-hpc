# pam_mkhomedir.py: creates homedir of being logged in users and takes
# care of creating outer containers and setting up appropriate rights.
#
# Usage:
#   login session   requisite   pam_python.so pam_mkhomedir.py
#
# Dependencies:
# - libpam-python
# - acl

import pwd
from pwd import getpwnam
import grp
import os
from os.path import exists
import sys
import syslog
import shutil

home_dir = "/home"
scratch_dir = "/scratch"

debug_mode = False
skel_dir = '/etc/skel'

def debug(fmt, *args):
  if debug_mode:
    syslog.syslog(fmt % args)

def create_user_dir(pamh, basedir, user, skel=False):
  # Some user might have a personal directory that has not the same
  # name as their username, we use the last directory of the 
  # homedir entry ('/home/toto' -> 'toto')
  userdir_basename = os.path.basename(pwd.getpwnam(user).pw_dir)
  userdir = os.path.join(basedir, userdir_basename)
  uid = pwd.getpwnam(user).pw_uid
  maingid = pwd.getpwnam(user).pw_gid


  if exists(userdir):
    if not os.path.isdir(userdir):
      debug ("-> unlink %s" % userdir)
      os.unlink(userdir)
      debug ("<- unlink %s" % userdir)
    else:
      if os.system("setfacl -m u:%s:rwx %s" % (user, userdir)) != 0:
        syslog.syslog("Setting ACLs for user %s on %s failed!" % (user, userdir))

  if not exists(userdir):
    if skel:
        # Create user tree by copying content of /etc/skel
        debug ("-> shutil.copytree %s" % userdir)
        shutil.copytree(skel_dir + "/.", userdir, True)
        debug ("<- shutil.copytree %s" % userdir)
    else:
        debug ("-> mkdir %s" % userdir)
        os.mkdir(userdir)
        debug ("<- mkdir %s" % userdir)
    debug ("-> recursive chown %s" % userdir)
    for root, dirs, files in os.walk(userdir):
        for d in dirs:
            os.chown(os.path.join(root, d), uid, maingid)
        for f in files:
            os.chown(os.path.join(root, f), uid, maingid)
    debug ("<- recursive chown %s" % userdir)
    # Userdir
    debug ("-> userdir chmod %s" % userdir)
    os.chown(userdir, 0, 0)
    os.chmod(userdir, 0700)
    debug ("<- userdir chmod %s" % userdir)
    # Set ACL on user's dir
    if os.system("setfacl -m u:%s:rwx %s" % (user, userdir)) != 0:
        syslog.syslog("Setting ACLs for user %s on %s failed!" % (user, userdir))

def pam_sm_authenticate(pamh, flags, argv):
  return pamh.PAM_SUCCESS

def pam_sm_setcred(pamh, flags, argv):
  return pamh.PAM_SUCCESS

def pam_sm_acct_mgmt(pamh, flags, argv):
  return pamh.PAM_SUCCESS

def pam_sm_open_session(pamh, flags, argv):
  global debug_mode, skel_dir

  syslog.openlog("pam_mkhomedir", syslog.LOG_PID, syslog.LOG_AUTH)
  try:
    user = pamh.get_user(None)
  except pamh.exception, e:
    return e.pam_result

  if "debug" in argv:
    debug_mode = True

  skel_dirs = [ d.replace("skel=", "") for d in argv if d.startswith("skel=") ]
  if skel_dirs:
    skel_dir = skel_dirs[0]

  # Ignore users with uid < 1000
  minimum_uid = 1000
  if pwd.getpwnam(user).pw_uid < minimum_uid:
    return pamh.PAM_SUCCESS

  try:
    create_user_dir(pamh, home_dir, user, skel=True)
    create_user_dir(pamh, scratch_dir, user, skel=False)

    pamh.env['SCRATCHDIR'] = os.path.join(scratch_dir, user)

    return pamh.PAM_SUCCESS

  except Exception as inst:
    syslog.syslog(inst.__str__())
    return pamh.PAM_AUTH_ERR

def pam_sm_close_session(pamh, flags, argv):
  return pamh.PAM_SUCCESS

def pam_sm_chauthtok(pamh, flags, argv):
  return pamh.PAM_SUCCESS
