#!/bin/bash
cd /home/ec2-user/

# Download required files
wget https://raw.githubusercontent.com/rfmsec/Learning/master/kind-config.yaml
wget https://github.com/rfmsec/Learning/raw/master/flask-kubeapi.zip

# Add kubeconfig to bashrc
echo 'export KUBECONFIG="/home/ec2-user/.kube/config"' >> /etc/bashrc

# Install docker
yum install -y docker
service docker start
chkconfig docker on

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
chmod +x ./kind && mv ./kind /usr/local/bin/
/usr/local/bin/kind create cluster --config kind-config.yaml

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install helm and unzip chart files
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
unzip flask-kubeapi.zip

# Sleep 2 minutes and install helm chart
sleep 120
helm install flask-kubeapi ./flask-kubeapi