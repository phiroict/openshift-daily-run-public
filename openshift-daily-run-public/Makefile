container_version="0.0.1.20230811"
build_container:
	podman build -t phiroict/daily-scan:$(container_version) .
run_container:
	podman run --rm -it phiroict/daily-scan:$(container_version) bash
release_container:
	podman tag phiroict/daily-scan:$(container_version) quay.io/philip_rodrigues_schs/daily-scan:$(container_version)
	podman push quay.io/philip_rodrigues_schs/daily-scan:$(container_version)
helm_package:
	cd deploy/ocp && helm package oc-scanner
helm_install:
	cd deploy/ocp && helm install oc-scanner ./oc-scanner-0.1.0.tgz
helm_update:
	cd deploy/ocp && helm upgrade oc-scanner ./oc-scanner-0.1.0.tgz
helm_template:
	cd deploy/ocp && helm template oc-scanner > release.yaml
	cd deploy/ocp && oc apply -f release.yaml && rm ./release.yaml
helm_delete:
	-cd deploy/ocp && helm delete oc-scanner
pause:
	sleep 10
helm_bounce: helm_delete helm_package pause helm_install
helm_render:
	cd deploy/ocp && helm template oc-scanner
argo_login:
	argocd login openshift-gitops-server-openshift-gitops.apps-crc.testing --username admin --password $(oc -n openshift-gitops get secret openshift-gitops-cluster -o jsonpath="{.data.admin\.password}"  | base64 -d)
argo_add_repo:
	argocd repo add git@github.com:phiroict/sx-openshift-daily-running-poc.git --ssh-private-key-path  ~/.ssh/id_ed_np
argo_add_application:
	argocd app create oc-scanner --repo git@github.com:phiroict/sx-openshift-daily-running-poc.git --path deploy/ocp/oc-scanner --dest-namespace platform-monitoring --dest-server https://kubernetes.default.svc
argo_sync:
	argocd app sync oc-scanner --force