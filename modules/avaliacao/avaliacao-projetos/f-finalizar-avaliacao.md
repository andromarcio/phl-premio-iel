<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-AVA-04
feature_set: AVL-AVA
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-AVA-03", "AVL-AVA-01"]
origem:
  tipo: issue
  chave: HU-028_Avaliar_Inscricao
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

# Finalizar Avaliação
> **Nível 3** - Feature Set: Avaliação de Projetos — Major Feature Set: Avaliação - `AVL-AVA-04`

## Descrição
Permite ao avaliador finalizar a avaliação depois de pontuar todas as questões e registrar o parecer, encerrando o registro em modo somente leitura e abrindo em seguida a próxima avaliação pendente da sua fila.

Na tela de avaliação da inscrição, com todas as questões pontuadas e o parecer escrito, o avaliador aciona "Finalizar avaliação" e confirma; concluída a finalização, aciona "Próxima pendente" para seguir à próxima avaliação da sua fila.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-028_Avaliar_Inscricao`](../../../hus/HU-028_Avaliar_Inscricao.docx) | Criação | — funcionalidade *Finalizar Avaliação* da HU: conclusão explícita com todas as questões pontuadas e parecer de no mínimo 50 caracteres, registro somente leitura depois dela e bloqueio com a etapa fechada |
| [`PDTIC25093-61`](../../../analise-impacto/AIM-PDTIC25093-61.md) | Alteração | — salto "Próxima pendente" após a finalização, restrito ao recorte vigente do acompanhamento, com aviso quando não resta pendência |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: a tela Avaliação da Inscrição (`/avaliacao/:alocacaoId`), pelo comando de finalizar.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/avaliacao-projetos/flow.html`

---

</div>

## Regras de negócio

1. A finalização exige que todas as questões do questionário estejam pontuadas.
2. A finalização exige o parecer do avaliador com no mínimo 50 caracteres não-brancos.
3. Depois de finalizada, a avaliação fica somente leitura para o avaliador e as notas não podem mais ser alteradas por ele.
4. A finalização não é permitida quando a etapa da inscrição está fechada.
5. A finalização registra o momento de conclusão e a transição de status da avaliação.
6. A fila de avaliações pendentes de um avaliador reúne exclusivamente as avaliações alocadas a ele que ainda não foram finalizadas.
7. A próxima avaliação pendente é a primeira da fila do avaliador, na mesma sequência e no mesmo recorte de premiação, etapa e status vigentes em Acompanhar Minhas Avaliações (`AVL-AVA-01`) — o salto nunca alcança avaliação fora desse recorte. *(confirmado em 2026-09-01: a fila do salto é a do painel, na mesma ordem de protocolo com que ele apresenta as pendentes)*
8. Uma avaliação finalizada só volta à fila de pendentes do avaliador se for reaberta.

---

## Cenários

```gherkin
Feature: Finalizar Avaliação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Finalizar avaliação completa
    Given que pontuei todas as questões e o parecer tem ao menos 50 caracteres
    When confirmo a finalização
    Then o sistema conclui a avaliação e deixa o registro somente leitura

  Scenario: Seguir para a próxima avaliação pendente
    Given que acabei de finalizar uma avaliação e ainda tenho avaliações não finalizadas no recorte vigente
    When aciono "Próxima pendente"
    Then o sistema abre a primeira avaliação não finalizada da minha fila, sem passar pelo Painel do Avaliador

  Scenario: Salto restrito ao recorte vigente
    Given que restringi minhas avaliações a uma premiação e a uma etapa e finalizo uma avaliação desse recorte
    When aciono "Próxima pendente"
    Then o sistema abre a próxima avaliação não finalizada do mesmo recorte e nunca uma avaliação fora dele

  # ── Erros de validação ─────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_FINALIZACAO_INCOMPLETA
  Scenario: Finalizar sem pontuar todas as questões
    Given que ainda há questões sem nota
    When tento finalizar a avaliação
    Then o sistema não finaliza e exibe "Pontue todas as questões antes de finalizar a avaliação."

  # ← MESSAGE-DICTIONARY: AVL_PARECER_MINIMO
  Scenario: Parecer abaixo do mínimo
    Given que pontuei todas as questões mas o parecer tem menos de 50 caracteres
    When tento finalizar a avaliação
    Then o sistema não finaliza e exibe "O parecer deve ter no mínimo 50 caracteres."

  # ── Estados especiais ──────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_SEM_PENDENTES
  Scenario: Nenhuma avaliação pendente restante
    Given que a avaliação que finalizei era a última não finalizada do recorte vigente
    When aciono "Próxima pendente"
    Then o sistema não abre outra avaliação e exibe "Não há mais avaliações pendentes."

  # ← MESSAGE-DICTIONARY: AVL_ETAPA_FECHADA
  Scenario: Etapa já encerrada
    Given que a etapa da inscrição está fechada
    When tento finalizar a avaliação
    Then o sistema não finaliza e exibe "A etapa foi encerrada; a avaliação não pode mais ser finalizada."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Parecer do avaliador | Avaliação de Inscrição | entrada do usuário | editável | texto longo | sim | mínimo de 50 caracteres não-brancos |
| Confirmação de finalização | Avaliação de Inscrição | entrada do usuário | editável | confirmação | sim | reconhece que as notas não poderão ser alteradas após finalizar |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status da avaliação | Finalizada | Na confirmação da finalização |
| Finalização da avaliação | Data e hora | Na confirmação da finalização |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Nota de Avaliação | lê | Confere se todas as questões do questionário estão pontuadas (regra 1) |
| Questionário | lê | O questionário de avaliação do tipo de participante, que define o conjunto de questões a pontuar (regra 1) |
| Questão de Avaliação | lê | As questões do questionário que precisam ter nota para a finalização (regra 1) |
| Etapa | lê | A situação da etapa da inscrição: etapa fechada impede a finalização (regra 4) |
| Histórico de Avaliação | grava | Recebe a transição de status da finalização (regra 5) |

---

## Comportamento de tela

### Onde fica
Na tela Avaliação da Inscrição (`/avaliacao/:alocacaoId`), o comando de finalizar fica disponível quando todas as questões estão pontuadas, com uma confirmação que informa que as notas não poderão ser editadas. Concluída a finalização, a própria tela oferece o comando "Próxima pendente", que substitui a inscrição em exibição pela próxima avaliação não finalizada do avaliador — sem retorno ao Painel do Avaliador e mantendo a premiação, a etapa e o status que ele havia selecionado lá; ao lado dele permanece o retorno ao painel.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Comando de finalizar desabilitado com indicador enquanto conclui |
| Erro de validação | Finalização indisponível enquanto houver questão sem nota ou parecer abaixo do mínimo |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Conclui a avaliação, passa o registro a somente leitura e habilita o comando "Próxima pendente" |
| Empty state | Sem avaliação pendente no recorte vigente, "Próxima pendente" exibe "Não há mais avaliações pendentes." e a tela permanece na avaliação concluída |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A avaliação só é finalizada com todas as questões pontuadas e parecer de no mínimo 50 caracteres | Regra de negócio (HU-028) |
| SC-02 | A finalização é impedida quando a etapa da inscrição está fechada | cenário "Etapa já encerrada" |
| SC-03 | Após finalizar, o avaliador abre a próxima avaliação não finalizada sem passar pelo painel | cenário "Seguir para a próxima avaliação pendente" |
| SC-04 | A próxima avaliação aberta pelo salto pertence ao mesmo recorte de premiação, etapa e status vigente no acompanhamento | cenário "Salto restrito ao recorte vigente" |
| SC-05 | Sem avaliação pendente restante, o salto informa o avaliador em vez de abrir outra avaliação | cenário "Nenhuma avaliação pendente restante" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Finalizar Avaliação | principal | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

**Finalizar Avaliação** — EE · ALR 1 · DER 3 · Simples · 3 PF

```json
{"pe": "Finalizar Avaliação",
 "alr": ["Avaliação de Inscrição"],
 "der": ["ID", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Avaliação de Inscrição` — a transação grava o status Finalizada, o momento da conclusão e a transição no histórico da avaliação, subgrupo do mesmo arquivo lógico

⚠️ A planilha conta ALR 1, mas a finalização confere antes as questões do questionário a pontuar e a situação da etapa (regras 1 e 4), leituras dos arquivos lógicos *Tipo de Participante* e *Premiação* que a enumeração não traz. Ficou o número da planilha; a divergência vai à equipe de métricas.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); critérios em prosa na `## Origem`, porque a HU não numera critérios; coluna Entidade em `## Campos`; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/avaliacao-projetos/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Fila confirmada | O produto confirmou que a fila do salto "Próxima pendente" é **a do painel** — mesmo recorte e mesma ordem de protocolo que o acompanhamento apresenta. A regra deixa de ser suposição |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Salto "Próxima pendente" após a finalização, restrito ao recorte vigente do acompanhamento, com aviso quando não resta pendência |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-028 |

---

*Feature Set: Avaliação de Projetos · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
