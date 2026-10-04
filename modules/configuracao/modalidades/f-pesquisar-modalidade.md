<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-MOD-01
feature_set: CFG-MOD
dominio: CFG
entidade: Modalidade
data_model_ref: data-models/configuracao.md#modalidade
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-005_Cadastrar_Modalidades
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

# Pesquisar Modalidades
> **Nível 3** - Feature Set: Modalidades — Major Feature Set: Configuração da Premiação - `CFG-MOD-01`

## Descrição
Permite ao administrador localizar modalidades do catálogo por nome e situação, listando os resultados para consulta, edição ou vínculo a uma categoria.

No Catálogo de Modalidades, o administrador digita parte do nome, escolhe a situação — Todas, Ativo ou Inativo — e vê a lista paginada, de onde abre o detalhe, a edição ou a troca de situação de cada modalidade.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-005_Cadastrar_Modalidades`](../../../hus/HU-005_Cadastrar_Modalidades.docx) | Criação | `CA-5` — catálogo administrativo com a lista de modalidades filtrada por nome e por situação |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/modalidades` (Catálogo de Modalidades)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A busca considera todas as modalidades do catálogo, tanto ativas quanto inativas.
2. A busca por nome é por correspondência parcial (não exige o nome exato).
3. A situação inativa é apresentada, mas modalidades inativas não são ofertadas nos fluxos de inscrição pública.

---

## Cenários

```gherkin
Feature: Pesquisar Modalidades

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar modalidades ao abrir o catálogo
    Given que existem modalidades cadastradas no catálogo
    When acesso a tela de Modalidades
    Then o sistema exibe a lista de modalidades com nome, situação e período de inscrição

  Scenario: Buscar modalidade por parte do nome
    Given que existe a modalidade "Individual"
    When informo "indiv" no campo de busca por nome
    Then o sistema exibe a modalidade "Individual" no resultado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Filtrar por situação inativa
    Given que existem modalidades ativas e inativas
    When seleciono a situação "Inativo"
    Then o sistema exibe apenas as modalidades inativas

  Scenario: Busca sem resultados
    Given que nenhuma modalidade corresponde ao termo buscado
    When realizo a busca
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Modalidade | entrada do usuário | editável | texto | não | filtro por correspondência parcial |
| Situação | dado de código | entrada do usuário | editável | lista (Todas, Ativo, Inativo) | não | padrão: Todas |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Nome | Modalidade | padrão ↑ |
| Situação | Modalidade | ordenável |
| Início das inscrições | Modalidade × Categoria | — |
| Fim das inscrições | Modalidade × Categoria | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Modalidade × Categoria | lê | Início e fim das inscrições, exibidos nas colunas do resultado, vêm do vínculo da modalidade com a categoria |
| Tipo de Participante | lê | A planilha do baseline conta a quantidade de tipos de participante de cada modalidade (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página própria em `/modalidades` (Catálogo de Modalidades): campo de busca por nome, seletor de situação e a lista paginada de resultados.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (filtros são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de modalidades correspondentes |
| Empty state | Sem modalidades no catálogo: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O catálogo lista modalidades com filtro por nome e por situação (Ativo/Inativo/Todas) | Critério de aceite 5 (HU-005) |
| SC-02 | A busca por parte do nome retorna as modalidades cujo nome contém o termo | cenário "Buscar modalidade por parte do nome" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Pesquisar Modalidades | principal | CE | 2 | 6 | Médio | 4 | 2026-02-28 |

> No baseline, o processo elementar se chama *Pesquisar Modalidade*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Pesquisar Modalidades** — CE · ALR 2 · DER 6 · Médio · 4 PF

```json
{"pe": "Pesquisar Modalidades",
 "alr": ["Modalidade", "Tipo Participante"],
 "der": ["Nome", "Descrição", "Qtd Tipos Participantes", "Situação", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Modalidade` — a lista traz nome, descrição e situação de cada modalidade do catálogo
2. `Tipo Participante` — a planilha conta a quantidade de tipos de participante de cada modalidade; o arquivo e o número são os dela

⚠️ As colunas do resultado especificadas no N3 trazem *Início das inscrições* e *Fim das inscrições*, que a planilha não enumera, e não trazem *Descrição* nem *Qtd Tipos Participantes*, que ela conta. Ficou o número da planilha; a divergência entre as colunas especificadas e as contadas vai à equipe de métricas junto com o questionamento do baseline.

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-005 |

---

*Feature Set: Modalidades · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
