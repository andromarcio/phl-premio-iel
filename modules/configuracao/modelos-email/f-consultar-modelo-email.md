<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-EMA-01
feature_set: CFG-EMA
dominio: CFG
entidade: Configuração de E-mail da Premiação
data_model_ref: data-models/configuracao.md#configuracao-de-e-mail-da-premiacao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-021_Configurar_Templates_Email
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

# Consultar Modelos de E-mail
> **Nível 3** - Feature Set: Modelos de E-mail — Major Feature Set: Configuração da Premiação - `CFG-EMA-01`

## Descrição
Permite ao administrador consultar os cinco tipos de e-mail transacional da edição, cada um com sua severidade e situação, como ponto de partida para editar e pré-visualizar o modelo.

Na configuração da edição, a aba "Termos & E-mails" do nó Premiação mostra um cartão para cada tipo de e-mail, com ícone, rótulo e severidade, de onde o administrador abre o modelo para edição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-021_Configurar_Templates_Email`](../../../hus/HU-021_Configurar_Templates_Email.docx) | Criação | — funcionalidade "Visualizar Templates de E-mail" da HU (sem critérios numerados): os tipos de e-mail da premiação em cartões com ícone, rótulo e severidade |
| [`PDTIC25093-69`](../../../analise-impacto/AIM-PDTIC25093-69.md) | Alteração | — inclusão do quinto tipo, Feedback disponível, entre os modelos consultados |

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
Feature: Consultar Modelos de E-mail

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | exibido do cadastro | somente leitura | seleção → Premiação | — | edição cujos modelos de e-mail são consultados — o contexto da edição em configuração |

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

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Configuração de E-mail da Premiação | lê | Os modelos da edição, com o tipo e a situação de cada um, formam os cartões exibidos (regras 1 e 2) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Template de E-mail (implícita) | acessório | CE | 1 | 6 | Simples | 3 | 2026-02-28 |

> ⚠️ **Feature sem processo elementar `principal`.** A única linha da planilha é a consulta implícita que abre o diálogo de edição preenchido — os DER dela são o assunto, o corpo e os marcadores, que os cartões desta feature não mostram. Pela *Regra da consulta implícita* do `global/SIZING.md`, essa leitura fica com `CFG-EMA-02` — Editar Modelo de E-mail; e a consulta que esta feature realiza — os cartões com tipo, severidade e situação — não tem linha na planilha. Mover a linha muda a contagem por feature e é decisão da equipe de métricas; até lá, ela segue aqui como `acessório`, com o número do baseline.

### Memória de cálculo

**Consultar Template de E-mail (implícita)** — CE · ALR 1 · DER 6 · Simples · 3 PF

```json
{"pe": "Consultar Template de E-mail (implícita)",
 "alr": ["Premiação"],
 "der": ["Tipo de E-mail", "Assunto do E-mail", "Corpo do E-mail", "Placeholders", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a leitura traz o tipo, o assunto, o corpo e os marcadores do modelo, guardados na Configuração de E-mail da Premiação, subgrupo do arquivo lógico Premiação

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), conferência da HU na `## Origem` (a HU-021 não numera critérios) e prosa do ticket, coluna Entidade em `## Campos` (o Preenchimento "contexto da edição" do campo Premiação passa a "exibido do cadastro" e o contexto vai para a Validação), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON; a única linha da contagem é consulta implícita e ficou `acessório`, com ⚠️ de feature sem principal. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do tipo **Feedback disponível** entre os modelos configuráveis. *Antes* eram quatro tipos, todos do fluxo de validação (ajuste solicitado, inscrição aprovada, inscrição rejeitada, devolução ao administrador) — o e-mail da devolutiva não existia. *Agora* são **cinco**: o novo `FEEDBACK_ETAPA_DISPONIVEL`, criado pela migração V00034 em cada premiação ativa, é editável como os demais. O número de tipos é quantidade de linhas, não DER — sem Δ PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-021 |

---

*Feature Set: Modelos de E-mail · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
