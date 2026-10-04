<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-AJU-04
feature_set: VAL-AJU
dominio: VAL
entidade: Item de Ajuste
data_model_ref: data-models/inscricao.md#item-de-ajuste
endpoints: []
error_codes: []
depende_de: [VAL-AJU-01]
origem:
  tipo: issue
  chave: HU-018_Analisar_Validar_Inscricao
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

# Conferir Item de Ajuste
> **Nível 3** - Feature Set: Ajustes — Major Feature Set: Validação - `VAL-AJU-04`

## Descrição
Permite ao validador marcar, item a item, quais dos ajustes solicitados ao participante já foram atendidos, deixando visível quanto ainda falta antes de decidir sobre a inscrição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-018_Analisar_Validar_Inscricao`](../../../hus/HU-018_Analisar_Validar_Inscricao.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`), barra de conferência dos itens de ajuste

**Fidelidade ao protótipo**: referência · `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. A conferência só está disponível para inscrições nas situações Em Validação e Ajustes Concluídos.
2. Cada item de ajuste tem uma marcação própria de atendido ou não atendido.
3. O item marcado como atendido guarda a data em que foi conferido; ao ser desmarcado, essa data é descartada.
4. Só podem ser conferidos itens de ajuste que pertencem à própria inscrição.
5. A conferência não altera a situação da inscrição.
6. A conferência não é pré-requisito da decisão: a inscrição pode ser aprovada ou rejeitada com itens ainda não conferidos. → ver `VAL-ANA-03` (Aprovar Inscrição)

---

## Cenários

```gherkin
Feature: Conferir Item de Ajuste

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Marcar um item de ajuste como atendido
    Given que a inscrição está na situação Ajustes Concluídos com três itens de ajuste
    When marco um item como atendido
    Then o item passa a constar como conferido, com a data da conferência
    And o resumo passa a indicar um item conferido de três

  Scenario: Desmarcar um item conferido por engano
    Given que um item de ajuste está marcado como atendido
    When desmarco esse item e confirmo
    Then o item volta a constar como pendente e a data da conferência é descartada

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Conferir itens de inscrição já decidida
    Given que a inscrição está na situação Validada
    When tento marcar um item de ajuste
    Then o sistema informa que a conferência só vale nas situações Em Validação e Ajustes Concluídos

  Scenario: Aprovar com itens ainda pendentes
    Given que restam itens de ajuste não conferidos
    When aprovo a inscrição
    Then o sistema pede confirmação antes de concluir a aprovação

  # ── Conflitos com dados existentes ────────────────────────────

  Scenario: Conferir item de outra inscrição
    Given que o item de ajuste pertence a outra inscrição
    When tento marcá-lo a partir desta inscrição
    Then o sistema recusa a conferência
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Atendido | entrada do usuário | editável | sim/não | não | uma marcação por item de ajuste |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data da conferência | data e hora da marcação | Ao marcar o item como atendido |
| Data da conferência | vazia | Ao desmarcar o item |

---

## Comportamento de tela

### Onde fica
Barra de conferência exibida no Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`) quando a inscrição tem itens de ajuste. Cada item aparece com o texto solicitado e uma marcação de atendido; o rodapé traz o resumo "Itens conferidos: N de M" e as ações de decisão. Desmarcar um item já conferido pede confirmação na própria linha.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Marcações desabilitadas com indicador enquanto a conferência é gravada |
| Erro de validação | Não se aplica (a marcação não tem preenchimento livre) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a marcação do item e o resumo de conferidos |
| Empty state | Sem itens de ajuste, a barra de conferência não é exibida |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Marcar um item atualiza o resumo de itens conferidos | cenário "Marcar um item de ajuste como atendido" |
| SC-02 | Desmarcar um item devolve-o à condição de pendente | cenário "Desmarcar um item conferido por engano" |
| SC-03 | A decisão sobre a inscrição continua possível com itens pendentes, mediante confirmação | cenário "Aprovar com itens ainda pendentes" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem processo elementar correspondente. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (conferência item a item dos ajustes solicitados) — comportamento até então descrito apenas de passagem em VAL-ANA-03 |

---

*Feature Set: Ajustes · Major Feature Set: Validação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
