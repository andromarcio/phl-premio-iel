---
id: CFG-CAT-01
feature_set: CFG-CAT
dominio: CFG
entidade: Categoria
prioridade: P1
mvp: true
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

# Pesquisar Categorias
> **Nível 3** - Feature Set: Categorias — Domínio: Configuração da Premiação - `CFG-CAT-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador localizar categorias do catálogo por nome e situação, listando os resultados para consulta, edição ou vínculo a um prêmio.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/categorias` (Catálogo de Categorias)

**Fidelidade ao protótipo**: referência — `prototypes/configuracao/categorias/flow.html`

---

</div>

## Regras de negócio

1. A busca considera todas as categorias do catálogo, tanto ativas quanto inativas.
2. A busca por nome é por correspondência parcial (não exige o nome exato).
3. A situação inativa é apresentada, mas categorias inativas não são ofertadas nos fluxos de inscrição pública → ver N1 Configuração da Premiação: Regras transversais de negócio: 2.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Listar categorias ao abrir o catálogo
  Given que existem categorias cadastradas no catálogo
  When acesso a tela de Categorias
  Then o sistema exibe a lista de categorias com nome, descrição e situação

Scenario: Buscar categoria por parte do nome
  Given que existe a categoria "Categoria Estudantil"
  When informo "estud" no campo de busca por nome
  Then o sistema exibe a categoria "Categoria Estudantil" no resultado

# ── Estados especiais ──────────────────────────────────────────

Scenario: Filtrar por situação inativa
  Given que existem categorias ativas e inativas
  When seleciono a situação "Inativo"
  Then o sistema exibe apenas as categorias inativas

Scenario: Busca sem resultados
  Given que nenhuma categoria corresponde ao termo buscado
  When realizo a busca
  Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | não | filtro por correspondência parcial |
| Situação | entrada do usuário | editável | lista (Todas, Ativo, Inativo) | não | padrão: Todas |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Nome | Categoria | padrão ↑ |
| Descrição | Categoria | — |
| Situação | Categoria | ordenável |
| Modalidades vinculadas | derivado (contagem) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página própria em `/categorias` (Catálogo de Categorias): campo de busca por nome, seletor de situação e a lista paginada de resultados.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (filtros são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de categorias correspondentes |
| Empty state | Sem categorias no catálogo: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O catálogo lista categorias com filtro por nome e por situação (Ativo/Inativo/Todas) | Critério de aceite 5 (HU-004) |
| SC-02 | A busca por parte do nome retorna as categorias cujo nome contém o termo | cenário "Buscar categoria por parte do nome" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Pesquisar Categorias | SE | 2 | 6 | Médio | 5 | 2026-02-28 |

### Memória de cálculo

- **Pesquisar Categorias** — ALR (2): Categoria · Premiação. DER (6): Nome · Descrição · Qtd Vinculos · Status · Ação · Mensagem.

```json
{"pe": "Pesquisar Categorias",
 "alr": ["Categoria", "Premiação"],
 "der": ["Nome", "Descrição", "Qtd Vinculos", "Status", "Ação", "Mensagem"]}
```

**Total: 5 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/configuracao/categorias/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-25 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-004 |

---

*Feature Set: Categorias · Domínio: Configuração da Premiação · Última revisão: 2026-08-25*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
