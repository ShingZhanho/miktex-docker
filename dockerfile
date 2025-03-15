FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

ARG miktex_home=/var/lib/miktex
ARG miktex_work=~/work

COPY ./apt-packages.txt .

RUN     apt-get update \
    &&  apt-get install -y --no-install-recommends $(cat apt-packages.txt)
    &&  rm apt-packages.txt

RUN curl -fsSL https://miktex.org/download/key | tee /usr/share/keyrings/miktex-keyring.asc > /dev/null \
    && echo "deb [signed-by=/usr/share/keyrings/miktex-keyring.asc] https://miktex.org/download/ubuntu jammy universe" | tee /etc/apt/sources.list.d/miktex.list

RUN     apt-get update -y \
    &&  apt-get install -y --no-install-recommends miktex

RUN     miktexsetup finish \
    &&  initexmf --set-config-value=[MPM]AutoInstall=1 \
    &&  miktex packages update

VOLUME [ "${miktex_home}" ]

WORKDIR ${miktex_work}

ENV PATH="${miktex_home}/bin:${PATH}"

CMD [ "bash" ]