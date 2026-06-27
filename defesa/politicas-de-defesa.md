# Políticas de Defesa Implementadas

Este documento descreve as camadas de proteção configuradas no servidor SSH da
VM vítima para mitigar o ataque de força bruta demonstrado na fase ofensiva.
As defesas são independentes e complementares: a primeira impede que o ataque
seja executado em volume; a segunda anula o valor de uma senha eventualmente
descoberta.

## Camada 1 — Bloqueio automático de contas (fail2ban)

**Mecanismo.** O fail2ban monitora os registros de autenticação do SSH e, ao
identificar repetidas tentativas de login malsucedidas vindas de um mesmo
endereço IP, insere uma regra de firewall que bloqueia esse endereço por um
período determinado.

**Parâmetros aplicados** (arquivo `fail2ban/jail.local`):

| Parâmetro  | Valor | Função                                                        |
|------------|-------|---------------------------------------------------------------|
| `maxretry` | 3     | Número de falhas que dispara o banimento                      |
| `findtime` | 300 s | Janela de tempo em que as falhas são contadas                 |
| `bantime`  | 600 s | Duração do bloqueio do IP no firewall                         |

**Efeito sobre o ataque.** Um ataque de dicionário precisa testar centenas ou
milhares de senhas. Com o banimento após 3 tentativas, o atacante é cortado da
rede antes de conseguir testar senhas em quantidade suficiente, o que torna a
força bruta inviável em termos de tempo.

**Evidência.** Ver `../logs/fail2ban-ban.log`: o IP da máquina atacante passa a
constar na lista de banidos durante a execução do ataque.

## Camada 2 — Autenticação de dois fatores (2FA / MFA)

**Mecanismo.** Além da senha, o login passa a exigir um segundo fator: um código
temporário (TOTP) gerado por um aplicativo autenticador no celular do usuário,
que se renova a cada poucos segundos. A integração foi feita pelo módulo PAM
`pam_google_authenticator.so`, acoplado ao fluxo de autenticação do SSH.

**Configuração** (arquivos em `2fa/`):
- `pam-sshd.txt` — linha adicionada em `/etc/pam.d/sshd`.
- `sshd_config-trecho.txt` — diretivas habilitadas em `/etc/ssh/sshd_config`.
- `setup-2fa.txt` — passo a passo da geração do segredo e do pareamento.

**Efeito sobre o ataque.** O segundo fator é independente da senha e não é
acessível ao atacante. Assim, mesmo a senha trivial descoberta na fase ofensiva
deixa de ser suficiente para autenticar: sem o código válido do dispositivo do
usuário legítimo, o acesso é negado.

## Camada complementar — Política de senhas

A fase de ataque evidenciou, na prática, a relação direta entre complexidade da
senha e resistência ao ataque (trivial quebrada em ~1 s; forte não quebrada).
Como política preventiva recomenda-se:

- Comprimento mínimo de 12 caracteres.
- Mistura de maiúsculas, minúsculas, números e símbolos.
- Proibição de senhas presentes em dicionários públicos de vazamentos.
- Troca periódica e não reutilização entre serviços.

No Linux, essa política pode ser imposta com o módulo `pam_pwquality`.

## Síntese: por que as camadas se complementam

| Vetor do ataque                          | Defesa que neutraliza            |
|------------------------------------------|----------------------------------|
| Testar muitas senhas rapidamente         | fail2ban (bloqueio por volume)   |
| Usar uma senha fraca/descoberta          | 2FA (exige segundo fator)        |
| Adivinhar a senha em dicionário          | Política de senhas fortes        |

A combinação garante que, mesmo que uma das barreiras falhe, as demais ainda
impedem o acesso não autorizado.
