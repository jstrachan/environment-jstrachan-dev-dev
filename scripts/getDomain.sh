#!/bin/bash
kubectl get svc nginx-nginx-ingress-controller  -n nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null && echo .nip.io || echo replaceme.io