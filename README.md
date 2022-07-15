# dev-env-vscode-k8s
Development enviornment in k8s with vscode

Notes: This repo and the codes are specifically designed to be used within a okteto k8s namespace as it leverage the auto-ingress feature.

## Explanation

This repo consists of:

### A Fat Docker Image for Development

The docker image is published to github container registry. It runs the remote/server version of VSCode, and comes with some basic development tools pre-installed:
- NodeJS (`npm` and `node` via `n`)
- `kubectl` and `ytt`

The user `coder` is setup with passwordless sudo access. (However, this won't work in clusters that restrict privelege escalation. See section below for details)

### A k8s manifest to deploy a working remote dev environment

It deploys a Persistent Volume Claim, mounted to the home directory of `coder`. VSCode is exposed through port 8080.

Due to okteto restricting privelege escalation, we specially designated the container to run as `root`. The intended usage is to `su coder` once you're in for user level work, but `exit` the shell back to `root` user in case you need root access (eg `apt install`ing your own softwares)

### Scripts to automatically open port

The `/opt/open-port` folder in the docker image contain shell script to automatically expose a port. This is handy in a typical remote development setup since you do want to be able to preview it (esp. frontend app) over your own browser.

How it's done: We prepared some templated k8s manifest file that will add additional port in the service, and then add an ingress. The shell script call `ytt` to perform the variable substitution, then call `kubectl` to apply/patch.
