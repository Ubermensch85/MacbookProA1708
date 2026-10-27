#!/usr/bin/env python3
import urllib.request
import json
import socket

ICON_MAP = {
    "113": "󰖙", "116": "󰖕", "119": "󰖐", "122": "󰖐",
    "143": "󰖑", "176": "󰖗", "266": "󰖗", "296": "󰖗",
    "302": "󰖖", "353": "󰖗",
}

def get_weather():
    # Timeout di 5 secondi per evitare il 100% CPU se la rete manca al boot
    try:
        url = "https://it.wttr.in/Perugia?format=j1"
        with urllib.request.urlopen(url, timeout=5) as response:
            data = json.loads(response.read().decode())
            curr = data['current_condition'][0]
            temp = curr['temp_C']
            code = curr['weatherCode']
            
            # Tenta di prendere la descrizione in italiano
            desc = curr.get('lang_it', [{'value': curr['weatherDesc'][0]['value']}])[0]['value']
            icon = ICON_MAP.get(code, "")
            
            out = {
                "text": f"{icon} {temp}°C",
                "tooltip": f"{desc}\nUmidità: {curr['humidity']}%",
                "class": "weather"
            }
            return json.dumps(out)
    except Exception:
        # Se non c'è rete al boot, restituisce un JSON neutro e chiude il processo
        return json.dumps({"text": "󰖪 --°C", "tooltip": "Connessione in corso..."})

if __name__ == "__main__":
    print(get_weather())
