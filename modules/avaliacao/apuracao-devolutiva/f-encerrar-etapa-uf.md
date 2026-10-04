<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-03
feature_set: AVL-APU
dominio: AVL
entidade: Fechamento de Etapa por UF
data_model_ref: data-models/avaliacao.md#fechamento-de-etapa-por-uf
endpoints: []
error_codes: []
depende_de: [AVL-APU-01, AVL-APU-02]
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

# Encerrar Etapa por UF
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-03`

## Descrição
Permite ao administrador encerrar oficialmente uma etapa em um estado, registrando responsável, data e observação, e consolidar as inscrições classificadas daquele estado, que são as que avançam para a etapa seguinte.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`PDTIC25093-49`](../../../analise-impacto/AIM-PDTIC25093-49.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/fechamento-etapa/:etapaId` (fechamento por estado) ⚠️ *(rota derivada do data-model; a pré-condição de feedback consolidado, as pendências por participante e o encerramento automático vêm da demanda SP05 — HU "Fechar Etapa de Avaliação")*

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`

---

</div>

## Regras de negócio

1. O fechamento de uma etapa é registrado por estado; o fechamento sem estado corresponde ao bloco Nacional, que reúne as inscrições sem estado definido. ⚠️ *(UF nula = bloco Nacional, conforme data-model — a confirmar)*
2. Cada estado tem no máximo um fechamento por etapa.
3. Todo fechamento registra o responsável e a data do fechamento, e admite uma observação do responsável.
4. O fechamento consolida as inscrições classificadas do estado, que são as que avançam para a etapa seguinte; a marca de premiada é independente da classificação e não determina o avanço. *(confirmado com a liderança do prêmio em 2026-09-01; até a SP05 a regra dizia que avançavam as premiadas)*
5. Um estado só é fechado quando todas as suas inscrições na etapa têm o feedback consolidado; a inscrição **desclassificada** está dispensada dessa condição e não gera pendência de fechamento. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)
6. As pendências que impedem o fechamento de um estado são apuradas por participante e têm três naturezas: inscrição sem avaliadores alocados, avaliação ainda em andamento e feedback ainda não consolidado.
7. Um estado só é fechado quando não resta empate atravessando a linha de corte de classificação nem a de premiação daquele estado. → ver `AVL-APU-02` (Registrar Desempate).
8. O feedback consolidado das inscrições de um estado fechado permanece bloqueado para edição enquanto o estado estiver fechado. → ver `AVL-PAI-03` (Consolidar Avaliação).
9. A etapa é encerrada quando o último estado pendente dela é fechado.
10. Um estado fechado volta à apuração apenas por reabertura administrativa. → ver `AVL-APU-12` (Reabrir Etapa por UF).
11. O fechamento grava a inscrição desclassificada como **não classificada**, qualquer que fosse a sua colocação antes da desclassificação. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)
12. A reabertura de um estado **apaga o registro do fechamento anterior**: o estado volta a figurar como nunca fechado, sem responsável, data nem observação do fechamento desfeito. *(decidido em 2026-09-01; a consequência aceita é que não fica trilha dos fechamentos anteriores de um mesmo estado)*

---

## Cenários

```gherkin
Feature: Encerrar Etapa por UF

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Encerrar a etapa em um estado
    Given que todas as inscrições do estado têm feedback consolidado e não há empate na linha de corte
    When encerro a etapa naquele estado
    Then o sistema registra o fechamento com o responsável e a data e consolida as inscrições classificadas do estado, e exibe "Registro salvo com sucesso."

  Scenario: Somente as classificadas avançam
    Given que o estado tem uma inscrição premiada que ficou fora do corte de classificação
    When encerro a etapa naquele estado
    Then o sistema libera para a etapa seguinte apenas as inscrições classificadas e mantém a premiada não classificada fora do avanço

  Scenario: Encerrar a etapa com observação
    Given que estou encerrando a etapa em um estado
    When informo uma observação de 200 caracteres e confirmo o fechamento
    Then o sistema grava a observação junto do fechamento do estado

  Scenario: Encerramento automático da etapa
    Given que resta um único estado pendente na etapa
    When encerro a etapa naquele estado
    Then o sistema encerra a etapa inteira e apresenta a etapa na situação Fechada

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Estado já encerrado na etapa
    Given que a etapa já foi encerrada no estado
    When tento encerrar novamente a etapa naquele estado
    Then o sistema mantém o fechamento existente e não cria um segundo fechamento para o estado

  Scenario: Feedback consolidado bloqueado após o fechamento
    Given que encerrei a etapa em um estado
    When abro o feedback consolidado de uma inscrição daquele estado
    Then o sistema apresenta o feedback bloqueado para edição

  # ── Erros de validação ─────────────────────────────────────────

  # ← MESSAGE-DICTIONARY: AVL_FECHAMENTO_PENDENCIAS
  Scenario: Estado com pendências de feedback
    Given que o estado tem inscrições sem avaliadores, com avaliação em andamento ou com feedback não consolidado
    When tento encerrar a etapa naquele estado
    Then o sistema não encerra, relaciona as pendências por participante e exibe "Este estado ainda tem inscrições sem feedback consolidado. Resolva as pendências antes de fechar."

  # ← MESSAGE-DICTIONARY: AVL_FECHAMENTO_EMPATE_CORTE
  Scenario: Empate pendente na linha de corte do estado
    Given que há inscrições empatadas na linha de corte de classificação do estado
    When tento encerrar a etapa naquele estado
    Then o sistema não encerra e exibe "Há empate na linha de corte deste estado. Resolva o desempate antes de fechar."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de fechamento
    Given que meu perfil não tem permissão para encerrar a etapa
    When tento encerrar a etapa no estado
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Tipo | Obrigatório | Validação |
|---|---|---|---|---|
| Estado | entrada do usuário | seleção → UF | não | ausência de estado representa o bloco Nacional ⚠️ |
| Observação | entrada do usuário | texto | não | máximo de 500 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data do fechamento | Data e hora do encerramento | Ao encerrar a etapa no estado |
| Responsável | Autor do fechamento | Ao encerrar a etapa no estado |
| Situação da etapa | Fechada | Quando o último estado pendente da etapa é fechado |

---

## Comportamento de tela

### Onde fica
No fechamento da etapa em `/avaliacao-admin/fechamento-etapa/:etapaId`, cada bloco de estado traz a ação de encerrar aquele estado, com um campo de observação opcional, e mostra o responsável e a data quando o estado já está fechado. Antes de encerrar, o bloco relaciona as pendências por participante — inscrição sem avaliadores, avaliação em andamento e feedback não consolidado —, e o contador de estados fechados sobre o total acompanha o andamento até o último estado, quando a etapa passa à situação Fechada. ⚠️ *(layout derivado da demanda SP05 — protótipo não fornecido)*

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação de encerrar desabilitada com indicador enquanto grava |
| Erro de validação | Relaciona as pendências por participante com "Este estado ainda tem inscrições sem feedback consolidado. Resolva as pendências antes de fechar." ou sinaliza o empate com "Há empate na linha de corte deste estado. Resolva o desempate antes de fechar." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e apresenta o estado como fechado, com responsável e data |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O encerramento do estado registra responsável e data e consolida as inscrições classificadas do estado | cenário "Encerrar a etapa em um estado" |
| SC-02 | Uma inscrição premiada fora do corte de classificação não avança para a etapa seguinte | cenário "Somente as classificadas avançam" |
| SC-03 | Estado com qualquer inscrição sem feedback consolidado não é fechado, e as pendências ficam visíveis por participante | cenário "Estado com pendências de feedback" |
| SC-04 | Estado com empate na linha de corte não é fechado | cenário "Empate pendente na linha de corte do estado" |
| SC-05 | O fechamento do último estado pendente encerra a etapa | cenário "Encerramento automático da etapa" |
| SC-06 | Um estado já encerrado não recebe um segundo fechamento na mesma etapa | cenário "Estado já encerrado na etapa" |
| SC-07 | O feedback consolidado das inscrições de um estado fechado deixa de ser editável | cenário "Feedback consolidado bloqueado após o fechamento" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Encerrar Etapa por UF | EE | 4 | 10 | Alta | 6 | 2026-09-01 |

### Memória de cálculo

**Encerrar Etapa por UF** — EE. Formas de lógica: 1 (pendências de feedback e empates na linha de corte), 5, 6 (grava o fechamento e consolida as classificadas), 7, 8, 11 (relaciona as pendências por participante), 12. Intenção primária: manter ALI.

```json
{"pe": "Encerrar Etapa por UF",
 "alr": ["Avaliação de Inscrição", "Inscrição", "Premiação", "Usuário"],
 "der": ["Estado", "Observação", "Data do fechamento", "Responsável", "Situação da etapa", "Participante com pendência", "Natureza da pendência", "Estados fechados sobre o total", "Mensagem", "Ação"]}
```
- **ALR (4)**: Avaliação de Inscrição *(grava o fechamento do estado; lê a apuração, os empates e o feedback consolidado)* · Inscrição *(as pendências são apuradas por participante)* · Premiação *(a Etapa e a sua situação, que passa a Fechada no último estado)* · Usuário *(a UF do estado fechado e o responsável)*.
- **DER (10)** — entrada (2): Estado · Observação. Saída (6): Data do fechamento · Responsável · Situação da etapa · Participante com pendência · Natureza da pendência · Estados fechados sobre o total · Mensagem · Ação.
- **Fora da contagem**: as três naturezas de pendência são valores de um mesmo DER, não três; o encerramento automático da etapa é efeito do mesmo PE, não um processo à parte. A dispensa de feedback consolidado para a inscrição desclassificada (regra 5, 2026-10-04) é forma de lógica de processamento, não DER — o PE segue com 10 DER e **6 PF**.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Restrição** aliviada e **inclusão** do destino da inscrição desclassificada. *Antes* a regra 5 exigia feedback consolidado de **todas** as inscrições do estado, sem exceção, de modo que uma inscrição retirada da disputa ainda travava o fechamento. *Agora* a desclassificada está dispensada e não gera pendência (RN5), e o fechamento a grava como não classificada seja qual fosse a sua colocação (RN11 nova; a antiga 11 passa a 12). Sem Δ DER — a dispensa é lógica de processamento |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **6 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Especificação (docqui) | Referência atualizada | A regra 10 deixa de marcar `AVL-APU-12` **Reabrir Etapa por UF** como feature sem N3 — o N3 foi escrito nesta data |
| 2026-09-01 | Decisões de produto (docqui) | Regras confirmadas | Confirmado com a liderança do prêmio que **quem avança é o classificado** — a RN4 deixa de ser leitura a confirmar. Decidido que a reabertura **apaga o registro do fechamento**, sem trilha do fechamento anterior: entra como regra 11 e dispensa a coluna de situação que estava em estudo |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Fechamento por estado exige feedback consolidado em todas as inscrições, com pendências por participante; encerramento automático da etapa no último estado; trava de consolidação do escopo fechado; correção da regra de avanço (avança o classificado, não o premiado) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do data-model (Fechamento de Etapa por UF) — HU de fechamento não fornecida ⚠️ |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
