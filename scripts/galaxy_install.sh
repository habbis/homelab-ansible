#!/bin/bash

ansible-galaxy role install --role-file roles/requirements.yml --force
ansible-galaxy collection install --requirements-file collections/requirements.yml
