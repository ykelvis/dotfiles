#!/bin/bash

if [[ "$EUID" != 0 ]]; then
    echo "not root, quitting...";
    exit;
fi

USERNAME=$1
SSHPORT=$2

useradd -m -g users -G root $USERNAME
passwd $USERNAME
mkdir -p /home/$USERNAME/.ssh/
curl "https://github.com/ykelvis.keys" > /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:users /home/$USERNAME/
chmod 0600 /home/$USERNAME/.ssh/authorized_keys

apt update&&apt install -y git tmux fail2ban shadowsocks-libev vnstat iftop 

mv /etc/ssh/sshd_config /etc/ssh/sshd_config_orig
cat << EOF > /etc/ssh/sshd_config
Port $SSHPORT
ListenAddress 0.0.0.0
PermitRootLogin no
LogLevel INFO
StrictModes yes
MaxAuthTries 6
MaxSessions 5
AuthorizedKeysFile .ssh/authorized_keys
PubkeyAuthentication yes
PasswordAuthentication no
PermitEmptyPasswords no
UsePAM yes
X11Forwarding yes
AcceptEnv LANG LC_*
EOF
systemctl reload sshd
systemctl restart sshd
echo "sshd service restarted."
