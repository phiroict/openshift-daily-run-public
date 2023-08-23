FROM archlinux:base-20230723.0.166908
########################################################################################################################
# Upgrade OS to the latest versions
RUN pacman -Syu --noconfirm --needed
########################################################################################################################
# Install the components we need for the tooling
RUN pacman -S --needed --noconfirm base-devel git go fakeroot wget
########################################################################################################################
# Create a user we can run the builders from
RUN useradd -m -g users builder
RUN useradd -m -g users runner
RUN echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
########################################################################################################################
## Install tools #######################################################################################################
#  YAY
RUN mkdir -p /yay
RUN chown builder -R /yay
USER builder
RUN cd /yay && git clone  https://aur.archlinux.org/yay.git && cd yay && sudo -u builder makepkg -si --noconfirm
#  Openshift client (oc) ###############################################################################################
RUN yes | sudo -u builder yay -S openshift-client-bin --save --answerclean No --answerdiff No
USER root
#  Powershell and ancillaries ##########################################################################################
RUN mkdir /powershell
WORKDIR /powershell
RUN wget https://github.com/PowerShell/PowerShell/releases/download/v7.3.6/powershell-7.3.6-linux-x64.tar.gz
RUN tar zxfv powershell-7.3.6-linux-x64.tar.gz
RUN mv ./* /usr/local/bin/
RUN yes | sudo -u builder yay -S dotnet-install --save --answerclean No --answerdiff No
RUN dotnet-install
## Move tools into the paths to be used or set environments to use the components  #####################################
 
RUN mv /root/.dotnet /home/runner
RUN chown -R runner /home/runner/.dotnet
ENV DOTNET_ROOT=/home/runner/.dotnet
RUN pwsh --version
#  Copy over scripts for the daily scripts #############################################################################
RUN mkdir -p /scripts
WORKDIR /scripts
COPY scripts/* .
RUN chown -R runner /scripts
# Default running container, can be overridden #########################################################################
USER runner
CMD ["pwsh", "./get-node-info.ps1"]
