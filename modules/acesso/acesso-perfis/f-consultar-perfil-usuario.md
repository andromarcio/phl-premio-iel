<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ACE-02
feature_set: ACS-ACE
dominio: ACS
entidade: Usuário
data_model_ref: data-models/acesso.md#usuario-vinculo-por-uf
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Consultar Perfil do Usuário
> **Nível 3** - Feature Set: Acesso e Perfis — Major Feature Set: Acesso e Gestão - `ACS-ACE-02`

## Descrição
Consulta e resolve, no acesso do usuário, o seu perfil único e o conjunto de funcionalidades autorizadas que determinam o que ele pode fazer no sistema. ⚠️ *(derivado de AUTHZ/SSO — a confirmar)*

Não há tela nem botão próprio: logo depois do login corporativo, o sistema identifica o perfil do usuário e passa a mostrar apenas os itens de menu e as ações que esse perfil autoriza.

---

<div class="dev-only">

## Superfície

**Ação em tela** — a resolução do perfil e das funcionalidades ocorre no acesso (origem: Autenticar Usuário); não possui tela dedicada. ⚠️

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada usuário tem um único perfil; as funcionalidades acessíveis são exatamente as vinculadas a esse perfil. ⚠️ *(a confirmar com AUTHZ)*
2. Uma funcionalidade não vinculada a nenhum perfil não é acessível, salvo ao perfil máster (Administrador Nacional). ⚠️ *(nega por padrão — a confirmar)*
3. A resolução das funcionalidades ocorre a cada acesso e reflete de imediato as mudanças no vínculo entre perfil e funcionalidade. ⚠️ *(a confirmar)*

---

## Cenários

```gherkin
Feature: Consultar Perfil do Usuário

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Resolver o perfil e as funcionalidades no acesso
    Given que sou um usuário autenticado com um perfil definido
    When acesso o sistema
    Then o sistema resolve o conjunto de funcionalidades autorizadas do meu perfil e libera apenas essas

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Funcionalidade não vinculada ao perfil
    Given que uma funcionalidade não está vinculada ao meu perfil
    When tento acessá-la
    Then o sistema nega e exibe "Você não tem permissão para esta ação."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Vínculo alterado vale no próximo acesso
    Given que o administrador vinculou uma nova funcionalidade ao meu perfil
    When acesso o sistema novamente
    Then o sistema inclui a nova funcionalidade no conjunto autorizado do meu perfil
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Usuário autenticado | externo: Portal corporativo | externo: Portal corporativo | somente leitura | referência → Usuário | sim | identidade resolvida na autenticação, a partir da sessão do login corporativo (SSO) ⚠️ |
| Perfil | externo: Portal corporativo | externo: Portal corporativo | somente leitura | lista (Administrador Nacional, Participante, Administrador Regional, Avaliador) | — | um único perfil por usuário, resolvido a partir da identidade autenticada ⚠️ |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Funcionalidade autorizada | derivado (vínculo perfil↔funcionalidade) | padrão ↑ |
| Tipo | Funcionalidade (Tela / Ação) | — |
| Domínio | Funcionalidade | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Sem tela dedicada: a resolução ocorre no acesso (origem: Autenticar Usuário) e o conjunto de funcionalidades autorizadas passa a delimitar os itens de menu e as ações visíveis ao usuário. ⚠️

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o conjunto de funcionalidades é resolvido |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Libera os itens de menu e as ações correspondentes ao perfil |
| Empty state | Perfil sem funcionalidades vinculadas: nenhuma ação é liberada ⚠️ |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | No acesso, o sistema resolve o conjunto de funcionalidades do perfil do usuário e libera apenas essas | cenário "Resolver o perfil e as funcionalidades no acesso" |
| SC-02 | Uma funcionalidade não vinculada ao perfil não é acessível | cenário "Funcionalidade não vinculada ao perfil" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — derivada da sessão; sem PE no baseline. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), coluna Entidade em `## Campos` (identidade e perfil vindos do portal corporativo, `externo`; o Tipo do Perfil passa de `seleção → Perfil`, entidade que não existe no data-model, à lista dos quatro perfis do portal), coluna Papel em `## Métricas de tamanho` — sem processo elementar medido. Sem `## Origem`: a feature não deriva de HU. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado de `global/AUTHZ.md` (controle de acesso por funcionalidade) — sem HU dedicada ⚠️ |

---

*Feature Set: Acesso e Perfis · Major Feature Set: Acesso e Gestão · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
