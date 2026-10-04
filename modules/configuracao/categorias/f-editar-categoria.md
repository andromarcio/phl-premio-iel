<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-CAT-03
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

# Editar Categoria
> **Nível 3** - Feature Set: Categorias — Major Feature Set: Configuração da Premiação - `CFG-CAT-03`

## Descrição
Permite ao administrador alterar o nome e a descrição de uma categoria já cadastrada, mantendo o catálogo da premiação atualizado.

No detalhe da categoria, na aba "Dados Gerais" — ou no editor contextual da árvore de configuração do prêmio —, o administrador altera o nome ou a descrição e aciona "Salvar".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-004_Cadastrar_Categorias`](../../../hus/HU-004_Cadastrar_Categorias.docx) | Criação | `CA-1, CA-4` — nome obrigatório e único no prêmio também na edição; editor contextual que acompanha o nó selecionado na árvore |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/categorias/:id/visualizar` (Formulário de Categoria, aba Dados Gerais)

**Fidelidade ao protótipo**: referência — `prototypes/configuracao/categorias/flow.html`

---

</div>

## Regras de negócio

1. O nome da categoria é único dentro de um mesmo prêmio; o mesmo nome é permitido em prêmios diferentes.
2. O prêmio ao qual a categoria pertence é imutável: a edição não move a categoria para outro prêmio.

---

## Cenários

```gherkin
Feature: Editar Categoria

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar nome e descrição
    Given que selecionei uma categoria existente
    When altero o nome e a descrição e clico em "Salvar"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome apagado na edição
    Given que estou editando uma categoria
    When apago o campo Nome e clico em "Salvar"
    Then o sistema não grava e exibe "Campo obrigatório."

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Renomear para um nome já usado no mesmo prêmio
    Given que já existe outra categoria "Categoria Estudantil" no mesmo prêmio
    When renomeio a categoria atual para "Categoria Estudantil"
    Then o sistema não grava e exibe "Já existe uma categoria com este nome neste prêmio."
    # ← MESSAGE-DICTIONARY: CFG_CATEGORIA_NOME_DUPLICADO
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Categoria | entrada do usuário | editável | texto | sim | único dentro do mesmo prêmio; máximo de 200 caracteres |
| Descrição | Categoria | entrada do usuário | editável | texto longo | não | texto livre |
| Prêmio | Premiação | exibido do cadastro | imutável | seleção → Premiação | — | não pode ser alterado após a criação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Formulário da categoria em `/categorias/:id/visualizar`, aba "Dados Gerais"; também acessível pelo editor contextual da árvore de configuração do prêmio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de nome e descrição de uma categoria são persistidas | cenário "Editar nome e descrição" |
| SC-02 | A tentativa de renomear para um nome já usado no mesmo prêmio é rejeitada | cenário "Renomear para um nome já usado no mesmo prêmio" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Categoria (implícita) | acessório | SE | 2 | 6 | Médio | 5 | 2026-02-28 |
| Editar Categoria | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Consultar Categoria (implícita)** — SE · ALR 2 · DER 6 · Médio · 5 PF

```json
{"pe": "Consultar Categoria (implícita)",
 "alr": ["Categoria", "Premiação"],
 "der": ["Nome", "Descrição", "Premiação", "Id do Vinculo", "Situação", "Ação"]}
```
Por que cada ALR:
1. `Categoria` — o formulário abre preenchido com os dados da categoria
2. `Premiação` — a abertura traz o prêmio do vínculo, que a pesquisa não mostrava

**Editar Categoria** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Editar Categoria",
 "alr": ["Categoria"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"],
 "nao_contados": "Premiação — a planilha do baseline cita o arquivo, mas conta ALR 1"}
```

Por que cada ALR:
1. `Categoria` — a transação grava o nome e a descrição alterados

⚠️ A planilha enumera *Categoria · Premiação* e conta ALR 1. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 8 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/configuracao/categorias/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-25 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-004 |

---

*Feature Set: Categorias · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
