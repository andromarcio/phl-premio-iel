---
id: CFG-LIS-01
feature_set: CFG-LIS
dominio: CFG
entidade: Lista do Sistema
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#lista-do-sistema
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

# Pesquisar Listas
> **Nível 3** - Feature Set: Listas do Sistema — Domínio: Configuração da Premiação - `CFG-LIS-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador localizar listas de valores por nome e por código, com paginação, para consulta, edição ou configuração de seus itens.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | não | filtro por correspondência parcial |
| Código | entrada do usuário | editável | texto | não | filtro por código |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Pesquisar Listas do Sistema | CE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Pesquisar Listas do Sistema** — ALR (1): Listas do Sistema. DER (4): Nome · Código · Ação · Mensagem.

```json
{"pe": "Pesquisar Listas do Sistema",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
