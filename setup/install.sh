#!/bin/sh

INSTALL_TMP="/run/install_tmp"
PSPLASH_TAG="v0.1.0-alpha1"

install_fbtft() {
  # check the file for existing parameters
  echo "dtparam=spi=on" >> /boot/firmware/config.txt
  echo "dtoverlay=fbtft,spi10,st7789v,bgr,reset_pin=27,dc_pin=25,rotate=180" >> /boot/firmware/config.txt
}

# Install touch driver, dtb overlay and packages to use as keyboard
install_touch() {
  apt-get install libudev libinput libxkbcommon-dev
}

install_backlight() {
  # Enable the backlight on power on / boot
  echo "gpio=18=op,dh" >> /boot/firmware/config.txt

  # Append for easy handling
  echo "alias blon='gpioset gpiochip0 18=1'" >> /home/openhabian/.bash_aliases 
  echo "alias bloff='gpioset gpiochip0 18=0'" >> /home/openhabian/.bash_aliases 


  # Install the init service to export the gpio18
  cd $INSTALL_TMP
  wget https://raw.githubusercontent.com/bitsoftat/openhab-statusdisplay/refs/heads/main/fs_overlay/etc/init.d/statusdisplay
  mv statusdisplay /etc/init.d
  chmod +x /etc/init.d/statusdisplay
}

# install_backlight_service() {}

install_xsplash() {
  cd $INSTALL_TMP
  
  # Download the psplash file with openHAB logo embedded
  wget https://github.com/mllapps/psplash-openhab/releases/download/$PSPLASH_TAG/psplash
  #wget https://github.com/mllapps/psplash-openhab/releases/download/$PSPLASH_TAG/psplash.sha256sum
  #sha256sum -c "psplash.sha256sum"
  mv psplash /usr/local/bin
  chmod +x /usr/local/bin/psplash

  
  wget https://github.com/mllapps/psplash-openhab/releases/download/$PSPLASH_TAG/psplash-write
  #wget https://github.com/mllapps/psplash-openhab/releases/download/$PSPLASH_TAG/psplash-write.sha256sum
  #sha256sum -c "psplash-write.sha256sum"
  mv psplash /usr/local/bin
  mv psplash-write /usr/local/bin
  chmod +x /usr/local/bin/psplash-write
}

install_xsplash_systemd() {
  cd $INSTALL_TMP
  wget https://raw.githubusercontent.com/mllapps/psplash-openhab/refs/tags/$PSPLASH_TAG/psplash-start.service

  mv psplash-start.service /lib/systemd/system
  chmod +x /lib/systemd/system/psplash-start.service
}

#install_openhab_command_whitelist() {}

enable_xsplash_systemd() {
  systemctl enable psplash-start
  systemctl start psplash-start
}

# Start and inform for root access required
if [ "$(id -u)" -ne 0 ]; then
  echo "This script need root access. Please run this script with sudo"
  exit 1
fi

echo "root access accepted."

mkdir -p $INSTALL_TMP

install_fbtft
install_touch
install_backlight
install_xsplash
install_xsplash_systemd
enable_xsplash_systemd
