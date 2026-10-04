<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-EMA-01
feature_set: CFG-EMA
dominio: CFG
entidade: Configuração de E-mail da Premiação
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#configuracao-de-e-mail-da-premiacao
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

# Consultar Modelos de E-mail
> **Nível 3** - Feature Set: Modelos de E-mail — Domínio: Configuração da Premiação - `CFG-EMA-01`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador consultar os cinco tipos de e-mail transacional da edição, cada um com sua severidade e situação, como ponto de partida para editar e pré-visualizar o modelo.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)* (Lista de Modelos de E-mail)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada edição do prêmio tem o seu próprio conjunto de modelos de e-mail, independente das demais edições.
2. Os modelos configuráveis são sempre os cinco tipos transacionais da edição — quatro do fluxo de validação e um da devolutiva: ajuste solicitado, inscrição aprovada, inscrição rejeitada, devolução ao administrador e **feedback disponível**. *(o quinto entrou na Sprint 6)*
3. A severidade de cada tipo é fixa e indica a natureza do e-mail: aviso, sucesso, perigo e informação.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Listar os modelos de e-mail da edição
  Given que acesso a seção de modelos de e-mail de uma edição
  When a seção é carregada
  Then o sistema exibe os cinco tipos de e-mail com o rótulo, a severidade e a situação de cada um

Scenario: Identificar o tipo pela severidade
  Given que estou na lista de modelos de e-mail
  When observo o tipo "Inscrição rejeitada"
  Then o sistema exibe a severidade "perigo" associada a esse tipo

# ── Estados especiais ──────────────────────────────────────────

Scenario: Selecionar um tipo para edição
  Given que estou na lista de modelos de e-mail
  When seleciono o tipo "Ajuste solicitado"
  Then o sistema abre o modelo desse tipo para edição
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Premiação | contexto da edição | somente leitura | seleção → Premiação | — | edição cujos modelos de e-mail são consultados |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Tipo de e-mail | Configuração de E-mail da Premiação | ordem fixa |
| Severidade | derivado (tipo de e-mail) | — |
| Situação | Configuração de E-mail da Premiação | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Seção própria em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)* (Lista de Modelos de E-mail): um cartão para cada um dos cinco tipos, com ícone, rótulo, indicador de severidade e a ação de editar.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto os modelos são recuperados |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os cinco tipos de e-mail com severidade e situação |
| Empty state | Não se aplica (os cinco tipos existem sempre) |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A seção exibe os cinco tipos de e-mail com rótulo, severidade e situação | HU-021 (Visualizar Templates de E-mail) |
| SC-02 | Cada tipo pode ser aberto para edição a partir da lista | HU-021 (Editar Template de E-mail) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Template de E-mail (implícita) | CE | 1 | 6 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Template de E-mail (implícita)** — ALR (1): Premiação. DER (6): Tipo de E-mail · Assunto do E-mail · Corpo do E-mail · Placeholders · Ação · Mensagem.

```json
{"pe": "Consultar Template de E-mail (implícita)",
 "alr": ["Premiação"],
 "der": ["Tipo de E-mail", "Assunto do E-mail", "Corpo do E-mail", "Placeholders", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do tipo **Feedback disponível** entre os modelos configuráveis. *Antes* eram quatro tipos, todos do fluxo de validação (ajuste solicitado, inscrição aprovada, inscrição rejeitada, devolução ao administrador) — o e-mail da devolutiva não existia. *Agora* são **cinco**: o novo `FEEDBACK_ETAPA_DISPONIVEL`, criado pela migração V00034 em cada premiação ativa, é editável como os demais. O número de tipos é quantidade de linhas, não DER — sem Δ PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-021 |

---

*Feature Set: Modelos de E-mail · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
