include:
  - salt/saltstack


/etc/salt/master:
  file.managed:
    # TODO: put files in a nicer layout
    - source: salt://salt/master/conf/master
    - template: jinja

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


