
#
# CVMFS
#

squid:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: squid
      - file: /etc/squid/squid.conf

/etc/squid/squid.conf:
  file:
    - managed
    - source: salt://lhcb/squid.conf
    - require:
      - pkg: squid

/etc/yum.repos.d/cernvm.repo:
  file:
    - managed
    - source: salt://lhcb/cernvm.repo
    - require:
      - file: /etc/pki/rpm-gpg/CernVM

/etc/pki/rpm-gpg/CernVM:
  file:
    - managed
    - source: http://cvmrepo.web.cern.ch/cvmrepo/yum/RPM-GPG-KEY-CernVM
    - source_hash: sha256=9b2e7135186a0f1349279e96e4128c7d2199284dfde657f9a92f2116c7e6baa7

cvmfs:
  pkg:
    - installed
    - require:
      - file: /etc/yum.repos.d/cernvm.repo

cvmfs-keys:
  pkg:
    - installed
    - require:
      - file: /etc/yum.repos.d/cernvm.repo

cvmfs-init-scripts:
  pkg:
    - installed
    - require:
      - file: /etc/yum.repos.d/cernvm.repo

cvmfs-config-setup:
  cmd.run:
    - name: 'cvmfs_config setup'
    - require:
      - pkg: cvmfs-init-scripts

/etc/cvmfs/default.local:
  file:
    - managed
    - source: salt://lhcb/default.local
    - mode: 644
    - require:
      - cmd: cvmfs-config-setup

autofs:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: autofs
    - watch:
      - file: /etc/cvmfs/default.local

#
# AFS
#

openafs:
  pkg:
    - installed

openafs-client:
  pkg:
    - installed

openafs-krb5:
  pkg:
    - installed
    - require:
      - file: /etc/krb5.conf

/etc/krb5.conf:
  file:
    - managed
    - source: salt://lhcb/krb5.conf
    - mode: 644

krb5-workstation:
  pkg:
    - installed

/usr/vice/etc/ThisCell:
  file.append:
    - text: "cern.ch"
    - require:
      - pkg: krb5-workstation

