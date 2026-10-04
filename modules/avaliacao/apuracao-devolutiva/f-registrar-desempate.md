<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-02
feature_set: AVL-APU
dominio: AVL
entidade: Decisão de Desempate
data_model_ref: data-models/avaliacao.md#decisao-de-desempate
endpoints: []
error_codes: []
depende_de: [AVL-APU-01]
origem:
  tipo: issue
  chave: PDTIC25093-49
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

# Registrar Desempate
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-02`

## Descrição
Permite ao administrador resolver o empate que atravessa a linha de corte de classificação ou a de premiação, comparando questão a questão as inscrições empatadas e elegendo a vencedora com justificativa e responsável registrados.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`PDTIC25093-49`](../../../analise-impacto/AIM-PDTIC25093-49.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/fechamento-etapa/:etapaId` (drawer de desempate da etapa) ⚠️ *(rota derivada do data-model; a comparação questão a questão e o desempate por corte vêm da demanda SP05 — HU "Fechar Etapa de Avaliação")*

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`

---

</div>

## Regras de negócio

1. Os critérios de desempate configurados na premiação são aplicados na ordem definida, questão a questão, até separar as inscrições empatadas.
2. A decisão manual de desempate cabe apenas quando o empate atravessa uma linha de corte da etapa — a de classificação ou a de premiação — e os critérios configurados não separaram as inscrições empatadas.
3. Cada decisão de desempate resolve um único corte, identificado como Classificação ou Premiação; o empate que atravessa os dois cortes exige uma decisão para cada corte.
4. Uma decisão de desempate abrange todas as inscrições empatadas naquele corte e elege exatamente uma vencedora entre elas.
5. A inscrição eleita vencedora ocupa a colocação acima da linha de corte que a decisão resolve; as demais inscrições empatadas ficam abaixo dessa linha.
6. Toda decisão manual de desempate registra a inscrição vencedora, a justificativa, o responsável e a data da decisão.
7. A justificativa da decisão tem no mínimo 30 e no máximo 1.000 caracteres.
8. A decisão manual é tomada sobre a comparação, questão a questão, das respostas e das notas das inscrições empatadas.
9. Enquanto houver empate não resolvido atravessando uma linha de corte, o estado correspondente permanece pendente de fechamento. → ver `AVL-APU-03` (Encerrar Etapa por UF).

---

## Cenários

```gherkin
Feature: Registrar Desempate

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Critérios configurados resolvem o empate
    Given que há inscrições empatadas na etapa
    When o sistema aplica os critérios de desempate configurados
    Then o sistema separa as inscrições pela ordem dos critérios sem exigir decisão manual

  Scenario: Registrar o desempate do corte de classificação
    Given que duas inscrições empatam na colocação da linha de corte de classificação e os critérios configurados não as separaram
    When comparo as respostas e as notas questão a questão, escolho a inscrição vencedora e informo uma justificativa de 120 caracteres
    Then o sistema grava a decisão como corte de Classificação, com a vencedora, a justificativa, o responsável e a data, e exibe "Registro salvo com sucesso."

  Scenario: Registrar o desempate do corte de premiação
    Given que duas inscrições empatam na colocação da linha de corte de premiação
    When escolho a inscrição vencedora e informo a justificativa
    Then o sistema grava a decisão como corte de Premiação e mantém a decisão de classificação daquelas inscrições inalterada

  Scenario: Empate que atravessa os dois cortes
    Given que o mesmo empate atravessa a linha de corte de classificação e a de premiação
    When registro a decisão do corte de classificação
    Then o sistema mantém o corte de premiação pendente de uma decisão própria

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Empate que não atravessa nenhum corte
    Given que duas inscrições empatam em colocação abaixo dos cortes da etapa
    When abro o resultado da etapa
    Then o sistema mantém o empate sinalizado e não exige decisão de desempate

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Decisão sem justificativa
    Given que estou registrando a decisão manual de desempate
    When deixo a justificativa em branco e confirmo
    Then o sistema não registra e exibe "Campo obrigatório."

  # ← MESSAGE-DICTIONARY: MIN_LENGTH (parâmetro: 30)
  Scenario: Justificativa abaixo do mínimo
    Given que estou registrando a decisão manual de desempate
    When informo uma justificativa de 20 caracteres e confirmo
    Then o sistema não registra e exibe "Mínimo de 30 caracteres."

  # ← MESSAGE-DICTIONARY: MAX_LENGTH (parâmetro: 1.000)
  Scenario: Justificativa acima do máximo
    Given que estou registrando a decisão manual de desempate
    When informo uma justificativa com mais de 1.000 caracteres e confirmo
    Then o sistema não registra e exibe "Máximo de 1.000 caracteres."

  Scenario: Decisão sem inscrição vencedora
    Given que estou comparando as inscrições empatadas
    When confirmo a decisão sem escolher a inscrição vencedora
    Then o sistema não registra e exibe "Campo obrigatório."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de desempate
    Given que meu perfil não tem permissão para registrar desempate
    When tento registrar a decisão
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Inscrição vencedora | entrada do usuário | seleção → Inscrição empatada | sim | exatamente uma inscrição entre as empatadas no corte |
| Justificativa | entrada do usuário | texto longo | sim | mínimo de 30 e máximo de 1.000 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Tipo de corte | Classificação ou Premiação, conforme a linha de corte em que o empate foi acionado | Ao registrar o desempate |
| Status decidido | Vencedora para a inscrição eleita; Perdedora para as demais inscrições da decisão | Ao registrar o desempate ⚠️ *(nomes do enum a confirmar no data-model)* |
| Responsável | Autor da decisão | Ao registrar o desempate |
| Data da decisão | Data e hora do registro | Ao registrar o desempate |

---

## Comportamento de tela

### Onde fica
No fechamento da etapa em `/avaliacao-admin/fechamento-etapa/:etapaId`, o empate sinalizado na linha de corte do bloco abre um painel lateral de comparação: as inscrições empatadas ficam lado a lado com as respostas e as notas de cada questão, e a decisão é registrada escolhendo a vencedora e escrevendo a justificativa. O painel é aberto por duas ações distintas — uma para o corte de classificação e outra para o corte de premiação —, e cada decisão gravada indica na tela qual corte resolveu. ⚠️ *(layout derivado da demanda SP05 — protótipo não fornecido)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de registrar desabilitada com indicador enquanto grava |
| Erro de validação | Destaca a justificativa com "Campo obrigatório.", "Mínimo de 30 caracteres." ou "Máximo de 1.000 caracteres." e sinaliza a ausência da inscrição vencedora |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a colocação decidida no bloco, com a marca de decisão manual |
| Empty state | Não se aplica (só há desempate quando há empate na linha de corte) |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Os critérios configurados são aplicados na ordem definida antes de qualquer decisão manual | cenário "Critérios configurados resolvem o empate" |
| SC-02 | A decisão manual grava a vencedora, a justificativa, o responsável, a data e o corte de Classificação que resolve | cenário "Registrar o desempate do corte de classificação" |
| SC-03 | A decisão do corte de premiação é gravada como Premiação e não altera a classificação das inscrições envolvidas | cenário "Registrar o desempate do corte de premiação" |
| SC-04 | Empate que atravessa os dois cortes exige uma decisão para cada corte | cenário "Empate que atravessa os dois cortes" |
| SC-05 | Empate que não atravessa corte algum não exige decisão manual | cenário "Empate que não atravessa nenhum corte" |
| SC-06 | Justificativa com menos de 30 caracteres é recusada | cenário "Justificativa abaixo do mínimo" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Registrar Desempate | EE | 3 | 8 | Alta | 6 | 2026-09-01 |

### Memória de cálculo

**Registrar Desempate** — EE. Formas de lógica: 1 (justificativa de 30 a 1.000 caracteres, exatamente uma vencedora), 5 (qual corte a decisão resolve), 6 (grava a decisão e as inscrições da decisão), 7, 8, 12. Intenção primária: manter ALI, com dados recebidos de fora da fronteira.

```json
{"pe": "Registrar Desempate",
 "alr": ["Avaliação de Inscrição", "Inscrição", "Tipo de Participante"],
 "der": ["Inscrição vencedora", "Justificativa", "Tipo de corte", "Status decidido", "Responsável", "Data da decisão", "Mensagem", "Ação"]}
```
- **ALR (3)**: Avaliação de Inscrição *(lê a apuração e as notas por questão; grava a decisão de desempate e as inscrições abrangidas — todos subgrupos deste ALI)* · Inscrição *(identifica as empatadas)* · Tipo de Participante *(as questões comparadas uma a uma, regras 1 e 8)*.
- **DER (8)** — entrada (2): Inscrição vencedora · Justificativa. Saída (4): Tipo de corte · Status decidido · Responsável · Data da decisão · Mensagem · Ação.
- **Fora da contagem**: os critérios de desempate configurados são lidos de subgrupo do mesmo ALI já contado; a comparação questão a questão é lógica interna do mesmo PE, não um segundo processo elementar.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **6 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Desempate por corte (classificação e premiação) restrito ao empate que atravessa a linha de corte; comparação questão a questão com escolha da vencedora; justificativa de 30 a 1.000 caracteres |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do data-model (Decisão de Desempate) — HU de fechamento não fornecida ⚠️ |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
