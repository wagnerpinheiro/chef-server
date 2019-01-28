#!/bin/bash -e
sysctl -wq kernel.shmmax=17179869184
sysctl -wq net.ipv6.conf.lo.disable_ipv6=0
/opt/opscode/embedded/bin/runsvdir-start &
if [ -f "/etc/opscode/chef_configured" ]
  then
    echo -e "\nRunning: 'chef-server-ctl reconfigure'. This step will take a few minutes..."
    # necessario reconfigure no caso de failover, para refazer as configuracoes no systemd
    chef-server-ctl reconfigure
    echo -e "\nChef Server already configured!\n"
    chef-server-ctl status
  else
    echo -e "\nNew install of Chef-Server!"
    /usr/local/bin/configure_chef.sh
fi
tail -F /opt/opscode/embedded/service/*/log/current
