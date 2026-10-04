---
id: CFG-CAT-04
feature_set: CFG-CAT
dominio: CFG
entidade: Categoria
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#categoria
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

# Visualizar Categoria
> **Nível 3** - Feature Set: Categorias — Domínio: Configuração da Premiação - `CFG-CAT-04`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador consultar os dados de uma categoria e a lista de prêmios aos quais ela está vinculada, com a situação de cada vínculo.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/categorias/:id/visualizar` (Detalhe da Categoria)

**Fidelidade ao protótipo**: referência — `prototypes/configuracao/categorias/flow.html`

---

</div>

## Regras de negócio

1. A consulta está disponível inclusive para categorias inativas.
2. Uma categoria pode estar vinculada a vários prêmios, cada vínculo com a sua própria situação.

---

## Cenários

```gherkin
# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Ver os dados de uma categoria
  Given que selecionei uma categoria no catálogo
  When abro o detalhe da categoria
  Then o sistema exibe o nome, a descrição e a situação da categoria

Scenario: Ver os vínculos da categoria com prêmios
  Given que estou no detalhe de uma categoria
  When acesso a aba "Vínculos"
  Then o sistema exibe a lista de prêmios vinculados e a situação de cada vínculo

# ── Estados especiais ──────────────────────────────────────────

Scenario: Categoria sem vínculos
  Given que a categoria não está vinculada a nenhum prêmio
  When acesso a aba "Vínculos"
  Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | Categoria | somente leitura | texto | — | — |
| Descrição | Categoria | somente leitura | texto longo | — | — |
| Situação | Categoria | somente leitura | lista (Ativo, Inativo) | — | — |
| Prêmios vinculados | derivado | somente leitura | lista (prêmio + situação do vínculo) | — | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página de detalhe em `/categorias/:id/visualizar`, com a aba "Dados Gerais" (nome, descrição, situação) e a aba "Vínculos" (prêmios vinculados).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto os dados são recuperados |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os dados da categoria e a aba de vínculos |
| Empty state | Aba de vínculos sem prêmios: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe exibe nome, descrição e situação da categoria | cenário "Ver os dados de uma categoria" |
| SC-02 | A aba de vínculos exibe todos os prêmios vinculados e a situação de cada vínculo | Critério de aceite 6 (HU-004) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Detalhar Categoria | SE | — | — | — | 0 | 2026-02-28 |

### Memória de cálculo

- **Detalhar Categoria** — ALR (0): —. DER (0): —.

**Total: 0 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/configuracao/categorias/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-25 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-004 |

---

*Feature Set: Categorias · Domínio: Configuração da Premiação · Última revisão: 2026-08-25*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
