<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-01
feature_set: CFG-TIP
dominio: CFG
entidade: Tipo de Participante
data_model_ref: data-models/configuracao.md#tipo-de-participante
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-006_Cadastrar_Tipo_Participantes
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

# Pesquisar Tipos de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-01`

## Descrição
Permite ao administrador localizar os tipos de participante por nome e situação, listando os resultados para consulta, configuração da estrutura de inscrição ou composição de ofertas.

No Catálogo de Tipos de Participante, o administrador digita parte do nome, escolhe a situação — Todas, Ativo ou Inativo — e vê a lista paginada, de onde aciona as ações de cada tipo, como abrir o detalhe, editar ou trocar a situação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-006_Cadastrar_Tipo_Participantes`](../../../hus/HU-006_Cadastrar_Tipo_Participantes.docx) | Criação | — Tela B da HU (catálogo administrativo com a lista paginada e os filtros por nome e por situação); a HU não numera critério para a pesquisa |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/tipos-participante` (Catálogo de Tipos de Participante)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A busca considera todos os tipos de participante, tanto ativos quanto inativos.
2. A busca por nome é por correspondência parcial (não exige o nome exato).
3. Um tipo de participante inativo não é ofertado nos fluxos de inscrição pública → ver N1 Configuração da Premiação: Regras transversais de negócio: 2. ⚠️ *(referência à regra transversal a confirmar quando o N1 for publicado)*

---

## Cenários

```gherkin
Feature: Pesquisar Tipos de Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar tipos de participante ao abrir o catálogo
    Given que existem tipos de participante cadastrados
    When acesso a tela de Tipos de Participante
    Then o sistema exibe a lista de tipos com nome, descrição e situação

  Scenario: Buscar tipo por parte do nome
    Given que existe o tipo de participante "Estudante Bolsista"
    When informo "bolsis" no campo de busca por nome
    Then o sistema exibe o tipo "Estudante Bolsista" no resultado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Filtrar por situação inativa
    Given que existem tipos de participante ativos e inativos
    When seleciono a situação "Inativo"
    Then o sistema exibe apenas os tipos de participante inativos

  Scenario: Busca sem resultados
    Given que nenhum tipo de participante corresponde ao termo buscado
    When realizo a busca
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Tipo de Participante | entrada do usuário | editável | texto | não | filtro por correspondência parcial |
| Situação | dado de código | entrada do usuário | editável | lista (Todas, Ativo, Inativo) | não | padrão: Todas |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Nome | Tipo de Participante | padrão ↑ |
| Descrição | Tipo de Participante | — |
| Situação | Tipo de Participante | ordenável |
| Permite equipe | derivado (oferta) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Oferta | lê | A coluna *Permite equipe* do resultado vem da oferta do tipo (subgrupo do arquivo lógico Tipo de Participante) |

---

## Comportamento de tela

### Onde fica
Página própria em `/tipos-participante` (Catálogo de Tipos de Participante): campo de busca por nome, seletor de situação e a lista paginada de resultados.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (filtros são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de tipos de participante correspondentes |
| Empty state | Sem tipos cadastrados: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O catálogo lista tipos de participante com filtro por nome e por situação (Ativo/Inativo/Todas) | Tela B (HU-006) |
| SC-02 | A busca por parte do nome retorna os tipos cujo nome contém o termo | cenário "Buscar tipo por parte do nome" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Pesquisar Tipos de Participante | principal | SE | 1 | 8 | Simples | 4 | 2026-02-28 |

> No baseline, o processo elementar se chama *Pesquisar Tipo de Participante*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Pesquisar Tipos de Participante** — SE · ALR 1 · DER 8 · Simples · 4 PF

```json
{"pe": "Pesquisar Tipos de Participante",
 "alr": ["Tipo de Participante"],
 "der": ["Nome", "Situação (filtro)", "Descrição", "Formulário", "Qtd Campos", "Situação (coluna)", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Tipo de Participante` — a lista traz nome, descrição e situação de cada tipo, com o formulário e a quantidade de campos, que são subgrupos do mesmo arquivo lógico

⚠️ A planilha conta *Situação* duas vezes, no filtro e na coluna do resultado. Pelo CPM o mesmo DER conta uma vez; ficou como o baseline contou, a confirmar com a equipe de métricas.

⚠️ A planilha enumera *Formulário* e *Qtd Campos*, que o N3 não traz em `## Colunas do resultado`, e não conta *Permite equipe*, que o N3 traz. A divergência entre a tela documentada e a medida vai à equipe de métricas.

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa da HU na `## Origem` (a HU não numera critério para a pesquisa), coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e o DER *Situação* desambiguado entre filtro e coluna. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-006 |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
