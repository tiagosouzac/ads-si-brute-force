# Segurança de Credenciais e Autenticação — Ataque e Defesa em SSH

Atividade prática de segurança da informação: simulação de um ataque de força
bruta contra um serviço SSH em ambiente isolado e, em seguida, implementação das
camadas de defesa que tornam o ataque inviável.

> **Aviso ético.** Todo o conteúdo foi produzido em um laboratório virtual
> isolado, composto por máquinas virtuais sob meu controle, exclusivamente para
> fins educacionais. Nenhum sistema de terceiros foi alvo.

## Ambiente

- **Atacante:** Kali Linux (VM) — ferramentas Hydra e John the Ripper.
- **Vítima/Alvo:** Ubuntu Server (VM) — serviço OpenSSH na porta 22.
- **Rede:** segmento virtual isolado entre as duas VMs.

## Estrutura do repositório

```
.
├── README.md                       # este arquivo
├── ataque/
│   ├── 01-brute-force-hydra.sh     # ataque online (descoberta de senha)
│   ├── 02-crack-offline-john.sh    # ataque offline (quebra de hashes)
│   └── wordlists/demo.txt          # lista controlada usada na demonstração
├── defesa/
│   ├── fail2ban/jail.local         # config do bloqueio automático
│   ├── 2fa/                        # config e passo a passo do 2FA
│   └── politicas-de-defesa.md      # descrição detalhada das políticas
├── logs/                           # evidências geradas pelo serviço atacado
└── evidencias/                     # capturas / link do vídeo
```

## Resumo das fases

1. **Ataque.** O Hydra testa senhas contra três usuários de complexidade
   diferente: a senha trivial cai em ~1 s, a intermediária resiste mais, e a
   forte não é encontrada — evidenciando a importância de senhas robustas.
   O John demonstra o equivalente offline, quebrando hashes do `/etc/shadow`.

2. **Defesa.** Duas camadas são ativadas no alvo: o **fail2ban**, que bane o IP
   atacante após poucas tentativas falhas, e o **2FA (TOTP via PAM)**, que passa
   a exigir um código do celular além da senha. O mesmo ataque que antes
   funcionava passa a ser barrado. Detalhes em
   [`defesa/politicas-de-defesa.md`](defesa/politicas-de-defesa.md).

## Como reproduzir

```bash
# Na máquina ATACANTE (Kali), a partir da pasta ataque/:
./01-brute-force-hydra.sh

# Defesa: aplicar os arquivos da pasta defesa/ na VM VÍTIMA e repetir o ataque.
```
