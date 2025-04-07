FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV WINEPREFIX=/config/.wine

# התקנת תלותיות
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    curl \
    unzip \
    gnupg2 \
    xvfb \
    wine64 \
    wine32 \
    libwine:i386 \
    libwine \
    winbind \
    cabextract \
    fonts-freefont-ttf \
    python3 \
    python3-pip \
    locales \
    && rm -rf /var/lib/apt/lists/*

# הגדרת locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# אתחול Wine
RUN wineboot --init || true

# התקנת Mono
RUN mkdir -p /config/.wine/drive_c/ && \
    curl -o /config/.wine/drive_c/mono.msi https://dl.winehq.org/wine/wine-mono/8.0.0/wine-mono-8.0.0-x86.msi && \
    xvfb-run -a wine msiexec /i /config/.wine/drive_c/mono.msi /qn

# העתקת קבצי MetaTrader 5 שכבר פרוסים
COPY MetaTrader5 /config/.wine/drive_c/Program\ Files/MetaTrader\ 5/

# העתקת סקריפט הפעלה
COPY start.sh /start.sh
RUN chmod +x /start.sh

# התקנת mt5linux אם נדרש
RUN pip3 install mt5linux || true

EXPOSE 8001

CMD ["bash", "/start.sh"]
