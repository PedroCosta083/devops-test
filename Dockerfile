# Utilizando a versão mais recente do Jenkins com JDK 17
FROM jenkins/jenkins:2.462.2-jdk17

# Mudando para o usuário root para instalar dependências
USER root

# Atualizando os pacotes e instalando o Python 3 e o pip
RUN apt-get update && apt-get install -y lsb-release python3-pip

# Baixando a chave GPG do Docker
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg

# Adicionando o repositório do Docker à lista de fontes
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Atualizando os pacotes novamente e instalando o Docker CLI
RUN apt-get update && apt-get install -y docker-ce-cli

# Retornando ao usuário jenkins
USER jenkins

# Instalando os plugins do Jenkins, incluindo as dependências ausentes
RUN jenkins-plugin-cli --plugins \
  "blueocean:1.27.5" \
  "docker-workflow:1.29" \
  "json-path-api:2.8.0-5.v07cb_a_1ca_738c" \
  "token-macro:400.v35420b_922dcb_" \
  "blueocean-pipeline-api-impl:1.27.16" \
  "favorite:2.221.v19ca_666b_62f5"
