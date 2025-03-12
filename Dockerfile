# Dockerfile
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Sao_Paulo

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential python3.10 python3-pip python3-dev python3-venv libgl1 libglib2.0-0 ffmpeg sox tzdata openssh-server git nano sudo \
    google-perftools libtcmalloc-minimal4 && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Cria o usuário
RUN useradd -m sduser && echo "sduser:1234" | chpasswd 

# Configura o SSH
RUN mkdir /var/run/sshd
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "AllowUsers sduser" >> /etc/ssh/sshd_config

RUN export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/libtcmalloc_minimal.so.4"

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /app
WORKDIR /app
RUN python3 -m venv venv

RUN sudo chown -R sduser:sduser /app
RUN sudo chmod -R 755 /app

COPY start_webui.sh /start_webui.sh
RUN chmod +x /start_webui.sh

EXPOSE 22 7860
CMD service ssh start && /start_webui.sh && tail -f /dev/null
