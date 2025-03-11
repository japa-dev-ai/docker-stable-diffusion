#!/bin/bash
su - sduser 
# Verifica se o diretório do volume está vazio
if [ -z "$(ls -A /app)" ]; then
    echo "Clonando repositório Git..."
    git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /app
    chmod +x /app/webui.sh
else
    echo "O diretório /app já contém dados. Nada será feito."
fi

echo "Iniciando o SSHD..."
/usr/sbin/sshd -D > /var/log/sshd_log.log 2>&1 &

echo "Iniciando o Programa Stable Diffusiuon..."
python3 /app/launch.py

tail -f /dev/null