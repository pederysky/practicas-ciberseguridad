# Adquisición de evidencias en vivo


# Auto-elevación a administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.SecurityIdentifier]"S-1-5-32-544")) {
    Start-Process PowerShell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

$fecha = Get-Date -Format "yyyy-MM-dd_HH-mm"
$salida = "C:\forense_$fecha"
New-Item -ItemType Directory -Path $salida

# Fecha y hora de inicio
get-date > "$salida\Fechayhorainicio.txt"
get-date -uformat "%d/%m/%Y %T UTC%Z" >> "$salida\Fechayhorainicio.txt"

# Usuarios
net user > "$salida\usuarios.txt"
Get-LocalUser >> "$salida\usuarios.txt"

# Sesiones abiertas
quser > "$salida\sesiones.txt"

# Conexiones de red
netstat -an > "$salida\ConexionesActivas.txt"
netstat -anob > "$salida\AplicacionesPuertosAbiertos.txt"
ipconfig /all > "$salida\EstadoDeLaRed.txt"
nbtstat -S > "$salida\ConexionesNetBIOS.txt"
net sessions > "$salida\SesionesRemotas.txt"
ipconfig /displaydns > "$salida\DNSCache.txt"
arp -a > "$salida\ArpCache.txt"
route print > "$salida\rutas.txt"

# Procesos
tasklist /v > "$salida\procesos.txt"
Get-Process >> "$salida\procesos.txt"

# Servicios
sc.exe query > "$salida\ServiciosEnEjecucion.txt"
Get-Service | Where-Object {$_.Status -eq "Running"} >> "$salida\ServiciosEnEjecucion.txt"

# Tareas programadas
schtasks > "$salida\TareasProgramadas.txt"

# Histórico
doskey /history > "$salida\HistoricoCMD.txt"
Get-History > "$salida\HistoricoPowerShell.txt"

# Unidades y recursos compartidos
net use > "$salida\UnidadesMapeadas.txt"
net share > "$salida\CarpetasCompartidas.txt"

# Info del sistema
systeminfo > "$salida\sysinfo.txt"

# Fecha y hora de fin
get-date > "$salida\Fechayhorafin.txt"
get-date -uformat "%d/%m/%Y %T UTC%Z" >> "$salida\Fechayhorafin.txt"

Write-Host "Evidencias guardadas en $salida" -ForegroundColor Green
