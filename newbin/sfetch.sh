#!/bin/bash

# Copyright Robert Renling 2022, feel free to fuck around with it in a sharealike manner.

# Configuration
username_label="Username"
hostname_label="Hostname"
os_label="OS"
distro_label="Distro"
kernel_version_label="Kernel Version"
uptime_label="Isanyoneup"
package_count_label="Package count"
shell_label="Shell"
wm_label="WM"
de_label="DE"
terminal_label="Terminal"
cpu_label="CPU"
memory_label="Memory"
soc_label="SOC"

# Generate a random pastel color
function random_pastel_color() {
  local red=$(shuf -i 175-255 -n 1)
  local green=$(shuf -i 175-255 -n 1)
  local blue=$(shuf -i 175-255 -n 1)
  printf "\033[48;2;%d;%d;%dm" "$red" "$green" "$blue"
}

# Script
username=$(whoami)
hostname=$(hostname)
os=$(uname -o)
kernel_version=$(uname -r)
uptime=$(awk '{print int($1/3600)}' /proc/uptime)
package_count=$(($(ls -d /usr/lib64/* 2>/dev/null | wc -l) + $(ls -d /usr/lib/* 2>/dev/null | wc -l)))
shell=$(basename "$SHELL")
wm=$(wmctrl -m 2>/dev/null | awk 'NR==1 {print $2}')
de=$(echo "$XDG_CURRENT_DESKTOP")
terminal=$(ps -o comm= -p "$(($(ps -o ppid= -p "$(($(ps -o sid= -p "$$")))")))")
cpu=$(awk -F':' '/model name/ {print $2; exit}' /proc/cpuinfo | xargs)
memory=$(awk '/MemTotal/ {printf "%.0f", $2/1024}' /proc/meminfo)
soc=$(cat /sys/devices/virtual/dmi/id/board_name)
distro=$(grep -w "NAME" /etc/os-release | cut -d'=' -f2 | tr -d '"')

logo=(
"                                "
"                       ▒█    ██▓"
" ▄▄▄      █     █░▄████▓██   ██▓"
"▒████▄   ▓█░ █ ░█▒██▀ ▀█▒██  ██▒"
"▒██  ▀█▄ ▒█░ █ ░█▒▓█    ▄▒██ ██░"
"░██▄▄▄▄██░█░ █ ░█▒▓▓▄ ▄██░ ▐██▓░"
" ▓█   ▓██░░██▒██▓▒ ▓███▀ ░ ██▒▓░"
" ▒▒   ▓▒█░ ▓░▒ ▒ ░ ░▒ ▒  ░██▒▒▒ "
"  ▒   ▒▒ ░ ▒ ░ ░   ░  ▒ ▓██ ░▒░ "
"  ░   ▒    ░   ░ ░      ▒ ▒ ░░  "
"      ░  ░   ░   ░ ░    ░ ░     "
"                 ░      ░ ░     "
"                        ░ ░     "
"                          ░     "
"                                "
)

sysinfo=(
"${username}@${hostname}"
"${os}"
"${distro}"
"${kernel_version}"
"${uptime}h"
"${package_count}"
"${shell}"
)

[ -n "$wm" ] && sysinfo+=("${wm}")
[ -n "$de" ] && sysinfo+=("${de}")

sysinfo+=(
"${terminal}"
"${cpu}"
"${memory} MB"
"${soc}"
)

bold_labels=(
"ID:"
"${os_label}:"
"${distro_label}:"
"${kernel_version_label}:"
"${uptime_label}:"
"${package_count_label}:"
"${shell_label}:"
)

[ -n "$wm" ] && bold_labels+=("${wm_label}:")
[ -n "$de" ] && bold_labels+=("${de_label}:")

bold_labels+=(
"${terminal_label}:"
"${cpu_label}:"
"${memory_label}:"
"${soc_label}:"
)

# Print the logo and system information side by side
for ((i = 0; i < ${#logo[@]}; i++)); do
  printf "%s      \033[1m%s\033[0m %s\n" "${logo[$i]}" "${bold_labels[$i]}" "${sysinfo[$i]}"
done

# Print the remaining system information with the correct indentation
for ((i = ${#logo[@]}; i < ${#bold_labels[@]}; i++)); do
  printf "      \033[1m%s\033[0m %s\n" "${bold_labels[$i]}" "${sysinfo[$i]}"
done

# Display pastel color tiles
# for ((i = 1; i <= 8; i++)); do
#  printf "%b" "$(random_pastel_color)     "
# done
# printf "\033[0m\n"

# display fortune
fortune
