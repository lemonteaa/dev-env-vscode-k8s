FROM ubuntu:latest
ARG cdr_version
RUN apt-get update && apt-get install -y curl sudo
RUN useradd -ms /bin/bash coder && adduser coder sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER coder
WORKDIR /home/coder
RUN curl -fOL https://github.com/coder/code-server/releases/download/v${cdr_version}/code-server_${cdr_version}_amd64.deb && sudo dpkg -i code-server_${cdr_version}_amd64.deb && rm code-server_${cdr_version}_amd64.deb
RUN sudo apt-get install -y npm && sudo npm install -g n
RUN sudo n stable

ENV PASSWORD=tobechanged
EXPOSE 8080
CMD ["code-server", "--bind-addr", "0.0.0.0:8080"]
