FROM microsoft/powershell:preview-ubuntu-16.04
RUN apt-get update \
    && apt install -y git \
    && cd /opt \
    && git clone https://github.com/sk82jack/DraftFantasyDashboard.git \
    && pwsh -c "Install-Module universaldashboard.community -Acceptlicense -Force"

CMD [ "pwsh","-command","& /opt/DraftFantasyDashboard/Start.ps1" ]
