# flask-kubeapi
Kubernetes API access using Flask

1. The Jenkinsfile is a POC file, it cannot be used without adding credentials to jenkins with id "dockerhub_id"
2. In order to deploy using helm, download the "HELM" directory and its content and use helm install as follows:
  <br>a. helm install \<installation name\> \<chart files location\>
  <br>eg: helm install flask-kubeapi ./flask-kubeapi
