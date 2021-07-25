#!/usr/bin/env bash

ansible-playbook ./ansible-playbook/install.yml
service=$(minikube service --url web-service)
echo "$service"
#start $service
