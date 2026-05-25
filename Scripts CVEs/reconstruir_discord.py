#!/usr/bin/env python3
"""
reconstruir_discord.py — Reconstrucción de conversaciones de Discord desde volcado de memoria
Uso: strings <pid_discord_renderer.dmp> | python3 reconstruir_discord.py

Ejemplo:
    strings pid.6324.dmp | python3 reconstruir_discord.py
    strings pid.6324.dmp | python3 reconstruir_discord.py | grep "termino"
    strings pid.6324.dmp | python3 reconstruir_discord.py > conversacion.txt

Requisitos: Python 3, strings (binutils)
"""

import sys, re, json

data = sys.stdin.read()
pattern = r'\{\"id\".*?\"components\":\s*\[\]\}'
matches = re.findall(pattern, data)

mensajes = []
for m in matches:
    try:
        obj = json.loads(m)
        ts = obj.get('timestamp','')[:19].replace('T',' ')
        user = obj['author']['username']
        content = obj.get('content','')
        if content:
            mensajes.append((ts, user, content))
    except:
        pass

for ts, user, content in sorted(set(mensajes)):
    print(f'[{ts}] {user}: {content}')
