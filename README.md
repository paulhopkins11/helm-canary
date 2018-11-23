# helm-canary

Sample project to demonstrate how to achieve canary deployments of helm charts. This uses simple load balancing of pods using a NodePort based on pod numbers.

The principle is to run multiple deployments. One for the release version and one for the canary version. Once the canary is validated as stable pods are scaled and the old release version pods removed.

This has been verified with Helm v2.11.0, Minikube v0.30.0 and Kubectl v1.11

# Prerequisites

Minikube up and running, Helm and Tiller installed

# Usage

## 1. Start the cluster

This will start a service and 4 "blue" pods. This will also output the configuration that will be used.

`> ./1_release_to_blue.sh`

## 2. Find out the service URL

```
➜  helm-canary git:(master) ✗ ./status.sh          
NAME                                              READY     STATUS    RESTARTS   AGE       IP            NODE
http-canary-deployment-canary-6c9f8dc59-vgdxm     1/1       Running   0          5h        172.17.0.13   minikube
http-canary-deployment-release-6fcf77d6f7-b46jr   1/1       Running   0          5h        172.17.0.15   minikube
http-canary-deployment-release-6fcf77d6f7-ghm5z   1/1       Running   0          5h        172.17.0.17   minikube
http-canary-deployment-release-6fcf77d6f7-p579s   1/1       Running   0          5h        172.17.0.16   minikube
http-canary-deployment-release-6fcf77d6f7-pj6kj   1/1       Running   0          5h        172.17.0.14   minikube
Service available at http://192.168.99.100:31708
```

Once you have a URL you can test the reponse in a browser or using curl
```
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31708 

<html onclick="window.location.href = '/die'" style='background:#0000FF'> Requested: /
 </html>%                                                                                                                                          
```

You can always find out the state of the pods with `kc get all -l category=microservices` or just the pods `kc get pods -l category=microservices`

## 3. Canary deploy red servers

`> ./2_canary_to_red.sh`

This will create a single canary pod and leave the release pods unchanged. You can watch until the new pod is running using `kc get pods -l category=microservices`

Multiple curl requests or browser refreshes will show the canary being called

```
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#0000FF'> Requested: /
 </html>%                                                                                                                                             
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#0000FF'> Requested: /
 </html>%                                                                                                                                             
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#FF0000'> Requested: /
 </html>%                                                                                                                                             
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#0000FF'> Requested: /
 </html>%                                                                                                                                             
```

## 4. Full red release

`> ./3_release_to_red.sh `

You can now watch until all pods are updated with red release pods.

```
➜  helm-canary git:(master) ✗ kc get pods -l category=microservices
NAME                                              READY     STATUS    RESTARTS   AGE
http-canary-deployment-release-6fcf77d6f7-6fl49   1/1       Running   0          30s
http-canary-deployment-release-6fcf77d6f7-6tp5j   1/1       Running   0          35s
http-canary-deployment-release-6fcf77d6f7-7sp9b   1/1       Running   0          48s
http-canary-deployment-release-6fcf77d6f7-f4ph5   1/1       Running   0          49s
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167     
<html onclick="window.location.href = '/die'" style='background:#FF0000'> Requested: /
 </html>%                                                                                                                                             
```

## 5. Canary back to blue

`> ./4_canary_to_blue.sh`

A single blue canary will now be created

```
➜  helm-canary git:(master) ✗ kc get pods -l category=microservices
NAME                                              READY     STATUS    RESTARTS   AGE
http-canary-deployment-canary-6c9f8dc59-q9bdv     1/1       Running   0          11s
http-canary-deployment-release-6fcf77d6f7-6fl49   1/1       Running   0          1m
http-canary-deployment-release-6fcf77d6f7-6tp5j   1/1       Running   0          1m
http-canary-deployment-release-6fcf77d6f7-7sp9b   1/1       Running   0          2m
http-canary-deployment-release-6fcf77d6f7-f4ph5   1/1       Running   0          2m
```

You can see it being called
```
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#FF0000'> Requested: /
 </html>%                                                                                                                                             
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#FF0000'> Requested: /
 </html>%                                                                                                                                             
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#FF0000'> Requested: /
 </html>%                                                                                                                                             
➜  helm-canary git:(master) ✗ curl http://192.168.99.100:31167
<html onclick="window.location.href = '/die'" style='background:#0000FF'> Requested: /
 </html>%                                                                                                                                             
```

## 6. Full blue release

You can now follow step 1. and return to a full blue release.

## 7. Delete

You can now delete the chart using `> ./delete.sh`

# Futher work

This POC could be extended to cover the following:

* Multiple charts - This will make it more representative of mulitple microservices within one chart being updated.
* Populating the number of replicas from the existing replica count.
