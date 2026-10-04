---
id: CFG-PRE-12
feature_set: CFG-PRE
dominio: CFG
entidade: Critério de Avaliação
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#criterio-de-avaliacao
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Configurar Critérios de Avaliação
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-12`
> **Prioridade**: P2 · **MVP**: não

## Descrição

> ⚠️ **Não implementada** (conferência com o código, 2026-08-28). A tabela `TB_CRITERIO_AVALIACAO` e o `CriterioAvaliacaoRepository` existem, mas **não há controller, serviço nem tela** para essa configuração. Não confundir com os **critérios de desempate** (`AVL-ETA-06`, `TB_DESEMPATE_CRITERIO`), que estão implementados. Ver `global/CONFORMIDADE-CODIGO.md` § 5.
Permite ao administrador definir os critérios de avaliação e seus pesos usados na apuração das notas de uma edição.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota ⚠️ *sem tela implementada* (o botão de critérios de **desempate** vive em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` → aba **Avaliação & Etapas**) (Critérios de Avaliação do Prêmio)

**Fidelidade ao protótipo**: n/a

> ⚠️ Feature derivada do modelo de dados (entidade Critério de Avaliação) — sem HU dedicada; regras, campos e cenários abaixo são propostos e aguardam confirmação com a liderança do produto.

---

</div>

## Regras de negócio

1. Cada critério de avaliação pertence a uma edição e pode ser específico de uma categoria; sem categoria, vale para toda a edição. ⚠️ *(derivado do data-model — a confirmar)*
2. O peso do critério pondera a contribuição da sua nota no cálculo da nota final da apuração. ⚠️ *(derivado do data-model — a confirmar)*
3. Os critérios são definidos na edição e consumidos na avaliação das inscrições. ⚠️ *(derivado do data-model — a confirmar)*

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Definir um critério de avaliação
  Given que estou nos Critérios de Avaliação de uma edição
  When informo o nome do critério e o peso e salvo
  Then o sistema registra o critério e exibe "Registro salvo com sucesso."

Scenario: Peso não informado assume o padrão
  Given que informo apenas o nome do critério, sem o peso
  When salvo o critério
  Then o sistema registra o critério com o peso padrão 1,00

# ── Erros de validação ─────────────────────────────────────────

Scenario: Nome do critério em branco
  Given que estou definindo um critério de avaliação
  When deixo o campo Nome do critério em branco e clico em "Salvar"
  Then o sistema não registra e exibe "Campo obrigatório."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome do critério | entrada do usuário | editável | texto | sim | máximo de 300 caracteres |
| Descrição do critério | entrada do usuário | editável | texto longo | não | texto livre |
| Categoria | entrada do usuário | editável | seleção → Categoria | não | critério específico de uma categoria; em branco, vale para toda a edição ⚠️ |
| Peso | entrada do usuário | editável | número decimal | não | fator de ponderação da nota; padrão 1,00 |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Peso | 1,00 | Quando não informado |
| Ordem | 0 | Na criação do critério |

---

## Comportamento de tela

### Onde fica
Tela Critérios de Avaliação do Prêmio (⚠️ *sem tela implementada* (o botão de critérios de **desempate** vive em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` → aba **Avaliação & Etapas**)): relação dos critérios da edição com nome, peso e categoria, e o formulário para definir cada critério e seu peso. ⚠️ *(layout proposto — sem HU/protótipo de referência)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome do critério com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a relação de critérios |
| Empty state | Sem critérios definidos: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um critério com nome válido e peso é registrado na edição | cenário "Definir um critério de avaliação" ⚠️ |
| SC-02 | Um critério sem peso informado assume o peso padrão 1,00 | cenário "Peso não informado assume o padrão" ⚠️ |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do data-model (Critério de Avaliação) — sem HU dedicada ⚠️ |

---

*Feature Set: Prêmios · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
