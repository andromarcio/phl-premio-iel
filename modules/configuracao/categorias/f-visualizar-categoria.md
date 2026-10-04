<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-CAT-04
feature_set: CFG-CAT
dominio: CFG
entidade: Categoria
data_model_ref: data-models/configuracao.md#categoria
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-004_Cadastrar_Categorias
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

# Visualizar Categoria
> **Nível 3** - Feature Set: Categorias — Major Feature Set: Configuração da Premiação - `CFG-CAT-04`

## Descrição
Permite ao administrador consultar os dados de uma categoria e a lista de prêmios aos quais ela está vinculada, com a situação de cada vínculo.

A partir do Catálogo de Categorias, o administrador abre o detalhe de uma categoria e alterna entre a aba "Dados Gerais", com nome, descrição e situação, e a aba "Vínculos", com os prêmios a que ela está ligada.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-004_Cadastrar_Categorias`](../../../hus/HU-004_Cadastrar_Categorias.docx) | Criação | `CA-6` — aba de vínculos com todos os prêmios a que a categoria está ligada |

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
Feature: Visualizar Categoria

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Categoria | exibido do cadastro | somente leitura | texto | — | — |
| Descrição | Categoria | exibido do cadastro | somente leitura | texto longo | — | — |
| Situação | Categoria | exibido do cadastro | somente leitura | lista (Ativo, Inativo) | — | — |
| Prêmios vinculados | Premiação | exibido do cadastro | somente leitura | lista (prêmio + situação do vínculo) | — | um item por vínculo da categoria, com a situação de cada um |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Premiação × Categoria | lê | A aba "Vínculos" lista cada vínculo da categoria com um prêmio e a situação dele (regra 2) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Visualizar Categoria | principal | — | — | — | — | 0 | 2026-02-28 |

> No baseline, a linha se chama *Detalhar Categoria* (tipo SE, sem ALR, DER nem complexidade); aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`.

### Memória de cálculo

**Visualizar Categoria** — 0 PF

```json
{"pe": "Visualizar Categoria",
 "motivo": "zerada no baseline APF sem ALR, DER nem complexidade; o motivo foi perguntado à equipe de métricas (Q7) e ainda não respondido"}
```

⚠️ Se o zero foi lacuna da planilha, e não descarte, a linha precisa de contagem — ver `arquivos/demandas/QUESTIONAMENTO_METRICAS_BASELINE_APF.md`, Q7.

**Total: 0 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/configuracao/categorias/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-25 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-004 |

---

*Feature Set: Categorias · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
