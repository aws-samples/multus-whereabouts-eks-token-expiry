## Multus And Whereabouts Token Expiry Work-Around

**Summary Of Issue:** The BoundServiceAccountTokenVolume feature is enabled by default in Kubernetes version 1.21 and later. 

This feature improves the security of service account tokens by allowing workloads running on Kubernetes to request JSON web tokens that are audience, time, and key bound.

What this means is that PODs that are not using the required SDK versions/procedure which requires token for communicating with the Kubernetes API will not be able to carry out operations that are dependent on the Kubernetes API server. So far Multus and whereabouts are the ones that have been identified.

Repo contains a work-around that makes use of a side-car that will request token update every hour.

Both multus and whereabouts have their dedicated folder that contains the script, Dockerfile and installation manifests.

The manifests has the sidecar with the updated RBAC settings also.

N.B - You will have to build and push the container images and then update this in the multus/whereabouts daemonset manifests. Below can be used to build and push images to your ECR

#### 													How To Build The Container Side-car Images

```
cd multus/

docker build -t container_registry/multus-token-renew-amd:v0.1 .

cd ../whereabouts/

docker build -t container_registry/whereabouts-token-renew-amd:v0.1 .

docker push container_registry/multus-token-renew-amd:v0.1

docker push container_registry/whereabouts-token-renew-amd:v0.1
```

Replace container_registry with your ECR details