<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-AUD-01
feature_set: ACS-AUD
dominio: ACS
entidade: Log de Auditoria
data_model_ref: data-models/acesso.md#log-de-auditoria
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

# Consultar Trilha de Auditoria
> **Nível 3** - Feature Set: Auditoria — Major Feature Set: Acesso e Gestão - `ACS-AUD-01`

## Descrição
Permite ao administrador consultar a trilha de auditoria — o registro append-only das ações críticas — filtrando por entidade auditada, ação, usuário e período. ⚠️ *(escopo, filtros e perfis a confirmar)*

Na tela Trilha de Auditoria — ainda sem tela implementada ⚠️ —, o administrador escolhe filtros como entidade auditada, ação e período e vê a lista paginada dos registros, do mais recente ao mais antigo.

> ⚠️ **Não implementada** (conferência com o código, 2026-08-28). Não há controller nem tela, e **nenhum serviço grava em `TL_LOG_AUDITORIA`** — a tabela e o repositório existem vazios. A trilha efetiva do produto hoje é de domínio: `TB_INSCRICAO_HISTORICO` (+ itens de ajuste), `TB_INSCRICAO_SNAPSHOT` (antes/depois de ajuste e de edição administrativa), `TB_AVALIACAO_HISTORICO` e `TB_AUDITORIA_EMAIL`. Reespecificar sobre esses históricos ou implementar a trilha genérica é decisão em aberto — ver `global/CONFORMIDADE-CODIGO.md` § 3.4 e § 5.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota ⚠️ *sem tela implementada* (Trilha de Auditoria)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A trilha de auditoria é somente leitura e append-only: a consulta não altera nem remove registros. ⚠️ *(a confirmar)*
2. Cada registro identifica a entidade auditada, o registro afetado, a ação executada, o usuário responsável e a data e hora do evento.
3. O administrador regional consulta apenas os registros dentro do seu escopo de UFs; o administrador nacional acessa a trilha completa. ⚠️ *(recorte por escopo a confirmar)*

---

## Cenários

```gherkin
Feature: Consultar Trilha de Auditoria

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar registros ao abrir a trilha
    Given que existem ações críticas registradas na auditoria
    When acesso a tela de Trilha de Auditoria
    Then o sistema exibe os registros com entidade auditada, ação, usuário e data e hora

  Scenario: Filtrar por entidade e ação
    Given que existem registros de auditoria de entidades e ações diferentes
    When filtro pela entidade "Validação de Inscrição" e pela ação "Alteração"
    Then o sistema exibe apenas os registros que correspondem aos filtros

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Filtrar por período
    Given que existem registros em datas diferentes
    When informo um período inicial e final
    Then o sistema exibe apenas os registros ocorridos dentro do período

  Scenario: Busca sem resultados
    Given que nenhum registro corresponde aos filtros informados
    When realizo a busca
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Entidade auditada | Log de Auditoria | entrada do usuário | editável | seleção (entidades auditáveis) | não | filtro pela entidade registrada na trilha ⚠️ |
| Ação | dado de código | entrada do usuário | editável | lista (Inclusão, Alteração, Exclusão) | não | valores da ação a confirmar ⚠️ |
| Usuário | externo: Portal corporativo | entrada do usuário | editável | seleção (usuário do login corporativo) | não | filtro pelo responsável da ação |
| Período | Log de Auditoria | entrada do usuário | editável | intervalo de datas | não | filtra pela data e hora do registro; data inicial não posterior à data final |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Data e hora | Log de Auditoria | padrão ↓ |
| Entidade auditada | Log de Auditoria | ordenável |
| Registro auditado | Log de Auditoria | — |
| Ação | Log de Auditoria | ordenável |
| Usuário | Log de Auditoria | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Usuário | lê | As UFs vinculadas ao administrador regional delimitam os registros que ele consulta (regra 3 ⚠️) |

---

## Comportamento de tela

### Onde fica
Página própria em ⚠️ *sem tela implementada* (Trilha de Auditoria): filtros por entidade auditada, ação, usuário e período, com a lista paginada dos registros em ordem decrescente de data e hora.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a trilha é recuperada |
| Erro de validação | Destaca o período quando a data inicial é posterior à final |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os registros de auditoria correspondentes |
| Empty state | Sem registros: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A trilha lista os registros de auditoria com filtros por entidade, ação, usuário e período | cenário "Listar registros ao abrir a trilha" |
| SC-02 | O filtro por período retorna apenas os registros ocorridos dentro do intervalo | cenário "Filtrar por período" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), com o aviso de não implementada movido para depois dele, sem mudança de texto; coluna Entidade em `## Campos` (usuário vindo do portal corporativo, `externo`; lista de ações como `dado de código`; os Tipos de seleção deixam de apontar para entidade inexistente ou local); `## Dados lidos e gravados`; coluna Papel em `## Métricas de tamanho` — sem processo elementar medido. Sem `## Origem`: a feature não deriva de HU. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do data-model (entidade Log de Auditoria) — sem HU dedicada ⚠️ |

---

*Feature Set: Auditoria · Major Feature Set: Acesso e Gestão · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
