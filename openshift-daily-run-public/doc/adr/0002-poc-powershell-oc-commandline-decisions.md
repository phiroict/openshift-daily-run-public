# 2. poc-powershell-oc-commandline-decisions

Date: 2023-08-23

## Status

Accepted

## Context

At the moment we run a set of powershell scripts on the ARO jumphosts to get information about the current state of 
the cluster as well what upgrades are available. It is manual process that can only be executed by admins on the ARO cluster 
who have access to the jump hosts. It is also not part of our routine so they are run ad-hoc. 

## Decision

We want to capture these metrics in a regular tempo so we can make decisions on the data, and also on the 
trends that we view. 
To assess if this is working we decide on a PoC to see if our powershelll scripts will run and how we can define 
a secure set of credentials so the scripts run with minimal access. 
We limit the requirements by: 
- Build the container image with OSS elements to avoid time spend on getting the correct resources from RH 
- Run one single simple script to showcase the core elements 
- Use helm, argocd, deploymentscripts in a simple way that does not obey all requirements of an enterprise set. 


## Consequences

The PoC showcases that it is possible but will not include all requirements for security and result storage to 
limit the effort and use this PoC as as starting point of what we need. 
It is as such not fit  for purpose to use on an enterprise solution.