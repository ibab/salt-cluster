

openldap-clients:
  pkg:
    - installed

/etc/openldap/ldap.conf:
  file.managed:
    - source: salt://ldap/ldap.conf
    - template: jinja
    - replace: True
    - require:
      - pkg: openldap-clients

{% if grains['host'] == pillar['ldap']['host'] %}

openldap-servers:
  pkg:
    - installed

ldap-db:
  file.directory:
    - name: /var/lib/ldap/{{ pillar['ldap']['dbdir'] }}
    - user: ldap
    - makedirs: True
    - require:
      - pkg: openldap-servers

slapd:
  service.running:
    - watch:
      - file: /etc/openldap/slapd.conf
      - file: ldap-db
      - pkg: openldap-servers

/etc/openldap/slapd.conf:
  file.managed:
    - source: salt://ldap/slapd.conf
    - template: jinja
    - require:
      - pkg: openldap-servers

/tmp/db.ldif:
  file.managed:
    - source: salt://ldap/db.ldif
    - template: jinja

load-ldif:
  cmd.run:
    - name: ldapadd -x -f /tmp/db.ldif -D {{pillar['ldap']['root']}} -w {{pillar['ldap']['pass']}}
    - unless: ldapsearch -x {{pillar['ldap']['suffix']}} > /dev/null
    - require:
      - file: /etc/openldap/slapd.conf
      - file: /tmp/db.ldif
      - file: /etc/openldap/ldap.conf

{% endif %}

