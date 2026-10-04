---
id: CFG-PRE-08
feature_set: CFG-PRE
dominio: CFG
entidade: Link Público
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#link-publico
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

# Consultar Links Públicos
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-08`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador visualizar os links públicos de inscrição já emitidos de uma edição, com o respectivo tipo de participante e endereço.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Dados** → botão “Links Públicos”)* (Links Públicos de Inscrição)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A consulta abrange os links públicos já emitidos da edição.
2. Cada link listado corresponde a um único tipo de participante da edição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Listar os links emitidos da edição
  Given que a edição já tem links públicos emitidos
  When acesso os Links Públicos da edição
  Then o sistema exibe os links com o tipo de participante e o endereço de cada um

# ── Estados especiais ──────────────────────────────────────────

Scenario: Edição ainda sem links emitidos
  Given que a edição ainda não tem nenhum link público emitido
  When acesso os Links Públicos da edição
  Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Prêmio | contexto da tela | somente leitura | seleção → Premiação | sim | edição cujos links públicos são consultados |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Tipo de participante | Link Público (via Tipo de Participante) | padrão ↑ |
| Endereço do link público | Link Público | — |
| Data de criação do link | Link Público | ordenável |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Tela Links Públicos de Inscrição (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Dados** → botão “Links Públicos”)*): apresenta a relação dos links já emitidos da edição, cada um com o tipo de participante, o endereço e um botão de cópia para a área de transferência.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto os links são recuperados |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a relação dos links emitidos da edição |
| Empty state | Sem links emitidos: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A tela relaciona os links públicos emitidos da edição com tipo de participante e endereço | cenário "Listar os links emitidos da edição" |
| SC-02 | Uma edição sem links emitidos apresenta o estado vazio, sem erro | cenário "Edição ainda sem links emitidos" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Links Públicos de Inscrição | CE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Links Públicos de Inscrição** — ALR (1): Premiação. DER (3): Tipo de Participante · URL · Ação.

```json
{"pe": "Consultar Links Públicos de Inscrição",
 "alr": ["Premiação"],
 "der": ["Tipo de Participante", "URL", "Ação"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
