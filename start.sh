#!/bin/bash

mt5file='/config/.wine/drive_c/Program Files/MetaTrader 5/terminal64.exe'
WINEPREFIX='/config/.wine'
wine_executable="wine"
mt5server_port="8001"

if [ -e "$mt5file" ]; then
    echo "Running MetaTrader 5..."
    xvfb-run -a $wine_executable "$mt5file" /portable &
else
    echo "MetaTrader 5 not found. Please check your image."
fi

echo "Starting mt5linux server..."
python3 -m mt5linux --host 0.0.0.0 -p $mt5server_port -w $wine_executable python.exe &
