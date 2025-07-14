#!/bin/bash
# -*- coding: utf-8 -*-
#
# Copyright (C) 2025 Ubiquity Press.
#
# Invenio-RDM-Records is free software; you can redistribute it and/or modify it
# under the terms of the MIT License; see LICENSE file for more details.
#
#  Usage:
#   ./console.sh -h|--help

set -e

# Defaults
NAMESPACE=$(kubectl config view --minify --output 'jsonpath={..namespace}')
NAMESPACE=${NAMESPACE:-default}
LABEL="app.kubernetes.io/component=terminal"
SHELL_COMMAND="bash"
KEEP=false

# Parse arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -n|--namespace) NAMESPACE="$2"; shift ;;
    -s|--shell) SHELL_COMMAND="$2"; shift ;;
    --keep) KEEP=true ;;
    -h|--help)
      echo "Usage: $0 [--namespace NAMESPACE] [--shell SHELL_COMMAND] [--keep]"
      echo ""
      echo "Options:"
      echo "  --namespace, -n   Namespace to run in (defaults to current context)"
      echo "  --shell, -s       Shell or command to execute (default: bash)"
      echo "  --keep            Do not scale down the pod after use"
      exit 0
      ;;
    *) echo "❌ Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

echo "📦 Namespace: $NAMESPACE"
echo "💡 Shell: $SHELL_COMMAND"
echo "🔁 Keep after exit: $KEEP"

echo "⏫ Scaling up terminal deployment..."
kubectl scale deployment -n "$NAMESPACE" -l "$LABEL" --replicas=1

echo "⏳ Waiting for pod to be ready..."
kubectl wait --for=condition=ready pod -n "$NAMESPACE" -l "$LABEL" --timeout=60s

POD=$(kubectl get pods -n "$NAMESPACE" -l "$LABEL" -o jsonpath='{.items[0].metadata.name}')

echo "🔗 Attaching to pod: $POD"
kubectl exec -n "$NAMESPACE" -it "$POD" -- "$SHELL_COMMAND"

if [ "$KEEP" = false ]; then
  read -rp "🚨 Do you want to scale down the pod? (y/N): " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "⏬ Scaling down terminal deployment..."
    kubectl scale deployment -n "$NAMESPACE" -l "$LABEL" --replicas=0
  else
    echo "✅ Pod left running."
  fi
else
  echo "✅ Pod left running."
fi
