FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive
USER root

# Update system
RUN apt-get update && apt-get upgrade -y

# Add en_US.UTF-8 and de_DE.UTF-8 locals
RUN apt-get install -y locales \
	&& localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
ENV LANG de_DE.utf8

# Install desktop environment and vncserver
RUN apt-get install -yq x11vnc xvfb xfce4 xfce4-goodies

# Configure vncserver
RUN mkdir ~/.vnc
RUN x11vnc -storepasswd portyTeX ~/.vnc/passwd
RUN echo "#!/bin/bash\nexec startxfce4" > ~/.xinitrc

# Install miktex (https://miktex.org/howto/install-miktex-unx)
RUN apt-get install -yq gnupg ca-certificates # needed for keyserver authentification
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D6BC243565B2087BC3F897C9277A7293F59E4889
RUN echo "deb http://miktex.org/download/ubuntu focal universe" > /etc/apt/sources.list.d/miktex.list
RUN apt-get update \
	&& apt-get install -yq miktex
RUN miktexsetup --shared=yes finish \
	&& initexmf --admin --set-config-value [MPM]AutoInstall=1

# Upgrade to full miktex implementation with all possible packages
RUN mpm --admin --update-db --package-level=basic --upgrade --update --verbose

# Install texstudio, jabref and inkscape
RUN apt-get install -yq texstudio jabref inkscape

# Create desktop shortcuts
RUN mkdir -p /root/Desktop
RUN cp /usr/share/applications/texstudio.desktop \
	/usr/share/applications/jabref.desktop \
	/root/Desktop/ \
	&& chmod +x /root/Desktop/*.desktop

# Creating script to update miktex and start texstudio
RUN mkdir ~/scripts
COPY ./scripts/update_miktex /root/scripts/
RUN chmod +x ~/scripts/update_miktex

# Create autostart configuration for script
RUN mkdir -p ~/.config/autostart
COPY ./scripts/update_miktex.desktop /root/.config/autostart

# Start vncserver
CMD x11vnc -usepw -create -forever