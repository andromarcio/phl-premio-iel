<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-PAI-02
feature_set: AVL-PAI
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [AVL-PAI-01]
origem:
  tipo: issue
  chave: HU-027_Painel_Administrativo_Avaliacoes
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

# Consultar Avaliações por Etapa
> **Nível 3** - Feature Set: Painel Administrativo de Avaliações — Major Feature Set: Avaliação - `AVL-PAI-02`

## Descrição
Permite ao administrador consultar o detalhe de uma inscrição em uma etapa, reunindo os avaliadores alocados, o parecer individual de cada um e as notas por questão, como base para a consolidação.

A partir da lista de avaliações, em Premiação › Avaliações, o administrador abre o detalhe de uma inscrição numa etapa, percorre a aba de cada avaliador, com o parecer e as notas, e, se quiser, abre a conferência das notas por questão.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-027_Painel_Administrativo_Avaliacoes`](../../../hus/HU-027_Painel_Administrativo_Avaliacoes.docx) | Criação | — funcionalidade "Visualizar Detalhe Administrativo da Avaliação" da HU, que não numera critérios: os avaliadores alocados com status e datas, o parecer individual somente leitura e a auditoria das notas por questão |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId` (Detalhe da Avaliação)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/painel-administrativo/flow.html`

---

</div>

## Regras de negócio

1. O detalhe reúne os avaliadores alocados para a inscrição na etapa, cada um com seu status individual: A iniciar, Em andamento e Finalizada.
2. O parecer individual de cada avaliador tem no mínimo 50 caracteres e é somente leitura para o administrador.
3. A conferência das notas relaciona, para cada questão do questionário, a nota atribuída por cada avaliador e o peso da questão.
4. A média ponderada de cada avaliador resulta das notas por questão e dos respectivos pesos.
5. A confidencialidade configurada na premiação não se aplica ao administrador; quando ela está ativa, a identidade dos avaliadores é apresentada como "Avaliador N".

---

## Cenários

```gherkin
Feature: Consultar Avaliações por Etapa

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Consultar o detalhe da avaliação
    Given que selecionei uma inscrição em uma etapa
    When abro o detalhe da avaliação
    Then o sistema apresenta os avaliadores alocados com status, datas e média ponderada individual

  Scenario: Consultar o parecer individual de um avaliador
    Given que estou no detalhe da avaliação
    When consulto o avaliador finalizado
    Then o sistema apresenta o parecer individual escrito por ele e as notas por questão

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Conferir as notas por questão
    Given que estou no detalhe da avaliação
    When abro a conferência de notas
    Then o sistema apresenta, para cada questão, a nota de cada avaliador e o peso da questão

  Scenario: Consultar avaliação com premiação confidencial
    Given que a premiação está configurada como confidencial
    When consulto o detalhe da avaliação
    Then o sistema apresenta os avaliadores como "Avaliador N" e mantém visíveis os pareceres e as notas

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de consulta
    Given que meu perfil não tem permissão para consultar avaliações
    When tento abrir o detalhe da avaliação
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Identificação do participante | Inscrição | exibido do cadastro | somente leitura | texto | — | identificador · protocolo, ou só o protocolo quando não há identificador |
| Premiação | Premiação | exibido do cadastro | somente leitura | texto | — | premiação da inscrição |
| Categoria | Categoria | exibido do cadastro | somente leitura | texto | — | apenas quando preenchida na inscrição |
| Modalidade | Modalidade | exibido do cadastro | somente leitura | texto | — | apenas quando preenchida na inscrição |
| Etapa atual | Etapa | exibido do cadastro | somente leitura | texto | — | ordem e nome da etapa |
| Avaliadores (finalizados / alocados) | derivado ↓ | calculado | somente leitura | texto | — | indica se todos finalizaram |

*Premiação, Categoria e Modalidade vêm da inscrição e aparecem juntas no cabeçalho, na forma Premiação · Categoria · Modalidade.*

---

## Derivações

| Campo derivado | Fórmula (Label PO) | Campos-fonte (Entidade) |
|---|---|---|
| Avaliadores (finalizados / alocados) | Quantidade de avaliadores com a avaliação Finalizada ÷ quantidade de avaliadores alocados à inscrição na etapa (regra 1) | Status da avaliação (Avaliação de Inscrição), Avaliador (Avaliação de Inscrição) |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Avaliador | Avaliação de Inscrição | padrão ↑ |
| Status | Avaliação de Inscrição | ordenável |
| Início da avaliação | Avaliação de Inscrição | — |
| Finalização da avaliação | Avaliação de Inscrição | — |
| Média ponderada | derivado (notas × pesos) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Avaliação de Inscrição | lê | Os avaliadores alocados à inscrição na etapa, com status, início, finalização e parecer individual (regras 1 e 2) |
| Nota de Avaliação | lê | A nota de cada avaliador por questão, na conferência de notas e na média ponderada (regras 3 e 4) |
| Questionário | lê | O questionário de avaliação da inscrição, que reúne as questões conferidas (regra 3) |
| Questão de Avaliação | lê | A questão e o peso de cada uma, na conferência de notas e na média ponderada (regras 3 e 4) |
| Apuração por Etapa | lê | O status da consolidação e o feedback consolidado mostrados no cabeçalho do detalhe |
| Alocação de Avaliadores | lê | Os avaliadores alocados (ALR do baseline) |
| Usuário | lê | A identificação dos avaliadores alocados (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página de detalhe em `/avaliacao-admin/avaliacoes/:inscricaoId/etapa/:etapaId`: cabeçalho com a identificação e as métricas de etapa, avaliadores e consolidação, uma aba somente leitura por avaliador com o parecer e as notas, e a conferência de notas por questão aberta sob demanda.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o detalhe é recuperado |
| Erro de validação | Não se aplica (consulta somente leitura) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta os avaliadores, os pareceres e as notas por questão |
| Empty state | Etapa sem avaliadores alocados: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe lista os avaliadores alocados com status, datas e média ponderada individual | cenário "Consultar o detalhe da avaliação" |
| SC-02 | A conferência de notas mostra a nota de cada avaliador por questão com o peso da questão | cenário "Conferir as notas por questão" |
| SC-03 | Em premiação confidencial, os avaliadores aparecem como "Avaliador N" sem ocultar pareceres e notas ao administrador | cenário "Consultar avaliação com premiação confidencial" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Avaliações por Etapa (lista de avaliadores) | principal | SE | 3 | 5 | Simples | 4 | 2026-02-28 |
| Consultar Avaliações por Etapa (detalhe) | principal | SE | 6 | 20 | Complexo | 7 | 2026-02-28 |

> No baseline, os processos elementares se chamam *Consultar Avaliações por Etapa* e *Visualizar Avaliações*; aqui levam o nome da feature com a variante entre parênteses, como pede o `global/SIZING.md` quando há mais de um `principal`. Os dois apresentam as avaliações da inscrição na etapa — um a lista resumida dos avaliadores, o outro o detalhe completo com pareceres e notas. Os números são os do baseline.

### Memória de cálculo

**Consultar Avaliações por Etapa (lista de avaliadores)** — SE · ALR 3 · DER 5 · Simples · 4 PF

```json
{"pe": "Consultar Avaliações por Etapa (lista de avaliadores)",
 "alr": ["Alocação Avaliadores", "Usuário", "Inscrição"],
 "der": ["Avaliador", "Data/hora finalização", "Qtd de questões", "Status", "Ação"]}
```

Por que cada ALR:
1. `Alocação Avaliadores` — os avaliadores alocados à inscrição na etapa
2. `Usuário` — a identificação de cada avaliador
3. `Inscrição` — a inscrição cujas avaliações são listadas

⚠️ Avaliador, finalização, quantidade de questões e status são também o que a árvore de `AVL-PAI-01` (Acompanhar Painel de Avaliações) mostra no nível do avaliador. Se a planilha mediu ali esta lista, o processo elementar pertence àquela feature; ficou onde o baseline o atribuiu, e mover é decisão da equipe de métricas.

**Consultar Avaliações por Etapa (detalhe)** — SE · ALR 6 · DER 20 · Complexo · 7 PF

```json
{"pe": "Consultar Avaliações por Etapa (detalhe)",
 "alr": ["Inscrição", "Premiação", "Alocação Avaliadores", "Usuário", "Avaliação de Inscrição", "Tipo de Participante"],
 "der": ["Inscrição", "Premiação", "Modalidade", "Categoria", "Etapa atual", "Qtd avaliações finalizadas/total avaliações", "Status da consolidação", "Inicial Avaliador", "Número Avaliador", "Nome Avaliador", "Status avaliação", "Qtd questões", "Nota da questão", "Número questão", "Descrição questão", "Feedback", "Feedback consolidado", "Status feedback consolidado", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Inscrição` — a identificação do participante, com categoria e modalidade da inscrição
2. `Premiação` — a premiação e a etapa atual (a etapa é subgrupo da Premiação)
3. `Alocação Avaliadores` — os avaliadores alocados, um por aba
4. `Usuário` — o nome ou a identificação de cada avaliador
5. `Avaliação de Inscrição` — o status, o parecer e as notas de cada avaliador, e o feedback consolidado com o seu status
6. `Tipo de Participante` — as questões do questionário, com número e descrição (o questionário é subgrupo do Tipo de Participante)

**Total: 11 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza da HU, que não numera critérios; coluna Entidade em `## Campos`, normalizada para as sete colunas do template, com o Preenchimento corrigido e a linha Premiação · Categoria · Modalidade separada em três; `## Derivações`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com os dois processos elementares principais levando o nome da feature e a variante entre parênteses. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/painel-administrativo/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-027 |

---

*Feature Set: Painel Administrativo de Avaliações · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
