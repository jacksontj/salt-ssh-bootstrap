include:
  - salt/saltstack


/etc/salt/master:
  file.managed:
    # TODO: put files in a nicer layout
    - source: salt://salt/syndic/conf/master

/etc/salt/minion:
  file.managed:
    # TODO: put files in a nicer layout
    - source: salt://salt/syndic/conf/minion

python-concurrent.futures:
  pkg.installed:
    - version: 3.0.5-1

salt-master:
  pkg.installed:
    # TODO: template version from pillar
    - version: 2016.11.6+ds-1
    - requires:
      - pkg: python-concurrent.futures
      - pkgrepo: saltstack
  service.running:
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master

salt-syndic:
  pkg.installed:
    # TODO: template version from pillar
    - version: 2016.11.6+ds-1
    - requires:
      - pkg: python-concurrent.futures
      - pkgrepo: saltstack
  service.running:
    - watch:
      - pkg: salt-syndic
      - file: /etc/salt/master
      - file: /etc/salt/minion
