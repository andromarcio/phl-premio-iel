<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-ACO-02
feature_set: INS-ACO
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [INS-ACO-01]
origem:
  tipo: issue
  chave: HU-016_Dashboard_Participante
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

# Visualizar Devolutiva
> **Nível 3** - Feature Set: Acompanhamento — Major Feature Set: Inscrição - `INS-ACO-02`

## Descrição
Permite ao participante ler a devolutiva consolidada da avaliação de uma inscrição em cada etapa avaliada, a partir do momento em que aquela etapa a libera.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-016_Dashboard_Participante`](../../../hus/HU-016_Dashboard_Participante.docx) | Criação | — |
| [`PDTIC25093-69`](../../../analise-impacto/AIM-PDTIC25093-69.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/inscricao/minha/:inscricaoId?tab=feedbacks` (Devolutiva da Inscrição).

**Fidelidade ao protótipo**: referência — `prototypes/inscricao/acompanhamento/flow.html`

---

</div>

## Regras de negócio

1. A devolutiva é produzida por etapa avaliada: uma inscrição que percorre mais de uma etapa tem uma devolutiva própria em cada uma, com liberação independente.
2. A devolutiva de uma etapa está disponível ao participante quando duas condições se somam: a consolidação da avaliação daquela inscrição naquela etapa está concluída e a liberação da etapa já ocorreu.
3. A etapa sem data de liberação do feedback informada libera a devolutiva no momento em que a consolidação é concluída. → ver `AVL-ETA-02` (campo Liberação do feedback)
4. A etapa com data de liberação do feedback informada libera a devolutiva a partir dessa data, ainda que a consolidação tenha sido concluída antes.
4a. A existência de uma devolutiva ainda não liberada não é revelada ao participante, nem a data prevista da sua liberação. *(alterado na Sprint 6 — até então a etapa pendente era anunciada com o aviso "disponível a partir de…")*
5. A devolutiva consolida os pareceres da avaliação da inscrição, produzidos no domínio Avaliação. → ver `AVL-PAI-03` (Consolidar Avaliação)
6. O texto da devolutiva permanece alterável pela administração enquanto o estado da inscrição não é fechado naquela etapa; a partir do fechamento, é definitivo. ⚠️ *(uma devolutiva liberada antes do fechamento pode, portanto, mudar depois de lida — confirmar com o produto se a liberação deve aguardar o fechamento do estado)*
7. Cada participante visualiza apenas a devolutiva das próprias inscrições.
8. A consolidação da devolutiva com apoio de Inteligência Artificial passa por revisão humana antes da liberação. ⚠️ *(recurso apoiado por IA em evolução, conforme o N0)*

---

## Cenários

```gherkin
Feature: Visualizar Devolutiva

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Etapa sem data de liberação, com a consolidação concluída
    Given que a etapa não tem data de liberação do feedback informada
    And que a consolidação da avaliação da minha inscrição naquela etapa foi concluída
    When acesso a devolutiva da inscrição
    Then o sistema apresenta a devolutiva consolidada daquela etapa

  Scenario: Etapa com data de liberação já alcançada
    Given que a etapa tem data de liberação do feedback informada e essa data já chegou
    And que a consolidação da avaliação da minha inscrição naquela etapa foi concluída
    When acesso a devolutiva da inscrição
    Then o sistema apresenta a devolutiva consolidada daquela etapa

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Consolidação concluída antes da data de liberação
    Given que a consolidação da minha inscrição já foi concluída
    And que a etapa tem data de liberação do feedback ainda no futuro
    When acesso a devolutiva da inscrição
    Then o sistema não apresenta aquela etapa

  Scenario: Consolidação ainda não concluída
    Given que a etapa não tem data de liberação do feedback informada
    And que a consolidação da avaliação da minha inscrição ainda não foi concluída
    When acesso a devolutiva da inscrição
    Then o sistema informa que a devolutiva ainda não está disponível

  Scenario: Etapas com liberações diferentes
    Given que a minha inscrição foi avaliada na etapa regional e na etapa nacional
    And que apenas a etapa regional já liberou a devolutiva
    When acesso a devolutiva da inscrição
    Then o sistema apresenta a devolutiva da etapa regional e não apresenta a etapa nacional

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Devolutiva de inscrição de outro participante
    Given que a inscrição pertence a outro participante
    When tento acessar a devolutiva
    Then o sistema não permite o acesso à devolutiva
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Etapa | Avaliação (etapa avaliada) | somente leitura | texto | — | uma devolutiva por etapa avaliada |
| Devolutiva | Avaliação (consolidação) | somente leitura | texto longo | — | apresentada apenas quando a etapa já liberou |
| Liberada em | Avaliação (etapa) | somente leitura | data | — | data em que a etapa liberou |
| Situação da inscrição | Inscrição | somente leitura | lista | — | reflete o estado atual da inscrição avaliada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Tela de devolutiva em `/inscricao/minha/:inscricaoId?tab=feedbacks`, alcançada a partir do acompanhamento da inscrição. Apresenta uma seção por etapa avaliada **já liberada**, na ordem da premiação, cada uma com o texto consolidado e a data da liberação. A etapa que ainda não liberou simplesmente não aparece — o cartão "disponível a partir de…" foi removido na Sprint 6. O texto consolidado é apresentado sem qualquer marca de ter sido gerado com apoio de Inteligência Artificial: a etiqueta "Gerado por I.A." foi removida desta tela em 2026-09-23.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera a devolutiva |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta a devolutiva consolidada da avaliação |
| Empty state | Nenhuma etapa liberada ainda: informa que a devolutiva não está disponível, sem antecipar data |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Concluída a consolidação, a etapa sem data de liberação apresenta a devolutiva ao participante | cenário "Etapa sem data de liberação, com a consolidação concluída" |
| SC-02 | A etapa ainda não liberada não é apresentada ao participante, nem com data prevista, mesmo já consolidada | cenário "Consolidação concluída antes da data de liberação" |
| SC-03 | A devolutiva não é apresentada enquanto a consolidação não é concluída | cenário "Consolidação ainda não concluída" |
| SC-04 | Etapas com liberações diferentes são apresentadas de forma independente | cenário "Etapas com liberações diferentes" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Remoção** do anúncio da etapa pendente e da marca de IA. *Antes* a tela listava **todas** as etapas avaliadas: a liberada com o texto, a pendente com o cartão "disponível a partir de…" e a data prevista — e o texto consolidado vinha com a etiqueta "Gerado por I.A.". *Agora* só a etapa já liberada aparece (RN4a); a pendente não é anunciada, nem com data, e o estado vazio não antecipa data. A etiqueta de IA saiu da tela em 2026-09-23. +1 regra, 2 cenários e 1 critério reescritos |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Revisão contra o sistema (docqui) | Feature alterada | Regra de liberação da devolutiva: por etapa, condicionada à consolidação e à data de liberação do feedback da etapa |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-016 |

---

*Feature Set: Acompanhamento · Major Feature Set: Inscrição · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
