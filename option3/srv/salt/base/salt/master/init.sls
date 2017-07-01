include:
  - salt/saltstack


/etc/salt/master:
  file.managed:
    # TODO: put files in a nicer layout
    - source: salt://salt/master/conf/master
    - template: jinja

python-git:
  pkg.installed:
    - version: _1.0.1+git137-gc8b8379-2.1

python-setproctitle:
  pkg.installed:
    - version: 1.1.8-1build2

python-concurrent.futures:
  pkg.installed:
    - version: 3.0.5-1

salt-master:
  pkg.installed:
    # TODO: template version from pillar
    - version: 2016.11.6+ds-1
    - requires:
      - pkgrepo: saltstack
      - pkg: python-concurrent.futures
      - pkg: python-setproctitle
      - pkg: python-git
  service.running:
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master
      - pkg: python-concurrent.futures
      - pkg: python-setproctitle
      - pkg: python-git
