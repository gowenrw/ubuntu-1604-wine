####################
# Base Image
####################
# ---------- Build From u16vnc image ----------
# ---------- Modify the FROM line below to point to your u16vnc image and comment out the other FROM line
#FROM alt_bier/u16vnc
# ---------- Build From Scratch image----------
# ---------- Uncomment FROM ubunti:16.04 below and comment out the other FROM line
FROM ubuntu:16.04

####################
# Image Labels
####################
LABEL maintainer="@alt_bier"
LABEL name="u16winevnc"
LABEL description="Ubuntu 16.04 with SSHD and VNC and WINE"
LABEL release-date="2018-04-03"
LABEL version="1.0"

####################
# Basic Environment
####################
ENV HOME=/root
WORKDIR $HOME
# Set Non-Interactive for image build
ENV DEBIAN_FRONTEND=noninteractive
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
# PASSWORD FOR SSH AND VNC IS SET HERE
ENV MYPSD=password
# X/VNC Environment Vars
# VNC port:5901 noVNC webport via http://IP:6901/?password=vncpassword
ENV TERM=xterm \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=$MYPASSWD \
    VNC_VIEW_ONLY=false \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901

####################
# Add some scripts
####################
ADD ./bin/*.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/*

####################
# Update Apt Repos
####################
RUN apt-get update -y

####################
# Install Basic Tools
####################
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
RUN install-tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

####################
# Install SSHD
####################
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
RUN install-sshd.sh

####################
# Install TigerVNC
####################
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
RUN install-tigervnc.sh

####################
# Install noVNC
####################
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
RUN install-no_vnc.sh

####################
# Install Xfce
####################
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
RUN install-xfce.sh
ADD ./bin/xfce/ $HOME/

####################
# Install Browser
####################
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
RUN install-firefox.sh
# Lots of issues with chrome but if you want to try it uncomment this:
#RUN install-chrome.sh

####################
# Install Wine
####################
RUN install-wine.sh

####################
# Install Cleanup
####################
RUN apt-get clean -y
# We don't want Non-Interactive set after install
ENV DEBIAN_FRONTEND=readline
# ---------- Build From u16vnc image ---------- Comment out the rest of this section
# ---------- Build From Scratch image---------- Uncomment the rest of this section
# We don't want the passwd here after install
ENV MYPSD=redacted

# Expose Ports
EXPOSE 22/tcp $VNC_PORT $NO_VNC_PORT

# Run the startme script which starts SSHD and VNC and checks for other run line commands
ENTRYPOINT ["startme.sh"]
CMD ["--tail-log"]
