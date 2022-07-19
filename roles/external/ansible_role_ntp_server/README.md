ansible_role_ntp_server
=========

[![CI](https://github.com/habbis/ansible_role_ntp_server/workflows/CI/badge.svg)](https://github.com/habbis/ansible_role_ntp_server/actions?query=workflow%3ACI)

My ansible role setup chrony ntp server.


Example site.yml

```
---
- name: setup puppet agent
  gather_facts: yes
  remote_user: root
  #remote_user: ansible
  #become: yes
  #become_method: sudo
  hosts: test
  #hosts: puppet-clients
  #hosts: all
  vars_files:
    -  defaults/main.yml
    #-  defaults/secrets.yml

  roles:
    - { role: ../ansible_role_ntp_client }
```

