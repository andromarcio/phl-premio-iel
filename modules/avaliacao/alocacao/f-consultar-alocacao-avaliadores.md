<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-01
feature_set: AVL-ALO
dominio: AVL
entidade: Alocação de Avaliadores
data_model_ref: data-models/avaliacao.md#alocação-de-avaliadores
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-025_Alocar_Avaliadores
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

# Consultar Alocação de Avaliadores
> **Nível 3** - Feature Set: Alocação de Avaliadores — Major Feature Set: Avaliação - `AVL-ALO-01`

## Descrição
Permite ao administrador consultar, por premiação e etapa, cada grupo de avaliação — categoria, modalidade, tipo de participante e submodalidade — com a quantidade de inscrições e o pool de avaliadores já autorizado, situando o trabalho de alocação daquela etapa.

No menu Avaliação › Alocação por Grupo, o administrador escolhe a premiação e a etapa e vê a matriz com uma linha por grupo, com informações como as inscrições do grupo, os avaliadores no pool e a situação do pool.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-025_Alocar_Avaliadores`](../../../hus/HU-025_Alocar_Avaliadores.docx) | Criação | — funcionalidade "Alocar Pool de Avaliadores por Grupo" da HU, que não numera critérios: a consulta, por premiação e etapa, dos grupos com a quantidade de inscrições e o pool atual de cada um |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/alocacao-matriz` (Alocação por Grupo): seletor de premiação e etapa e a matriz de grupos com inscrições e pool.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/alocacao/flow.html` *(aparece como contexto do fluxo, não como assunto dele)*

---

</div>

## Regras de negócio

1. O grupo de avaliação é a combinação de categoria, modalidade, tipo de participante e submodalidade da oferta; a quantidade de inscrições exibida é a das inscrições ativas vinculadas ao grupo. → ver `AVL-ALO-04` (Alocar Avaliador à Inscrição), regra 7. *(a submodalidade foi acrescentada ao grupo em 2026-09-01: antes esta feature a omitia, e a definição divergia da usada na alocação por inscrição)*
2. Cada etapa da premiação tem o próprio pool por grupo; a consulta reflete o pool da etapa selecionada, independentemente das demais etapas.
3. O administrador regional alcança apenas os grupos cujas UFs estão vinculadas ao seu perfil; o administrador nacional alcança todos os grupos da premiação.

---

## Cenários

```gherkin
Feature: Consultar Alocação de Avaliadores

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Consultar os grupos de uma etapa
    Given que existem grupos com inscrições na premiação
    When seleciono a premiação e a etapa
    Then o sistema apresenta os grupos com a quantidade de inscrições e o pool atual de cada grupo

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Grupo ainda sem avaliadores no pool
    Given que um grupo da etapa não tem nenhum avaliador autorizado
    When consulto a etapa
    Then o grupo é apresentado com o pool vazio

  Scenario: Escopo do administrador regional
    Given que sou administrador regional vinculado a determinadas UFs
    When consulto a alocação de uma premiação
    Then o sistema apresenta apenas os grupos das UFs vinculadas ao meu perfil

  Scenario: Consulta sem resultados
    Given que nenhum grupo corresponde à premiação e etapa selecionadas
    When realizo a consulta
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | entrada do usuário | editável | seleção → Premiação | sim | premiações ativas; carrega a matriz de grupos ao selecionar |
| Etapa | Etapa | entrada do usuário | editável | seleção → Etapa | sim | etapas ativas da premiação selecionada |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Grupo (categoria × modalidade × tipo de participante) | derivado | padrão ↑ |
| Categoria | Categoria | — |
| Modalidade | Modalidade | — |
| Tipo de participante | Tipo de Participante | — |
| Inscrições no grupo | derivado (contagem) | ordenável |
| Avaliadores no pool | derivado (contagem) | — |
| Status do pool | derivado (Pool ativo, Sem avaliadores) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status do pool | Pool ativo | Quando o grupo tem ao menos um avaliador no pool |
| Status do pool | Sem avaliadores | Quando o pool do grupo está vazio |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Alocação de Avaliadores | lê | O pool de cada grupo na etapa selecionada alimenta a contagem de avaliadores e o status do pool (regra 2) |
| Categoria | lê | Compõe o grupo de avaliação e a coluna *Categoria* (regra 1) |
| Modalidade | lê | Compõe o grupo de avaliação e a coluna *Modalidade* (regra 1) |
| Tipo de Participante | lê | O tipo de participante e a submodalidade da oferta compõem o grupo e a coluna *Tipo de participante* (regra 1) |
| Inscrição | lê | As inscrições ativas vinculadas ao grupo alimentam a coluna *Inscrições no grupo* (regra 1) |
| Usuário | lê | As UFs vinculadas ao perfil recortam os grupos que o administrador regional alcança (regra 3); o vínculo por UF também identifica os avaliadores do pool (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao-admin/alocacao-matriz` (Alocação por Grupo): seletores de premiação e etapa no cabeçalho e a matriz com uma linha por grupo, trazendo a contagem de inscrições, a contagem do pool e a etiqueta de status.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a matriz é recuperada |
| Erro de validação | Não se aplica (seleção de premiação e etapa) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a matriz de grupos da etapa selecionada |
| Empty state | Sem grupos correspondentes: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A consulta lista, por premiação e etapa, os grupos com a contagem de inscrições e o pool atual | funcionalidade "Alocar Pool de Avaliadores por Grupo" (HU-025) |
| SC-02 | O administrador regional visualiza apenas os grupos das UFs vinculadas ao seu perfil | cenário "Escopo do administrador regional" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Alocação de Avaliadores | principal | SE | 5 | 21 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

**Consultar Alocação de Avaliadores** — SE · ALR 5 · DER 21 · Complexo · 7 PF

```json
{"pe": "Consultar Alocação de Avaliadores",
 "alr": ["Premiação", "Tipo Participante", "Categoria", "Modalidade", "Usuário"],
 "der": ["Premio", "Etapa", "Grupo", "Categoria", "Modalidade", "Tipo de Participante", "Status das Inscrições", "Total por status", "Percentual por status", "Total de Inscrições", "Qtd de Avaliadores", "Total avaliadores no pool", "Status pool", "Nome avaliador", "E-mail avaliador", "UF", "Qtd avaliações alocadas", "Qtd avaliações em andamento", "Qtd avaliações finalizadas", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a premiação e a etapa selecionadas no cabeçalho (a etapa é subgrupo da Premiação)
2. `Tipo Participante` — o tipo de participante e a submodalidade da oferta que compõem cada grupo
3. `Categoria` — a categoria que compõe cada grupo
4. `Modalidade` — a modalidade que compõe cada grupo
5. `Usuário` — os avaliadores do pool, com nome, e-mail e UF, e o recorte de UFs do administrador regional

⚠️ A tela também lê o pool (`Alocação Avaliadores`) e conta as inscrições do grupo (`Inscrição`), arquivos declarados em `## Dados lidos e gravados` que a planilha não enumera. Ficou o número da planilha — com ALR 5 a SE já está na faixa mais alta, e os dois arquivos não mudariam a complexidade; a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza da HU, que não numera critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com a enumeração antiga em lista retirada e o porquê de cada ALR em prosa. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/alocacao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Grupo corrigido | A **submodalidade** passa a compor o grupo, convergindo com `AVL-ALO-04` Alocar Avaliador à Inscrição, cuja definição foi conferida contra o código. Antes as duas leituras conviviam e mostravam grupos diferentes para a mesma premiação |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Alocação de Avaliadores · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
