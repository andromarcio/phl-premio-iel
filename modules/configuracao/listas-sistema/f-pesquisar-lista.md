<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-LIS-01
feature_set: CFG-LIS
dominio: CFG
entidade: Lista do Sistema
data_model_ref: data-models/configuracao.md#lista-do-sistema
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-012_Listas_do_Sistema
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

# Pesquisar Listas
> **Nível 3** - Feature Set: Listas do Sistema — Major Feature Set: Configuração da Premiação - `CFG-LIS-01`

## Descrição
Permite ao administrador localizar listas de valores por nome e por código, com paginação, para consulta, edição ou configuração de seus itens.

Na tela Listas do Sistema, o administrador informa o nome, o código ou os dois e aciona "Filtrar" — ou "Limpar", para voltar à lista completa — e vê a tabela paginada de dez em dez, de onde abre a edição ou a exclusão de cada lista.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-012_Listas_do_Sistema`](../../../hus/HU-012_Listas_do_Sistema.docx) | Criação | — RF-01 da HU: tabela paginada de dez em dez com Código e Nome, filtros de nome e de código que voltam à primeira página e "Limpar" para a lista completa |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/listas-sistema` (Lista de Listas do Sistema)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A busca retorna apenas listas ativas; listas removidas por exclusão lógica ficam fora do resultado.
2. A busca pode usar o nome e o código isoladamente ou em conjunto.
3. O código é o identificador único de negócio da lista e é usado como critério de busca exato. ⚠️ *(HU-012 não detalha correspondência parcial vs. exata do código — confirmar)*

---

## Cenários

```gherkin
Feature: Pesquisar Listas

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar listas ao abrir a tela
    Given que existem listas cadastradas no sistema
    When acesso a tela de Listas do Sistema
    Then o sistema exibe a lista de registros com código e nome

  Scenario: Filtrar por nome
    Given que existe a lista "UFs do Brasil"
    When informo "UF" no campo de filtro por nome e busco
    Then o sistema exibe a lista "UFs do Brasil" no resultado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Filtrar por código
    Given que existe a lista de código "UF_BRASIL"
    When informo "UF_BRASIL" no campo de filtro por código e busco
    Then o sistema exibe a lista correspondente ao código

  Scenario: Busca sem resultados
    Given que nenhuma lista corresponde aos filtros informados
    When realizo a busca
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome | Lista do Sistema | entrada do usuário | editável | texto | não | filtro por correspondência parcial |
| Código | Lista do Sistema | entrada do usuário | editável | texto | não | filtro por código |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Código | Lista do Sistema | padrão ↑ |
| Nome | Lista do Sistema | ordenável |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página própria em `/configuracao-premiacao/listas-sistema` (Lista de Listas do Sistema): filtros de nome e código, botões de filtrar e limpar, e a tabela paginada com 10 registros por página.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (filtros são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de registros correspondentes |
| Empty state | Sem listas cadastradas: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A tela lista os registros com filtros de nome e de código e paginação de 10 por página | Critério de aceite RF-01 (HU-012) |
| SC-02 | Ao aplicar um filtro, a busca é reiniciada e apenas os registros correspondentes são exibidos | Critério de aceite RF-01 (HU-012) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Pesquisar Listas | principal | CE | 1 | 4 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Pesquisar Listas do Sistema*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Pesquisar Listas** — CE · ALR 1 · DER 4 · Simples · 3 PF

```json
{"pe": "Pesquisar Listas",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Listas do Sistema` — a busca lê as listas ativas, com nome e código, filtradas pelos critérios informados; nome e código são filtro e coluna ao mesmo tempo e contam uma vez cada

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU na `## Origem` citados pelo RF (a HU-012 agrupa os critérios de aceitação por RF-01 a RF-08, sem numeração `CA-n`; a célula abre com `—`), coluna Entidade em `## Campos`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
