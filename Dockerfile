## Create Builder
FROM python:3.10-slim as builder
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
build-essential gcc sudo
RUN \
    sed -i /etc/sudoers -re 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^root.*/root ALL=(ALL:ALL) NOPASSWD: ALL/g' && \
    sed -i /etc/sudoers -re 's/^#includedir.*/## **Removed the include directive** ##"/g' && \
    echo "python ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers  && \
    echo "Customized the sudoers file for passwordless access to the python user!" 
WORKDIR /usr/app
RUN python -m venv /usr/app/venv
ENV PATH="/opt/venv/bin:$PATH"


## Create Image
FROM python:3.10-slim
USER root
RUN groupadd -g 999 python && useradd -u 999 -g python -G sudo -m -s /bin/bash python 
RUN echo "python user:";  su - python -c id
RUN mkdir /usr/app && chown python:python /usr/app
WORKDIR /usr/app
COPY --chown=python:python --from=builder /usr/app/venv ./venv
COPY --chown=python:python . .
RUN python -m pip install --upgrade pip

#ARG DISCORD_TOKEN
ENV TOKEN="$DISCORD_TOKEN"
#ARG DISCORD_GUILD
ENV GUILD="$DISCORD_GUILD"
USER 999
ENV PATH="/usr/app/venv/bin:$PATH"
CMD [ "python3"]
