
munge:
  pkg:
    - installed

slurm-user:
  user.present:
    - name: slurm
    - shell: /bin/bash

/etc/slurm/slurm.conf:
  file:
    - managed
    - source: salt://scheduling/slurm.conf
