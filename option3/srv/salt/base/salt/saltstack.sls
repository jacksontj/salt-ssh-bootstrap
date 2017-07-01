python-apt:
  pkg.installed:
    - version: 1.1.0~beta1build1

saltstack:
  # TODO: break into its own file (for all repo management for saltstack)
  pkgrepo.managed:
    # template version using grains
    - name: deb http://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest xenial main
    - dist: xenial
    - file: /etc/apt/sources.list.d/saltstack-ubuntu-xenial.list
    # TODO: fix -- https://github.com/saltstack/salt/issues/32294
    - gpgcheck: 1
    - gpgkey: https://repo.saltstack.com/apt/ubuntu/16.04/amd64/latest/SALTSTACK-GPG-KEY.pub
    - require:
      - pkg: python-apt
