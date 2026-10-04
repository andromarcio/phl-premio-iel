---
id: CFG-PRE-06
feature_set: CFG-PRE
dominio: CFG
entidade: Premiação
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#premiacao
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

# Importar Prêmios
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-06`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador criar uma nova edição a partir de uma planilha preenchida, apresentando o resumo das estruturas criadas ao final.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Lista de Prêmios (`/configuracao-premiacao/premiacoes`), botão de importação

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A importação sempre cria uma nova edição; nunca atualiza uma edição existente.
2. A importação é atômica: quando a estrutura do arquivo é inválida, nenhuma parte da hierarquia é criada.
3. O arquivo aceito é uma planilha dentro do tamanho e dos formatos permitidos. → ver RULES-DICTIONARY: Arquivo com tamanho máximo (parâmetro: 10 MB; formatos .xlsx e .xls)

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Importar uma planilha válida
  Given que seleciono uma planilha válida para importação
  When confirmo a importação
  Then o sistema cria uma nova edição e apresenta o resumo com a contagem de premiação, categorias, modalidades e tipos de participante criados
  And a nova edição passa a constar na lista de Prêmios

Scenario: Baixar o modelo de planilha
  Given que estou na lista de Prêmios
  When aciono o download do modelo de planilha
  Then o sistema disponibiliza uma planilha com os cabeçalhos das abas e sem dados

# ── Erros de validação ─────────────────────────────────────────

Scenario: Planilha em formato ou estrutura inválidos
  Given que seleciono um arquivo com formato ou estrutura de abas inválidos
  When confirmo a importação
  Then o sistema não cria nenhuma edição e exibe "Arquivo inválido: verifique o formato e a estrutura da planilha."
  # ← MESSAGE-DICTIONARY: CFG_IMPORT_ARQUIVO_INVALIDO
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Planilha | entrada do usuário | editável | arquivo | sim | formatos .xlsx e .xls; máximo de 10 MB |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Resumo da importação | Contagem de premiação, categorias, modalidades e tipos de participante criados | Ao concluir a importação |
| Situação (nova edição) | Ativo | Na criação da edição importada |

---

## Comportamento de tela

### Onde fica
Ação disparada na Lista de Prêmios (`/configuracao-premiacao/premiacoes`): um diálogo recebe a planilha por seleção ou arraste, exibe o progresso durante o processamento e mostra o resumo das estruturas criadas ao final; o mesmo painel de ações oferece o download do modelo de planilha para preenchimento. ⚠️ *(o "Baixar Modelo" é aqui tratado como ação de apoio à importação — avaliar se merece feature própria)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe a barra de progresso durante o processamento da planilha |
| Erro de validação | Exibe "Arquivo inválido: verifique o formato e a estrutura da planilha." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe o resumo com a contagem de estruturas criadas |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A importação de uma planilha válida cria uma nova edição e apresenta o resumo das estruturas criadas | Critério de aceite 3 (HU-003) |
| SC-02 | Uma planilha inválida não cria nenhuma estrutura (importação atômica) | Critério de aceite 4 (HU-003) |
| SC-03 | O modelo de planilha traz os mesmos cabeçalhos da exportação, sem dados | Critério de aceite 2 (HU-003) |

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
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-003 |

---

*Feature Set: Prêmios · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
