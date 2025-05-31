#!/bin/sh

INSTALL_TMP="/run/install_tmp"
PSPLASH_TAG="v0.1.0-alpha1"

install_fbtft() {
  # check the file for existing parameters
  echo "dtparam=spi=on" >> /boot/firmware/config.txt
  echo "dtoverlay=fbtft,spi10,st7789v,bgr,reset_pin=27,dc_pin=25,rotate=180" >> /boot/firmware/config.txt
}

# install_touch() {}

install_backlight() {
  # Enable the backlight on power on / boot
  echo "gpio=18=op,dh" >> /boot/firmware/config.txt

  # Install the init service to export the gpio18
  
}

# install_backlight_service() {}

install_psplash() {
  cd $INSTALL_TMP
  
  # Download the psplash file with openHAB logo embedded
  wget https://github.com/mllapps/psplash-openhab/releases/download/$PSPLASH_TAG/psplash
  # sha256:8b66a57deee86b959605e66eb7a34b79fedd07a32da806dbbf208a2b7f379720

  wget https://github.com/mllapps/psplash-openhab/releases/download/$PSPLASH_TAG/psplash-write
  # sha256:c81d074cbf5970dda44fc5a0ac6071c342b25742607be02480caacf940da1644

  mv psplash /usr/local/bin
  mv psplash-write /usr/local/bin
  chmod +x /usr/local/bin/psplash
  chmod +x /usr/local/bin/psplash-write
}

install_psplash_systemd() {
  cd $INSTALL_TMP
  wget https://raw.githubusercontent.com/mllapps/psplash-openhab/refs/tags/$PSPLASH_TAG/psplash-start.service

  mv psplash-start.service /lib/systemd/system
  chmod +x /lib/systemd/system/psplash-start.service
}

#install_openhab_command_whitelist() {}

# Start and inform for root access required
if [ "$(id -u)" -ne 0 ]; then
  echo "This script need root access. Please run this script with sudo"
  exit 1
fi

echo "root access accepted."

mkdir -p $INSTALL_TMP

install_fbtft
install_backlight
install_psplash
install_psplash_systemd
