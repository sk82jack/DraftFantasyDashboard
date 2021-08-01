FROM mcr.microsoft.com/powershell:7.0.0-preview.5-ubuntu-18.04
RUN apt-get update \
    && apt install -y git \
    && pwsh -c "Install-Module universaldashboard.community -Acceptlicense -Force"
ADD . /opt/DraftFantasyDashboard
CMD [ "pwsh","-command","& /opt/DraftFantasyDashboard/Start.ps1" ]
