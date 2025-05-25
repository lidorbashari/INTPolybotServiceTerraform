#!/bin/bash
set -e

# These instructions are for Kubernetes v1.32.
KUBERNETES_VERSION=v1.32

sudo apt-get update
sudo apt-get install jq unzip ebtables ethtool -y

# install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Enable IPv4 packet forwarding. sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install cri-o kubelet kubeadm kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/$KUBERNETES_VERSION/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/prerelease:/main/deb/ /" | sudo tee /etc/apt/sources.list.d/cri-o.list

sudo apt-get update
sudo apt-get install -y software-properties-common apt-transport-https ca-certificates curl gpg
sudo apt-get install -y cri-o kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# start the CRIO container runtime and kubelet
sudo systemctl start crio.service
sudo systemctl enable --now crio.service
sudo systemctl enable --now kubelet

# disable swap memory
swapoff -a

# add the command to crontab to make it persistent across reboots
(crontab -l ; echo "@reboot /sbin/swapoff -a") | crontab -

sudo kubeadm init

JOIN_CMD=$(kubeadm token create --print-join-command)

# שמירת הפקודה ל-S3 (יש לוודא שה-EC2 role כולל הרשאות S3 כתיבה)
echo "$JOIN_CMD" > /root/join_command.sh
aws s3 cp /root/join_command.sh s3://lidor-project-bucket-tf/join-commands/join_command.sh

# סיום הגדרות, למשל יצירת קובץ kubeconfig ל-admin
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# התקן Calico או CNI אחר (אפשר להוסיף כאן)
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/calico.yaml

aws s3 cp s3://lidor-project-bucket-tf/join-commands/join_command.sh /root/join_command.sh

# תן הרשאות ריצה
chmod +x /root/join_command.sh

# הרץ את הפקודה להצטרפות ל-cluster
sudo /root/join_command.sh