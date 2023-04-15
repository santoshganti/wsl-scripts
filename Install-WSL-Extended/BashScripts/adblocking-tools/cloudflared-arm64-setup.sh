wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64
sudo mv -f ./cloudflared-linux-arm64 /usr/local/bin/cloudflared
sudo chmod +x /usr/local/bin/cloudflared
cloudflared -v

sudo useradd -s /usr/sbin/nologin -r -M cloudflared
sudo mv cloudflared.conf /etc/default/cloudflared

sudo chown cloudflared:cloudflared /etc/default/cloudflared
sudo chown cloudflared:cloudflared /usr/local/bin/cloudflared

sudo mv cloudflared.service /etc/systemd/system/cloudflared.service

sudo systemctl enable cloudflared
sudo systemctl start cloudflared
sudo systemctl status cloudflared
