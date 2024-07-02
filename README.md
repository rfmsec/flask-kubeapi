# flask-kubeapi
Kubernetes API access using Flask

The repo contins:
1. Dockerfile as the base of the application.
2. server.py -A very simple flask app exposing routes to get data from the k8s cluster using kubeapi.
3. HELM chart to deploy the application, includes a service to allow API access, and configured HPA.
4. A simple Jenkinsfile, demonstrating simple CI/CD pipeline, pull the code, create a docker image with the app, deploy the helm charts, push the image to docker hub, and clean up.
5. setup-kind.sh - A wrapper to wrap things up, deploys the entire thing... (Without using Jenkins)

* The Jenkinsfile is a POC file, it cannot be used without adding credentials to jenkins with id "dockerhub_id"
*  In order to deploy using helm, download the "HELM" directory and its content and use helm install as follows:
  <br>a. helm install \<installation name\> \<chart files location\>
  <br>eg: helm install flask-kubeapi ./flask-kubeapi
