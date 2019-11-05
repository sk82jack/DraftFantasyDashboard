FROM mcr.microsoft.com/powershell:7.0.0-preview.5-ubuntu-18.04
RUN apt-get update \
    && apt install -y git \
    && cd /opt \
    && git clone https://github.com/sk82jack/DraftFantasyDashboard.git \
    && pwsh -c "Install-Module universaldashboard.community -Acceptlicense -Force"

CMD [ "pwsh","-command","& /opt/DraftFantasyDashboard/Start.ps1" ]
