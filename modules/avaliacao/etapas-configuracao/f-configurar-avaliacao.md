<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ETA-01
feature_set: AVL-ETA
dominio: AVL
entidade: Premiação
data_model_ref: data-models/configuracao.md#premiação
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-024_Configurar_Etapas_de_Avaliacao
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

# Configurar Avaliação
> **Nível 3** - Feature Set: Etapas e Configuração da Avaliação — Major Feature Set: Avaliação - `AVL-ETA-01`

## Descrição
Permite ao administrador definir o modo de avaliação da edição — confidencial ou aberta —, habilitar a exibição da média de etapas anteriores ao avaliador e fixar a quantidade de avaliadores por inscrição, valores que valem para toda a premiação.

Na aba "Avaliação & Etapas" da configuração da premiação, o administrador marca "Avaliação confidencial" ou "Avaliação aberta", liga ou desliga a exibição da média de etapas anteriores, informa a quantidade de avaliadores por inscrição e aciona "Salvar configurações".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-024_Configurar_Etapas_de_Avaliacao`](../../../hus/HU-024_Configurar_Etapas_de_Avaliacao.docx) | Criação | — bloco de configuração da aba *Avaliação & Etapas* da HU: avaliação confidencial ou aberta, mutuamente exclusivas, exibição da nota agregada de etapas anteriores e quantidade de avaliadores por inscrição única para a premiação |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)* (aba Avaliação & Etapas, bloco de configuração do modo de avaliação)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/etapas-configuracao/flow.html`

---

</div>

## Regras de negócio

1. O modo de avaliação da premiação é único e binário: a avaliação é confidencial ou aberta, nunca as duas formas ao mesmo tempo. ⚠️ *(no modelo de dados o modo é um único indicador `confidencialAvaliador`; as opções "Avaliação confidencial" e "Avaliação aberta" são as duas faces desse mesmo indicador)*
2. No modo confidencial, o avaliador não tem acesso à identidade do participante (nome, empresa ou equipe) e enxerga apenas o protocolo, o projeto, as respostas da inscrição e os anexos.
3. No modo aberto, o avaliador tem acesso a todos os dados do participante.
4. A nota individual de um avaliador nunca fica acessível a outro avaliador; quando a exibição da média de etapas anteriores está habilitada, apenas a média agregada do participante fica disponível ao avaliador da etapa seguinte.
5. A quantidade de avaliadores por inscrição é única para toda a premiação e vale para todas as etapas.

---

## Cenários

```gherkin
Feature: Configurar Avaliação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Salvar o modo de avaliação como confidencial
    Given que estou na configuração de avaliação da premiação
    When marco "Avaliação confidencial" e salvo as configurações
    Then o sistema grava o modo de avaliação e exibe "Registro salvo com sucesso."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Alternar do modo confidencial para o aberto
    Given que a avaliação está marcada como confidencial
    When marco a opção "Avaliação aberta"
    Then o sistema mantém apenas "Avaliação aberta" selecionada e desmarca "Avaliação confidencial"

  Scenario: Habilitar a exibição da média de etapas anteriores
    Given que estou na configuração de avaliação da premiação
    When ligo "Mostrar nota agregada de etapas anteriores" e salvo
    Then o sistema grava a preferência e exibe "Registro salvo com sucesso."

  Scenario: Definir a quantidade de avaliadores por inscrição
    Given que estou na configuração de avaliação da premiação
    When informo 3 avaliadores por inscrição e salvo
    Then o sistema passa a designar até 3 avaliadores por inscrição em todas as etapas

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de configuração
    Given que meu perfil não tem permissão para configurar a avaliação
    When tento acessar a configuração de avaliação
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Avaliação confidencial | Premiação | entrada do usuário | editável | opção (Ligado/Desligado) | não | mutuamente exclusiva com "Avaliação aberta" |
| Avaliação aberta | Premiação | entrada do usuário | editável | opção (Ligado/Desligado) | não | mutuamente exclusiva com "Avaliação confidencial" |
| Mostrar nota agregada de etapas anteriores | Premiação | entrada do usuário | editável | opção (Ligado/Desligado) | não | quando ligada, o avaliador vê a média do participante nas etapas anteriores |
| Avaliadores por inscrição | Premiação | entrada do usuário | editável | número inteiro | não | valor único para toda a premiação; vale para todas as etapas |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Avaliação confidencial | Desligado | Enquanto o administrador não define o modo |
| Mostrar nota agregada de etapas anteriores | Desligado | Enquanto o administrador não altera a preferência |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Etapa | lê | A aba aberta pela consulta apresenta as etapas da premiação junto do modo de avaliação (ALR do baseline na consulta que abre a tela) |
| Tipo de Participante | lê | A aba apresenta as questões de avaliação de cada tipo de participante, com tipo, título, enunciado e peso (ALR do baseline na consulta que abre a tela) |

---

## Comportamento de tela

### Onde fica
Bloco de configuração no topo da aba "Avaliação & Etapas" em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Avaliação & Etapas**)*: as opções de confidencialidade, a preferência de exibição da média anterior, o campo de avaliadores por inscrição e o botão "Salvar configurações".

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar configurações" desabilitado com indicador enquanto grava |
| Erro de validação | Não se aplica (opções e quantidade têm valores padrão) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O modo de avaliação é salvo como confidencial ou aberto, um excluindo o outro | cenário "Alternar do modo confidencial para o aberto" |
| SC-02 | A quantidade de avaliadores por inscrição definida passa a valer para todas as etapas | cenário "Definir a quantidade de avaliadores por inscrição" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Configurações Avaliação e Etapas (implícita) | acessório | SE | 2 | 16 | Médio | 5 | 2026-02-28 |
| Configurar Avaliação | principal | EE | 1 | 6 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Alterar Configurações Avaliações e Etapas*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Consultar Configurações Avaliação e Etapas (implícita)** — SE · ALR 2 · DER 16 · Médio · 5 PF

```json
{"pe": "Consultar Configurações Avaliação e Etapas (implícita)",
 "alr": ["Premiação", "Tipo de Participante"],
 "der": ["Confidencialidade da avaliação", "Mostrar nota agregada", "Pontuação máxima por nota máxima", "Pontuação restante", "Número etapa", "Nome da etapa", "Período", "Status etapa", "Operador etapa", "Data liberação feedback", "Tipo de Participante", "Tipo da Questão", "Título da Questão", "Enunciado", "Peso / Nota", "Ação"]}
```

Por que cada ALR:
1. `Premiação` — as opções de avaliação da premiação e as etapas dela, com número, nome, período, situação, perfis autorizados e liberação do feedback
2. `Tipo de Participante` — as questões de avaliação de cada tipo de participante, com tipo, título, enunciado e peso, que a aba apresenta

A planilha abrevia o segundo DER como *Mostrar nota agregada...*; o nome na lista é o rótulo sem as reticências.

**Configurar Avaliação** — EE · ALR 1 · DER 6 · Simples · 3 PF

```json
{"pe": "Configurar Avaliação",
 "alr": ["Premiação"],
 "der": ["Confidencialidade da avaliação", "Mostrar nota agregada", "Pontuação máxima por nota máxima", "Pontuação restante", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a transação grava o modo de avaliação, a exibição da média de etapas anteriores e a pontuação na premiação

⚠️ A enumeração da planilha não traz *Avaliadores por inscrição*, que esta feature especifica em `## Campos`, e traz *Pontuação máxima por nota máxima* e *Pontuação restante*, que não constam dela. Ficaram os nomes e o número da planilha; a divergência vai à equipe de métricas.

**Total: 8 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); critérios em prosa na `## Origem`, porque a HU não numera critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A tela **Avaliação & Etapas**, que o fluxo já desenhava, passa a ser atribuída a esta feature — é nela que o modo de avaliação e a lista de etapas são configurados. Fidelidade **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-024 |

---

*Feature Set: Etapas e Configuração da Avaliação · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
