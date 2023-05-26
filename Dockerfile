FROM ubuntu

ENV MY_USER=coder

RUN apt-get update
RUN apt-get install sudo
RUN useradd -ms /bin/bash $MY_USER -p "$(openssl passwd -1 g0ldF!sh)"

# USER $MY_USER
WORKDIR /home/$MY_USER


COPY fix_docker_user.sh /bin/fix_docker_user.sh
ENTRYPOINT ["/bin/fix_docker_user.sh"]

