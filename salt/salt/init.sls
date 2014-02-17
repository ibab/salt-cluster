
{% if grains['hostname'] == pillar['salt']['master'] %}

salt-master:
  pkg:
    - installed

/etc/salt/master:
  file:
    - managed
    - require:
      - pkg: salt-master

{% else %}

salt-minion:
  pkg:
    - installed

/etc/salt/minion:
  file:
    - managed
    - require:
      - pkg: salt-minion

{% endif %}

