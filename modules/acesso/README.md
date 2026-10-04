<!-- docqui: 4.1.0 | prompt: PROMPT_1A | atualizado: 2026-10-04 -->
# Major Feature Set: Acesso e Gestão
> **Nível 1** - Visão estratégica do domínio - `ACS`

## Descrição
Responde pelo controle de acesso e pela gestão dos administradores regionais, apoiando-se no login corporativo (SSO) para a identidade e mantendo o vínculo de cada administrador às suas UFs. Concentra a auditoria das ações críticas do sistema. É consumido por todos os domínios, que dependem do perfil do usuário e do seu escopo regional para autorizar cada ação.

### O que este domínio NÃO faz
| Descrição | Pertence a |
|---|---|
| Autenticar o usuário e guardar senha | Login corporativo (SSO/AD) — externo |
| Definir a estrutura da premiação | Configuração da Premiação |
| Validar ou avaliar inscrições | Validação / Avaliação |

---

## Feature Sets

| Feature Set | Descrição | Features |
|---|---|---|
| [**Administradores Regionais**](./administradores-regionais/README.md) <small>ACS-ADM</small> | Cadastrar administradores regionais e vinculá-los às UFs sob sua responsabilidade | 4 |
| [**Acesso e Perfis**](./acesso-perfis/README.md) <small>ACS-ACE</small> | Controle de acesso por funcionalidade e por perfil, integrado ao login corporativo | 3 |
| [**Auditoria**](./auditoria/README.md) <small>ACS-AUD</small> | Registro e consulta das ações críticas do sistema | 1 |

---

## Regras transversais de negócio

1. A identidade e a autenticação vêm do login corporativo (SSO/AD); o sistema não mantém cadastro próprio de senhas.
2. Cada usuário tem um perfil; o acesso é por funcionalidade e nega por padrão (ver `global/AUTHZ.md`).
3. Um administrador regional atua apenas nas UFs a que está vinculado.
4. As ações críticas (validação, ajustes, avaliação, configuração) são registradas em auditoria com responsável, data e o que mudou.

---

## Integrações com outros domínios

### Leitura — domínios que consomem dados deste domínio
| Domínio | O que consome | Como |
|---|---|---|
| Configuração da Premiação | Perfil e permissões do usuário | a confirmar no PROMPT_1B |
| Inscrição | Identidade do participante autenticado | a confirmar no PROMPT_1B |
| Validação | Vínculo do administrador às UFs (escopo) | a confirmar no PROMPT_1B |
| Avaliação | Perfil do administrador e identidade do avaliador | a confirmar no PROMPT_1B |

### Escrita — domínios que criam ou alteram dados deste domínio
| Domínio | O que altera | Situação |
|---|---|---|
| Todos | Geram registros de auditoria das ações críticas | A cada ação crítica |

---

<div class="dev-only">

## Entidades do domínio

> Campos completos no data-model — ver `global/data-models/acesso.md`.

| Entidade | Descrição | Campos no DATA-MODEL.md |
|---|---|---|
| Usuário (vínculo por UF) | Vínculo do usuário às UFs (escopo regional) | → ver DATA-MODEL.md: Usuário (vínculo por UF) |
| Log de Auditoria | Registro append-only das ações críticas | → ver DATA-MODEL.md: Log de Auditoria |

> **ALI deste domínio** (1): Usuário — 7 PF (baseline APF). ⚠️ Identidade central é externa (SSO/AD); Log de Auditoria e Controle de Migração são entidades técnicas fora do baseline. Ver `global/data-models/acesso.md`.

</div>

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0: carimbo, título `# Major Feature Set:`, contagem de features por Feature Set conferida com os N3 existentes (acesso-perfis 2→3) e rodapé com os links dos Feature Sets. Seções técnicas do 1B (dependências externas, regras de acesso consolidadas) seguem fora do escopo do perfil `requisitos` |
| 2026-08-25 | Engenharia reversa (docqui) | N1 negocial criado | Domínio derivado do N0, das HUs e do data-model |

---

*Última revisão: 2026-10-04*

*Links: [Administradores Regionais](./administradores-regionais/README.md) `ACS-ADM` · [Acesso e Perfis](./acesso-perfis/README.md) `ACS-ACE` · [Auditoria](./auditoria/README.md) `ACS-AUD` · [INDEX geral](../INDEX.md)*
