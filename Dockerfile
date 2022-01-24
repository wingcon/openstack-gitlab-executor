# based on https://github.com/RedHatQE/openstack-gitlab-executor
ARG GITLAB_RUNNER_VERSION=latest

FROM ubuntu:20.04

ARG GITLAB_RUNNER_VERSION

RUN apt-get update && \
    apt-get install -y git-core ncurses-bin curl python3 python3-pip python3-venv && \
    apt-get clean -y

RUN curl -LJO "https://gitlab-runner-downloads.s3.amazonaws.com/${GITLAB_RUNNER_VERSION}/deb/gitlab-runner_amd64.deb" -o /gitlab-runner_amd64.deb && \
    dpkg -i /gitlab-runner_amd64.deb && \
    rm /gitlab-runner_amd64.deb

RUN /usr/bin/gitlab-runner --version

ENV HOME=/home/gitlab-runner \
    VENV=/openstack_driver_venv

ENV PATH="$VENV/bin:$PATH"

WORKDIR $HOME

COPY requirements.txt $HOME/

RUN python3.8 -m venv $VENV && \
    pip install -r requirements.txt

COPY cleanup.py env.py config.sh prepare.py run.py start.sh prepare-vm.sh $HOME/

RUN chgrp -R 0 $HOME && \
    chmod +x cleanup.py config.sh prepare.py run.py start.sh && \
    chmod -R g=u $HOME

USER 1001

CMD ["./start.sh"]
