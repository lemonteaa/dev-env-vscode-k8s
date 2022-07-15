FROM ubuntu:latest
ARG cdr_version
ARG vscode_pwd
RUN apt-get update && apt-get install -y curl sudo
RUN useradd -ms /bin/bash coder && adduser coder sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER coder
WORKDIR /home/coder
RUN curl -fOL https://github.com/coder/code-server/releases/download/v${cdr_version}/code-server_${cdr_version}_amd64.deb && sudo dpkg -i code-server_${cdr_version}_amd64.deb && rm code-server_${cdr_version}_amd64.deb
RUN sudo apt-get install -y npm && sudo npm install -g n
RUN sudo n stable

RUN sudo apt-get install -y apt-transport-https ca-certificates curl
RUN sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
RUN sudo apt-get update && sudo apt-get install -y kubectl

RUN curl -fOL https://github.com/vmware-tanzu/carvel-ytt/releases/download/v0.41.1/ytt-linux-amd64 && chmod a+x ytt-linux-amd64 && sudo mv ytt-linux-amd64 /usr/bin/ytt

COPY open-port/ /opt/open-port/

ENV PASSWORD=${vscode_pwd}
EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
