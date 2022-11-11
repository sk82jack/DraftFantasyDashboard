FROM mcr.microsoft.com/powershell:latest
RUN apt-get update \
    && apt install -y git \
    && cd /opt \
    && git clone https://github.com/sk82jack/DraftFantasyDashboard.git \
    && pwsh -c "Install-Module universaldashboard.community -Acceptlicense -Force"

CMD [ "pwsh","-command","& /opt/DraftFantasyDashboard/Start.ps1" ]
