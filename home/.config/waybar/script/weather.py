#!/usr/bin/env python3
import requests
import json
import sys

# Coordinate Perugia
LAT = "43.11"
LON = "12.39"

# API OpenMeteo: Leggera, gratuita, JSON nativo
URL = f"https://api.open-meteo.com/v1/forecast?latitude={LAT}&longitude={LON}&current_weather=true"

try:
    # Timeout breve: se non risponde subito, lascia perdere
    response = requests.get(URL, timeout=5)
    response.raise_for_status()
    data = response.json()
    
    current = data['current_weather']
    temp = current['temperature']
    code = current['weathercode']
    
    # Mappa minimale codici WMO -> Testo/Icona
    # 0: Sereno, 1-3: Nuvoloso, 45-48: Nebbia, 51-67: Pioggia, 71-77: Neve, >80: Temporale
    if code == 0:
        condition = "Sereno"
        icon = "☀️" 
    elif code <= 3:
        condition = "Nuvoloso"
        icon = "☁️"
    elif code <= 48:
        condition = "Nebbia"
        icon = "🌫"
    elif code <= 67:
        condition = "Pioggia"
        icon = "🌧"
    elif code <= 77:
        condition = "Neve"
        icon = "❄️"
    else:
        condition = "Temporale"
        icon = "⛈"

    out_data = {
        "text": f"{temp}°",
        "tooltip": f"Perugia: {condition}\nVento: {current['windspeed']} km/h",
        "class": "weather",
        "alt": icon 
    }

    print(json.dumps(out_data))

except Exception:
    # In caso di errore non stampiamo nulla o un'icona neutra per non rompere la barra
    print(json.dumps({"text": "...", "tooltip": "Offline"}))
