<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-CAT-02
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

# Cadastrar Categoria
> **Nível 3** - Feature Set: Categorias — Major Feature Set: Configuração da Premiação - `CFG-CAT-02`

## Descrição
Permite ao administrador registrar uma nova categoria informando nome e descrição, deixando-a disponível no catálogo para ser vinculada a prêmios.

No Catálogo de Categorias, o administrador aciona "Nova Categoria", informa o nome e, se quiser, a descrição, e salva; na árvore de configuração de um prêmio, o botão "+" do nó raiz cria a categoria com o nome "Nova Categoria" e abre o editor para renomeá-la.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-004_Cadastrar_Categorias`](../../../hus/HU-004_Cadastrar_Categorias.docx) | Criação | `CA-1, CA-2` — nome obrigatório e único no prêmio, com erro claro na duplicidade; criação rápida com o nome "Nova Categoria" e o editor aberto para renomear |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/categorias/novo` (Formulário de Categoria). Também pode ser criada por criação rápida a partir da árvore de configuração do prêmio (ação em tela).

**Fidelidade ao protótipo**: referência — `prototypes/configuracao/categorias/flow.html`

---

</div>

## Regras de negócio

1. O nome da categoria é único dentro de um mesmo prêmio; o mesmo nome é permitido em prêmios diferentes. ⚠️ *(no catálogo administrativo a categoria nasce sem prêmio; a unicidade se aplica ao vincular — confirmar o escopo da checagem no catálogo)*
2. A categoria é um item de catálogo reutilizável: pode ser vinculada a mais de um prêmio.
3. Na criação rápida pela árvore, a categoria é criada com o nome padrão "Nova Categoria" e o editor é aberto para renomeação.

---

## Cenários

```gherkin
Feature: Cadastrar Categoria

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Cadastrar categoria no catálogo
    Given que acesso o formulário de nova categoria
    When informo o nome "Categoria Estudantil" e salvo
    Then o sistema registra a categoria e exibe "Registro salvo com sucesso."
    And a categoria fica disponível para vínculo a prêmios

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome em branco
    Given que estou no formulário de categoria
    When deixo o campo Nome em branco e clico em "Salvar"
    Then o sistema não registra e exibe "Campo obrigatório."

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Nome duplicado no mesmo prêmio
    Given que já existe a categoria "Categoria Estudantil" no prêmio
    When tento criar outra categoria com o mesmo nome neste prêmio
    Then o sistema não registra e exibe "Já existe uma categoria com este nome neste prêmio."
    # ← MESSAGE-DICTIONARY: CFG_CATEGORIA_NOME_DUPLICADO

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Criação rápida pela árvore
    Given que estou na configuração de um prêmio
    When aciono a criação rápida de categoria no nó raiz
    Then o sistema cria a categoria com o nome "Nova Categoria" e abre o editor para renomeação

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de escrita
    Given que meu perfil não tem permissão para cadastrar categorias
    When tento acessar o cadastro de categoria
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Categoria | entrada do usuário | editável | texto | sim | único dentro do mesmo prêmio; máximo de 200 caracteres |
| Descrição | Categoria | entrada do usuário | editável | texto longo | não | texto livre |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação da categoria |
| Nome (criação rápida) | "Nova Categoria" | Quando criada pela árvore de configuração, antes da renomeação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Premiação × Categoria | grava | Na criação rápida pela árvore, a categoria nasce já vinculada ao prêmio em configuração (regra 3) |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/categorias/novo` (campos Nome e Descrição) e, alternativamente, no editor contextual aberto pela criação rápida na árvore de configuração do prêmio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e retorna ao catálogo |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma categoria com nome válido é registrada e passa a constar no catálogo | cenário "Cadastrar categoria no catálogo" |
| SC-02 | A criação rápida gera a categoria com o nome "Nova Categoria" e abre o editor | Critério de aceite 2 (HU-004) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Categoria | principal | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Incluir Categoria*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Cadastrar Categoria** — EE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Cadastrar Categoria",
 "alr": ["Categoria"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"],
 "nao_contados": "Premiação — a planilha do baseline cita o arquivo, mas conta ALR 1"}
```

Por que cada ALR:
1. `Categoria` — a transação grava a categoria nova (no catálogo ela nasce sem prêmio; o vínculo da criação rápida é subgrupo do mesmo arquivo lógico)

⚠️ A planilha enumera *Categoria · Premiação* e conta ALR 1. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

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
