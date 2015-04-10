#!/bin/sh

if ! test -d coreos-ansible-example; then
  echo "##### cloning coreos vagrant configuration..."
  git clone https://github.com/defunctzombie/coreos-ansible-example.git
  echo ""
fi

cd coreos-ansible-example

# ramp up the memory
sed -i 's/vb_memory = 1024/vb_memory = 4096/g' config.rb Vagrantfile

# spin up the vagrant box, this will take a while
echo ""
echo "##### spinning up vagrant, be patient..."
vagrant up || exit 1
./bin/generate_ssh_config

if ! grep -q ansible_ssh_host inventory/vagrant; then
  echo "ansible_ssh_host=172.12.8.101" >> inventory/vagrant
fi

if ! grep -q ansible_ssh_user inventory/vagrant; then
  echo "ansible_ssh_user=core" >> inventory/vagrant
fi

echo ""
echo "##### setting up ansible and docker-py on vagrant"
ansible -i inventory/vagrant all -m setup >/dev/null 2>&1
ansible-galaxy install --ignore-errors defunctzombie.coreos-bootstrap -p ../roles
ansible-playbook -i inventory/vagrant ../bootstrap-docker.yml

cd ..

ssh-add ~/.vagrant.d/insecure_private_key
ansible-playbook deploy-rvi-dev.yml -i coreos-ansible-example/inventory/vagrant
