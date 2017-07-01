include:
  - salt/saltstack


/etc/salt/minion:
  file.managed:
    # TODO: put files in a nicer layout
    - source: salt://salt/minion/conf/minion

python-setproctitle:
  pkg.installed:
    - version: 1.1.8-1build2

python-concurrent.futures:
  pkg.installed:
    - version: 3.0.5-1

salt-minion:
  pkg.installed:
    # TODO: template version from pillar
    - version: 2016.11.6+ds-1
    - requires:
      - pkgrepo: saltstack
      - pkg: python-concurrent.futures
      - pkg: python-setproctitle
  service.running:
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion


