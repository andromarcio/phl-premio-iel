<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-12
feature_set: AVL-APU
dominio: AVL
entidade: Fechamento de Etapa por UF
data_model_ref: data-models/avaliacao.md#fechamento-de-etapa-por-uf
endpoints: []
error_codes: []
depende_de: [AVL-APU-03]
origem:
  tipo: issue
  chave: HU-030_Fechar_Etapa_Avaliacao
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

# Reabrir Etapa por UF
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-12`

## Descrição
Permite ao administrador devolver à apuração um estado cuja etapa já foi encerrada, desfazendo o fechamento daquele escopo para que o corte de classificação e o de premiação sejam recalculados.

A reabertura parte do próprio bloco do estado na tela de fechamento da etapa, onde o estado já encerrado apresenta a ação de reabrir; ao confirmar, o estado volta a figurar como nunca fechado e a etapa, se estava encerrada, volta à situação Aberta.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| `HU-030_Fechar_Etapa_Avaliacao` ⚠️ *(sem documento em `hus/`)* | Criação | — |
| [`PDTIC25093-49`](../../../analise-impacto/AIM-PDTIC25093-49.md) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Fechamento de Etapa (`/avaliacao-admin/fechamento-etapa/:etapaId`), pela ação de reabrir no bloco de um estado já encerrado ⚠️ *(rota herdada de `AVL-APU-03` Encerrar Etapa por UF; layout da ação derivado da demanda SP05 — protótipo não fornecido)*

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`

---

</div>

## Regras de negócio

1. Somente um estado com a etapa já encerrada naquele escopo é reaberto.
2. A reabertura apaga o registro do fechamento do estado: o estado volta a figurar como nunca fechado, sem responsável, data nem observação do fechamento desfeito. *(decidido em 2026-09-01; a consequência aceita é que não fica trilha dos fechamentos anteriores de um mesmo estado)* → ver `AVL-APU-03` (Encerrar Etapa por UF), regra 11.
3. A reabertura devolve o estado à apuração: o corte de classificação e o de premiação daquele estado passam a ser recalculados. → ver `AVL-APU-01` (Apurar Resultado da Etapa).
4. A reabertura desfaz as decisões de desempate registradas no escopo reaberto; as decisões dos demais estados da etapa permanecem. → ver `AVL-APU-02` (Registrar Desempate).
5. O feedback consolidado das inscrições do estado é preservado pela reabertura e volta a ser editável. → ver `AVL-PAI-03` (Consolidar Avaliação).
6. A etapa encerrada volta à situação Aberta quando qualquer um dos seus estados é reaberto.
7. Um estado não é reaberto enquanto houver etapa posterior da premiação já encerrada.
8. A reabertura alcança um estado por vez; reabrir a etapa inteira exige reabrir cada um dos seus estados.
9. A reabertura **preserva** a desclassificação das inscrições do estado: a inscrição desclassificada continua fora da disputa, e desfazer isso exige a reversão própria. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)

---

## Cenários

```gherkin
Feature: Reabrir Etapa por UF

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Reabrir a etapa em um estado
    Given que a etapa está encerrada em um estado e nenhuma etapa posterior foi encerrada
    When reabro a etapa naquele estado
    Then o sistema desfaz o fechamento do estado, devolve-o à apuração e exibe "Registro salvo com sucesso."

  Scenario: Reabertura devolve a etapa à situação Aberta
    Given que a etapa inteira estava encerrada
    When reabro a etapa em um dos seus estados
    Then o sistema apresenta a etapa na situação Aberta

  Scenario: Reabertura preserva o feedback consolidado
    Given que reabri a etapa em um estado
    When abro o feedback consolidado de uma inscrição daquele estado
    Then o sistema apresenta o texto consolidado preservado e novamente editável

  Scenario: Reabertura desfaz o desempate do escopo reaberto
    Given que a etapa tem desempates registrados em dois estados e reabro apenas um deles
    When consulto os desempates da etapa
    Then o sistema desfez os desempates do estado reaberto e manteve os do outro estado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Estado que não está encerrado
    Given que a etapa não foi encerrada naquele estado
    When observo o bloco do estado
    Then o sistema não oferece a ação de reabrir

  Scenario: Fechamento anterior não fica registrado
    Given que reabri a etapa em um estado já fechado antes
    When consulto o estado
    Then o sistema o apresenta como nunca fechado, sem responsável, data nem observação do fechamento desfeito

  # ── Erros de validação ─────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_REABERTURA_ETAPA_POSTERIOR
  Scenario: Etapa posterior já encerrada
    Given que uma etapa posterior da premiação já foi encerrada
    When tento reabrir a etapa em um estado
    Then o sistema não reabre e exibe "Há etapa posterior já encerrada nesta premiação. Reabra as etapas seguintes antes de reabrir este estado."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de reabertura
    Given que meu perfil não tem permissão para reabrir a etapa
    When tento reabrir a etapa no estado
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Estado | UF | seleção → UF | somente leitura | seleção → UF | sim | o estado é o do bloco de onde a reabertura parte; ausência de estado corresponde ao bloco Nacional ⚠️ |

⚠️ *A reabertura não registra justificativa nem observação: como a regra 2 apaga o registro do fechamento e nenhuma outra entidade guarda a reabertura, não há onde gravá-la. Se o produto quiser motivo registrado, é preciso decidir onde persistir — o que reabre a definição de modelo apontada em `arquivos/demandas/ANALISE_IMPACTO_SP05.md`.*

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação da etapa | Aberta | Ao reabrir qualquer estado de uma etapa encerrada |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Fechamento de Etapa por UF | grava | Apaga o registro do fechamento do estado reaberto — regra 2 |
| Etapa | lê e grava | Devolve a etapa encerrada à situação Aberta — regra 6 e o campo automático correspondente |
| Premiação | lê | Verifica se há etapa posterior já encerrada, que impede a reabertura — regra 7 |
| Apuração por Etapa | grava | Devolve o estado à apuração: os cortes de classificação e de premiação daquele escopo voltam a ser recalculados — regra 3 |
| Critério/Decisão de Desempate | grava | Desfaz as decisões de desempate do escopo reaberto — regra 4 |
| Inscrição | lê | Identifica as inscrições do estado reaberto cuja desclassificação é preservada — regra 9 |

---

## Comportamento de tela

### Onde fica
No fechamento da etapa em `/avaliacao-admin/fechamento-etapa/:etapaId`, o bloco de um estado já encerrado — que mostra o responsável e a data do fechamento — traz a ação de reabrir aquele estado, com confirmação antes de efetivar. Reaberto o estado, o bloco volta a apresentar as inscrições em apuração e a ação de encerrar, o contador de estados fechados sobre o total é reduzido e a etapa, se estava encerrada, volta à situação Aberta. ⚠️ *(layout derivado da demanda SP05 — protótipo não fornecido)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de reabrir desabilitada com indicador enquanto grava |
| Erro de validação | Sinaliza a etapa posterior encerrada com "Há etapa posterior já encerrada nesta premiação. Reabra as etapas seguintes antes de reabrir este estado." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e apresenta o estado de volta em apuração, sem responsável nem data de fechamento |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A reabertura de um estado devolve-o à apuração e remove o registro do fechamento anterior | cenário "Reabrir a etapa em um estado" |
| SC-02 | A reabertura de qualquer estado devolve a etapa encerrada à situação Aberta | cenário "Reabertura devolve a etapa à situação Aberta" |
| SC-03 | O feedback consolidado das inscrições do estado sobrevive à reabertura e volta a ser editável | cenário "Reabertura preserva o feedback consolidado" |
| SC-04 | Os desempates desfeitos são apenas os do estado reaberto | cenário "Reabertura desfaz o desempate do escopo reaberto" |
| SC-05 | Nenhum estado é reaberto enquanto houver etapa posterior encerrada | cenário "Etapa posterior já encerrada" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Reabrir Etapa por UF | EE | 3 | 4 | Média | 4 | 2026-09-01 |

### Memória de cálculo

**Reabrir Etapa por UF** — EE. Formas de lógica: 1 (recusa quando há etapa posterior encerrada), 5, 6 (apaga o registro do fechamento, devolve a apuração ao recálculo e desfaz os desempates do escopo), 7, 12. Intenção primária: manter ALI.

```json
{"pe": "Reabrir Etapa por UF",
 "alr": ["Avaliação de Inscrição", "Premiação", "Usuário"],
 "der": ["Estado", "Situação da etapa", "Mensagem", "Ação"]}
```
- **ALR (3)**: Avaliação de Inscrição *(o Fechamento de Etapa por UF apagado, a Apuração por Etapa devolvida ao recálculo e as Decisões de Desempate desfeitas são todos subgrupos deste ALI — contam uma vez)* · Premiação *(a Etapa que volta a Aberta e as etapas posteriores conferidas)* · Usuário *(a UF do estado reaberto)*.
- **DER (4)** — entrada (1): Estado. Saída (1): Situação da etapa · Mensagem · Ação.
- **Fora da contagem**: a preservação da desclassificação na reabertura (regra 9, 2026-10-04) é forma de lógica de processamento, não DER — o PE segue com 4 DER e **4 PF**.
- **Fora da contagem**: a reabertura não registra justificativa nem observação — a regra 2 apaga o registro do fechamento e não há onde gravá-la; o feedback consolidado é preservado sem cruzar a fronteira.

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do que a reabertura faz com a desclassificação. *Antes* a reabertura desfazia o fechamento e os desempates do estado e preservava o feedback consolidado — a desclassificação não existia, logo nada dizia sobre ela. *Agora* a RN9 fixa que a reabertura **preserva** a desclassificação, e desfazê-la exige a reversão própria. Sem Δ DER — é lógica de processamento |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **4 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada em `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`, no fluxo que já cobre a tela onde ela acontece — fidelidade **referência** |
| 2026-09-01 | Especificação (docqui) | Feature criada | N3 negocial da reabertura de etapa por estado, entrega da SP05 (`PDTIC25093-49` · HU-030) que estava sem spec. Incorpora a decisão de produto de 2026-09-01: a reabertura **apaga o registro do fechamento**, sem trilha do fechamento anterior. O ID é `AVL-APU-12` porque `AVL-APU-07` e `AVL-APU-11` foram aposentados pela unificação de gerar+exportar e não são reutilizados |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-09-01*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
