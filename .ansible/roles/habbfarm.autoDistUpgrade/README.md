ansible_role_autoDistUpgrade
=========


[![CI](https://github.com/habbis/ansible_role_autoDistUpgrade/workflows/CI/badge.svg)](https://github.com/habbis/ansible_role_autoDistUpgrade/actions?query=workflow%3ACI)

This role upgrade debian to new release and does not change config file.

Its using dpkg  force-confdef  force-confold .

From dpkg manpage.

```
 confold: If a conffile has been modified and the version in the package did change, always keep the old version without prompting, unless the --force-confdef is also
           specified, in which case the default action is preferred.

 confdef: If a conffile has been modified and the version in the package did change, always choose the default action without prompting. If there is no default action it will
           stop to ask the user unless --force-confnew or --force-confold is also been given, in which case it will use that to decide the final action.

```

In defaults/main.yml you can choose version.
```
debian_release: bullseye
````




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
    - { role: ../ansible_role_autoDistUpgrade }
```
