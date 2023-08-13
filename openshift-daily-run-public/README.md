# PoC for running processes from openshift


Proof of concept for the use of powershell scripts running on the cluster itself. 
# Goals 
How to create a pod that runs the oc commandline and can run powershell scripts that we are using for our
daily checks at the company we work at. 
- Create a container 
- Upload container to the `quay.io` repository
- Create a helm chart for deployment
- Build scripts by Makefiles 
- Run instance on local Openshift. 
- Check cronjobs 
- Capture the generated text and place it somewhere. 



# Setup 

Build flow: 
![system-daily-reporting.png](docs%2Fsystem-daily-reporting.png)

The dockerfile creates an image with `oc`, `Powershell`, and `bash` installed
The helmchart creates the systemaccount and the roles as well as the cronjob, by design the `oc` commandline
will use the systemaccount in the pod that has the ClusterRole defined to have access to the internal resources. 
In this PoC it will have list rights of nodes and the showcase shows that it will be able to print the nodes. 


Runs helm charts to create the stack. 

The secret for accessing the quay repo needs to be manually added. 
Add this here
deploy/ocp/oc-scanner/templates/secret-quay.yaml
With this content
```yaml
kind: Secret
apiVersion: v1
metadata:
  name: secret-quay
  namespace: {{ .Values.namespace }}
data:
  .dockerconfigjson: >-
    <your key here>
type: kubernetes.io/dockerconfigjson

```

# Build

The build steps are placed in the Makefile.

Log in: 
```bash
podman login quay.io
```
Also change the `release_container` tag name to one of your account. 

In sequence: 
```bash
make build_container
make release_container # You need to be logged in to your account.
make helm_install # Deploys to the cluster you need to be logged in to the kubernetes / openshift cluster. 
```

# GitOps 

Install the openshift-gitops operator and create a cluster 

Get the secret from the `openshift-gitops-cluster` secret from the `openshift-gitops`

Some rights issues as it needs to be set in the cloud-controller-manager cluster role who are overridden by the operator. 

