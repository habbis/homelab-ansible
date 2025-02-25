# homelab-ansible

## quickstart

setup right ansible version in python venv
```
source scripts/setup.sh
```


### To use ansible vault secrets


I use [vaulti](https://github.com/oveee92/vaulti) its a python script for ansible vault inline encryption.


To use open a file and it will open in your default editor and  type in your ansible-vault pass.

```
vaulti yourfile.yml
```

To encrypt a secreets add !ENCRYPT before variabel then it becomes inline encrypted.

like this.
```
!ENCRYPT yoursecrets
```

Here is example this inline secrets is encrypted with password: linux .

```
vaulti test.yml
```

```
---
hey: this is not encrypted
hey2: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  63323235616463616638356638363561336363343037343333323866303436623232376464353565
  6434336431643937336237663235636633633163656136660a306434656638363462663131353536
  33643465343235666165383531353034313132663731306335346535366661393162343637353339
  3737316464393664630a383732386465626330386538306131356366363630393366376536343561
  33346162356631306665366639643766373632383830383462396662333434393934
```

To run a playbook.
```

# first to to your ansible control repo.
cd homelab-ansible

# then soruce the setup script
source scripts/setup.sh

# to run a playbook.
ansible-playbook -i inventories/prod/hosts playbooks/standard_setup.yml

# to limmit to certain hosts.
ansible-playbook -i inventories/prod/hosts playbooks/standard_setup.yml -l hf-myhost*

# to run a playbook with ansible-vault secrets.
ansible-playbook -i inventories/prod/hosts playbooks/standard_setup.yml  --ask-vault-pass

# to run a playbook with ansible-vault secrets and ssh, sudo password.
ansible-playbook -i inventories/prod/hosts playbooks/standard_setup.yml  --ask-pass --ask-become-pass  --ask-vault-pass

# or use short.
ansible-playbook -i inventories/prod/hosts playbooks/standard_setup.yml -k -K --ask-vault-pass

```




