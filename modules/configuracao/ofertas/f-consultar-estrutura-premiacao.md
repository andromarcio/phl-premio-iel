<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-VIN-01
feature_set: CFG-VIN
dominio: CFG
entidade: Oferta
data_model_ref: data-models/configuracao.md#oferta-tipo--modalidade--categoria
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-011_Vincular_Categoria_Modalidade_TipoParticipante
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

# Consultar Estrutura da Premiação
> **Nível 3** - Feature Set: Vínculos e Ofertas — Major Feature Set: Configuração da Premiação - `CFG-VIN-01`

## Descrição
Permite ao administrador navegar a hierarquia de uma edição — Premiação, Categorias, Modalidades e Tipos de Participante — para consultar como a estrutura está montada e escolher o nó sobre o qual agir.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-011_Vincular_Categoria_Modalidade_TipoParticipante`](../../../hus/HU-011_Vincular_Categoria_Modalidade_TipoParticipante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)* (Árvore de Configuração do Prêmio)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A estrutura da edição é hierárquica: a premiação contém categorias, cada categoria contém modalidades e cada modalidade contém tipos de participante.
2. Cada nó da estrutura corresponde a um vínculo vigente; um vínculo desfeito deixa de integrar a estrutura da edição.
3. A oferta que o inscrito enxerga é o caminho completo tipo de participante dentro de modalidade dentro de categoria de uma mesma edição.

---

## Cenários

```gherkin
Feature: Consultar Estrutura da Premiação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Navegar a hierarquia completa do prêmio
    Given que acesso a estrutura de um prêmio com categorias, modalidades e tipos de participante vinculados
    When percorro a hierarquia a partir da premiação
    Then o sistema exibe os níveis Premiação, Categorias, Modalidades e Tipos de Participante encadeados

  Scenario: Selecionar um nó para consulta
    Given que a estrutura do prêmio está carregada
    When seleciono o nó de uma categoria
    Then o sistema exibe os dados da categoria selecionada

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Prêmio ainda sem estrutura montada
    Given que o prêmio não tem categorias vinculadas
    When acesso a estrutura do prêmio
    Then o sistema exibe apenas o nó da premiação, sem níveis abaixo

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de acesso à estrutura
    Given que meu perfil não tem permissão para consultar a estrutura do prêmio
    When tento acessar a estrutura
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Prêmio | seleção → Premiação | somente leitura | seleção | sim | edição cuja estrutura hierárquica é navegada |
| Nó selecionado | entrada do usuário | editável | seleção na árvore | não | um dos nós da hierarquia da edição |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Nível | derivado (hierarquia) | — |
| Nome do nó | Categoria / Modalidade / Tipo de Participante | padrão ↑ |
| Situação | vínculo | — |
| Itens vinculados | derivado (contagem) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página própria em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(árvore de estrutura, à esquerda)*: uma árvore lateral com a hierarquia da edição e uma área central que mostra os dados do nó selecionado.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a estrutura é recuperada |
| Erro de validação | Não se aplica (navegação sem entrada obrigatória além da edição) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a hierarquia navegável e os dados do nó selecionado |
| Empty state | Prêmio sem categorias vinculadas: exibe apenas o nó da premiação |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A hierarquia Premiação > Categorias > Modalidades > Tipos de Participante é exibida a partir da edição selecionada | cenário "Navegar a hierarquia completa do prêmio" |
| SC-02 | Selecionar um nó exibe os dados correspondentes àquele nível | Critério de aceite 5 (HU-011) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Categorias (lista/pesquisa) | CE | 1 | 3 | Simples | 3 | 2026-02-28 |
| Consultar Modalidade (lista/pesquisa) | CE | 1 | 2 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Categorias (lista/pesquisa)** — ALR (1): Categoria. DER (3): Nome · Ação · Mensagem.

```json
{"pe": "Consultar Categorias (lista/pesquisa)",
 "alr": ["Categoria"],
 "der": ["Nome", "Ação", "Mensagem"]}
```
- **Consultar Modalidade (lista/pesquisa)** — ALR (1): Modalidade. DER (2): Modalidade · Ação.

```json
{"pe": "Consultar Modalidade (lista/pesquisa)",
 "alr": ["Modalidade"],
 "der": ["Modalidade", "Ação"]}
```

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
