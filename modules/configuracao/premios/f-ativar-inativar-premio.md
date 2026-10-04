<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-04
feature_set: CFG-PRE
dominio: CFG
entidade: Premiação
data_model_ref: data-models/configuracao.md#premiacao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-001_Gerenciar_Premios
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

# Ativar/Inativar Prêmio
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-04`

## Descrição
Permite ao administrador alternar a situação de uma edição entre ativa e inativa, retirando-a dos fluxos públicos sem inativar suas categorias, modalidades e tipos de participante.

Na linha da edição, na Lista de Prêmios, o administrador aciona "Desativar" (ou "Ativar", se ela estiver inativa) e confirma a troca no diálogo de confirmação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-001_Gerenciar_Premios`](../../../hus/HU-001_Gerenciar_Premios.docx) | Criação | `CA-4` — desativação com confirmação do usuário, refletida de imediato na lista (cenários 03 e 06 da HU) |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Lista de Prêmios (`/configuracao-premiacao/premiacoes`), na linha da edição

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A inativação é uma exclusão lógica: a edição permanece registrada e deixa de ser ofertada nos fluxos públicos de inscrição.
2. A inativação de uma edição não se propaga às suas categorias, modalidades e tipos de participante, que permanecem no estado em que estavam.
3. A alternância de situação é reversível: uma edição inativa pode voltar a ativa.

---

## Cenários

```gherkin
Feature: Ativar/Inativar Prêmio

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Inativar uma edição
    Given que identifico uma edição ativa
    When aciono "Desativar" e confirmo a ação
    Then o sistema passa a edição para a situação Inativa
    And as categorias, modalidades e tipos de participante da edição permanecem inalterados

  Scenario: Reativar uma edição inativa
    Given que identifico uma edição inativa
    When aciono "Ativar" e confirmo a ação
    Then o sistema passa a edição para a situação Ativa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Cancelar a inativação
    Given que acionei "Desativar" para uma edição
    When cancelo a confirmação
    Then a operação é abortada e a edição permanece com a situação original
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Situação | Premiação | exibido do cadastro | somente leitura | lista (Ativo, Inativo) | — | alternada entre Ativo e Inativo pela própria ação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Inativo | Ao confirmar a inativação da edição |
| Situação | Ativo | Ao confirmar a reativação da edição |

---

## Comportamento de tela

### Onde fica
Ação disparada na linha da edição, na Lista de Prêmios (`/configuracao-premiacao/premiacoes`): a situação é apresentada como Ativo ou Inativo e a ação de alternância pede confirmação antes de efetivar a mudança.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto a situação é alterada |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Atualiza a situação da edição na lista |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A inativação exige confirmação e reflete imediatamente a nova situação na lista | Critério de aceite 4 (HU-001) |
| SC-02 | A inativação de uma edição não altera a situação das suas entidades filhas | Regra de negócio 4 (HU-001) |

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
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critério `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos` (a entidade estava na coluna Preenchimento, e a alternância pela ação já consta da Validação), coluna Papel na tabela de `## Métricas de tamanho`. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-001 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
