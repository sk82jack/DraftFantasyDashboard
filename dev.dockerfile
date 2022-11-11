FROM mcr.microsoft.com/powershell:latest
RUN apt-get update \
    && apt install -y git \
    && pwsh -c "Install-Module universaldashboard.community -Acceptlicense -Force"
ADD . /opt/DraftFantasyDashboard
CMD [ "pwsh","-command","& /opt/DraftFantasyDashboard/Start.ps1" ]
