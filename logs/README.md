# Logs — evidências geradas pelo serviço atacado

Estes registros comprovam, do lado do servidor, o ataque sofrido e a ação das
defesas. Gere-os nas VMs e salve nesta pasta.

## 1. Tentativas de login falhas durante o ataque (na VM VÍTIMA)

```bash
sudo grep "Failed password" /var/log/auth.log > auth-ataque.log
# Em Ubuntu que usa journald:
# sudo journalctl -u ssh | grep "Failed password" > auth-ataque.log
```

## 2. Registro do banimento pelo fail2ban (na VM VÍTIMA)

```bash
sudo grep "Ban" /var/log/fail2ban.log > fail2ban-ban.log
```

## 3. Estado da jail com o IP banido (na VM VÍTIMA)

```bash
sudo fail2ban-client status sshd > fail2ban-status.txt
```
