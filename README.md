# openHAB Status Display

## How to install?

```
wget -qO- https://raw.githubusercontent.com/bitsoftat/openhab-statusdisplay/refs/heads/main/setup/install.sh | sh
```

run with sudo

```
wget -qO- https://raw.githubusercontent.com/bitsoftat/openhab-statusdisplay/refs/heads/main/setup/install.sh | sudo sh
```

## Systemd concept

1. install the start script on /etc/init.d/statusdisplay
2. Add the .service file to /etc/systemd/system
3. Enable the service with

```
sudo systemctl enable statusdisplay.service
```
