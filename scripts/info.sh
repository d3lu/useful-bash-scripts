#!/bin/env bash
#
#

echo -e "[--------------------------------User Information-----------------------------]"
echo -e "\nActive user:\t\t$(w | cut -d ' ' -f1 | grep -v USER | xargs -n1)"
echo -e "UID:\t\t\t$(id -u)"
echo -e "GID:\t\t\t$(id -g)"
echo -e "Home directory:\t\t$(eval echo ~$USER)"
echo -e "Default shell:\t\t$(getent passwd $LOGNAME | cut -d: -f7)"
echo -e "Uptime:\t\t\t$(uptime | awk '{print $3,$4}' | sed 's/,//')"

echo -e "\n[-------------------------------System Information----------------------------]"
echo -e "\nManufacturer:\t\t$(cat /sys/class/dmi/id/chassis_vendor)"
echo -e "Product name:\t\t$(cat /sys/class/dmi/id/product_name)"
echo -e "Machine type:\t\t$(vserver=$(lscpu | grep Hypervisor | wc -l); if [ $vserver -gt 0 ]; then echo "VM"; else echo "Physical"; fi)"
echo -e "Operating system:\t$(hostnamectl | grep "Operating System" | cut -d ' ' -f5-)"
echo -e "Kernel:\t\t\t$(uname -r)"
echo -e "Architecture:\t\t$(uname -m)"
echo -e "Processor name:\t\t$(awk -F':' '/^model name/ {print $2}' /proc/cpuinfo | uniq | sed -e 's/^[ \t]*//')"

echo -e "\n[-------------------------------Network Information----------------------------]"
echo -e "\nPublic IP Address:\t$(curl -sS ifconfig.me)"
echo -e "Private IP Address:\t$(hostname -i)"
interface=$(ip addr show | awk 'FNR==7 {print $2}' | tr -d ':')
echo -e "Interface name:\t\t$interface"
echo -e "MAC Address:\t\t$(ip addr show $interface | grep -w ether | awk '{ print $2 }')"
echo -ne "Netmask:\t\t$(ifconfig | grep -w inet | grep -v 127.0.0.1 | awk '{print $4}' | cut -d ":" -f 2)"
echo -e " ($(ip address show dev $interface | awk -F'[ /]' '/inet /{print $7}'))"
echo -e "Gateway IP Address:\t$(ip route | grep ^default'\s'via | head -1 | awk '{print$3}')\n"
