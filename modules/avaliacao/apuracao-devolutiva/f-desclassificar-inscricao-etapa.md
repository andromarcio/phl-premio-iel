<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-13
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: [AVL-APU-01, AVL-APU-03]
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

# Desclassificar Inscrição na Etapa
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-13`

## Descrição
Permite ao Administrador Nacional retirar uma inscrição da disputa de uma etapa, com justificativa registrada, para que ela não avance nem ocupe posição no resultado daquele estado — e devolvê-la à disputa enquanto o estado continuar aberto.

A desclassificação é um **estado binário reversível**: a mesma linha do ranking oferece a ação de desclassificar quando a inscrição está em disputa e a de reverter quando está desclassificada. Por isso as duas vivem nesta feature, como par de alternância — ver `engine/FEATURE-DEFINITION.md`, *Pares de alternância (toggle)*.

A necessidade nasce de uma situação concreta da premiação: uma mesma instituição de ensino pode concorrer em vários estados, mas só pode seguir **uma vez** para a etapa nacional. Sem um meio de retirar a inscrição excedente, o resultado de um estado levaria adiante um concorrente repetido. A desclassificação resolve isso sem apagar a inscrição nem a sua avaliação: a inscrição continua existindo, com as notas que recebeu, apenas fora da disputa.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Fechamento de Etapa (`/avaliacao-admin/fechamento-etapa/:etapaId`), botão "Desclassificar" em cada linha do ranking

**Fidelidade ao protótipo**: n/a *(o protótipo de fechamento não representa a desclassificação — entrega de 2026-10-01, posterior ao desenho)*

---

</div>

## Regras de negócio

1. Só o Administrador Nacional desclassifica uma inscrição.
2. A desclassificação só é admitida enquanto a etapa e o estado da inscrição estão abertos. → ver `AVL-APU-03` (Encerrar Etapa por UF)
3. Toda desclassificação exige justificativa, de até 100 caracteres.
4. Toda desclassificação registra quem a fez e quando.
5. A inscrição desclassificada sai da disputa do seu bloco: perde a colocação e passa a figurar ao fim do bloco. → ver `AVL-APU-01` (Apurar Resultado da Etapa), regra 11
6. A desclassificação recalcula de imediato a colocação das demais inscrições do bloco e as linhas de corte de classificação e de premiação. → ver `AVL-APU-01` (Apurar Resultado da Etapa), regra 12
7. A inscrição desclassificada não exige feedback consolidado para que o seu estado seja fechado. → ver `AVL-APU-03` (Encerrar Etapa por UF), regra 5
8. O fechamento do estado grava a inscrição desclassificada como não classificada. → ver `AVL-APU-03` (Encerrar Etapa por UF), regra 11
9. A inscrição desclassificada não recebe o e-mail de feedback da etapa. → ver `AVL-APU-14` (Enviar Feedback ao Participante)
10. A desclassificação e a sua justificativa não são reveladas ao participante.
11. A desclassificação sobrevive à reabertura do estado e à da etapa: só a reversão a desfaz. → ver `AVL-APU-12` (Reabrir Etapa por UF), regra 9
12. A reversão da desclassificação devolve a inscrição à disputa do seu bloco e é admitida enquanto o estado está aberto.
13. A reversão apaga o registro da desclassificação — a justificativa, a data e o responsável —, de modo que não fica trilha das desclassificações anteriores de uma mesma inscrição. ⚠️ *(mesma consequência aceita no fechamento por UF, regra 11 de `AVL-APU-03`; confirmar com o produto se a premiação precisa dessa trilha)*
14. A reversão recalcula de imediato a colocação do bloco e as duas linhas de corte, como a desclassificação.

---

## Cenários

```gherkin
Feature: Desclassificar Inscrição na Etapa

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Desclassificar a inscrição excedente de uma instituição
    Given que sou Administrador Nacional e a etapa está aberta no estado da inscrição
    And que a instituição já avança para a etapa nacional por outro estado
    When desclassifico a inscrição informando a justificativa
    Then o sistema retira a inscrição da disputa do bloco e a apresenta ao fim dele, sem colocação
    And recalcula a colocação das demais e as linhas de corte de classificação e de premiação

  Scenario: Reverter a desclassificação de uma inscrição
    Given que uma inscrição do bloco está desclassificada e o estado continua aberto
    When reverto a desclassificação
    Then o sistema devolve a inscrição à disputa do bloco, com colocação
    And recalcula a colocação das demais e as linhas de corte de classificação e de premiação

  Scenario: Consultar a justificativa de uma desclassificação
    Given que uma inscrição do bloco está desclassificada
    When consulto a marca de desclassificada daquela inscrição
    Then o sistema apresenta a justificativa registrada na desclassificação

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Desclassificar sem justificativa
    Given que estou desclassificando uma inscrição
    When confirmo sem informar a justificativa
    Then o sistema não desclassifica e exibe "Campo obrigatório."

  Scenario: Justificativa acima do limite
    Given que estou desclassificando uma inscrição
    When informo uma justificativa com mais de 100 caracteres
    Then o sistema não desclassifica e exibe "Máximo de 100 caracteres."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Estado já fechado
    Given que o estado da inscrição já foi fechado na etapa
    When tento desclassificar a inscrição
    Then o sistema não oferece a desclassificação

  Scenario: Desclassificação preservada pela reabertura
    Given que uma inscrição foi desclassificada e o estado foi fechado e depois reaberto
    When consulto o bloco do estado reaberto
    Then o sistema apresenta a inscrição ainda desclassificada
    And oferece a reversão da desclassificação

  Scenario: Fechamento com inscrição desclassificada sem feedback
    Given que a única inscrição sem feedback consolidado do estado está desclassificada
    When encerro a etapa naquele estado
    Then o sistema encerra o estado e grava a inscrição desclassificada como não classificada

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Administrador Regional tenta desclassificar
    Given que sou Administrador Regional
    When acesso o ranking da etapa no meu estado
    Then o sistema não oferece a desclassificação

  Scenario: Participante não enxerga a desclassificação
    Given que a minha inscrição foi desclassificada na etapa
    When acompanho a minha inscrição
    Then o sistema não informa a desclassificação nem a sua justificativa
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Inscrição | Inscrição | seleção → linha do ranking | somente leitura | seleção → Inscrição | sim | a inscrição é a da linha de onde a ação parte |
| Justificativa da desclassificação | Apuração por Etapa | entrada do usuário | editável | texto | sim na desclassificação | até 100 caracteres; a reversão não pede justificativa |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Desclassificado | verdadeiro na desclassificação, falso na reversão | Ao confirmar a ação |
| Data da desclassificação | data e hora da confirmação; vazia na reversão | Ao confirmar a ação |
| Usuário da desclassificação | administrador autenticado; vazio na reversão | Ao confirmar a ação |
| Nome de quem desclassificou | nome do administrador autenticado; vazio na reversão | Ao confirmar a ação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Apuração por Etapa | grava | Guarda a desclassificação, a justificativa, a data e o responsável — regras 3 e 4 |
| Inscrição | lê | Identifica a inscrição retirada da disputa — regra 5 |
| Fechamento de Etapa por UF | lê | Confere se o estado da inscrição ainda está aberto — regra 2 |
| Premiação | lê | Dona da Etapa em que a inscrição é desclassificada — regra 2 |
| Etapa | lê | Confere se a etapa ainda está aberta — regra 2 |
| Usuário | lê | Resolve o perfil que autoriza a ação e o responsável registrado — regras 1 e 4 |

---

## Comportamento de tela

### Onde fica
No fechamento da etapa em `/avaliacao-admin/fechamento-etapa/:etapaId`, cada linha do ranking traz o botão "Desclassificar", oferecido apenas ao Administrador Nacional e apenas enquanto a etapa e o estado estão abertos. Acioná-lo abre um diálogo de confirmação que pede a justificativa, de até 100 caracteres. Confirmada a desclassificação, a linha recebe a marca de desclassificada — cuja justificativa aparece ao apontar para ela —, desce para o fim do bloco sem colocação, e o bloco é reordenado na hora: o próximo colocado sobe e as duas linhas de corte são recalculadas. A linha passa a oferecer "Reverter desclassificação", que a devolve à disputa e reordena o bloco de novo — o botão é contextual, e só um dos dois aparece por vez.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão desabilitado com indicador enquanto grava |
| Erro de validação | Justificativa vazia exibe "Campo obrigatório."; acima de 100 caracteres, "Máximo de 100 caracteres." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e apresenta o bloco reordenado — com a inscrição ao fim, na desclassificação, ou de volta à sua colocação, na reversão |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A inscrição desclassificada perde a colocação, vai ao fim do bloco e as linhas de corte são recalculadas na hora | cenário "Desclassificar a inscrição excedente de uma instituição" |
| SC-02 | Nenhuma desclassificação é gravada sem justificativa de até 100 caracteres | cenários "Desclassificar sem justificativa" e "Justificativa acima do limite" |
| SC-03 | A inscrição desclassificada não trava o fechamento do estado por falta de feedback consolidado | cenário "Fechamento com inscrição desclassificada sem feedback" |
| SC-04 | Só o Administrador Nacional desclassifica, e o participante não enxerga a desclassificação | cenários "Administrador Regional tenta desclassificar" e "Participante não enxerga a desclassificação" |
| SC-05 | A reversão devolve a inscrição à disputa e reordena o bloco | cenário "Reverter a desclassificação de uma inscrição" |
| SC-06 | A desclassificação sobrevive ao fechamento e à reabertura do estado | cenário "Desclassificação preservada pela reabertura" |

---

## Métricas de tamanho

> Contagem realizada em 2026-10-04 sobre este N3, para um processo elementar que **não existe no baseline APF** de 2026-02-28 — a capacidade foi entregue em 2026-10-01, na Sprint 6. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Desclassificar Inscrição na Etapa | EE | 4 | 8 | Alta | 6 | 2026-10-04 |
| Reverter Desclassificação da Inscrição | EE | 3 | 6 | Alta | 6 | 2026-10-04 |

### Memória de cálculo

**Desclassificar Inscrição na Etapa** — EE. Formas de lógica: 1 (justificativa obrigatória e limite de 100 caracteres), 2, 3 (só Nacional, só com etapa e estado abertos), 5, 6 (grava a desclassificação em *Apuração por Etapa*), 8, 9 (recalcula colocações e linhas de corte), 10. Intenção primária: manter ALI.

```json
{"pe": "Desclassificar Inscrição na Etapa",
 "alr": ["Avaliação de Inscrição", "Inscrição", "Premiação", "Usuário"],
 "der": ["Inscrição", "Justificativa da desclassificação", "Marca de desclassificada", "Colocação recalculada", "Linha de corte de classificação", "Linha de corte de premiação", "Mensagem", "Ação"]}
```
- **ALR (4)**: Avaliação de Inscrição *(grava o subgrupo Apuração por Etapa e lê o Fechamento de Etapa por UF para conferir o estado aberto — contam uma vez)* · Inscrição *(a inscrição retirada da disputa)* · Premiação *(a Etapa e a sua situação)* · Usuário *(o perfil que autoriza e o responsável gravado)*.
- **DER (8)** — entrada (2): Inscrição · Justificativa da desclassificação. Saída (4): Marca de desclassificada · Colocação recalculada · Linha de corte de classificação · Linha de corte de premiação. Padrão (2): Mensagem · Ação.
- **Fora da contagem**: a justificativa é o mesmo DER na entrada e na apresentação ao apontar a marca, e conta uma vez; a data e o responsável são campos automáticos do mesmo PE, não dados que o usuário informe; a dispensa de feedback consolidado no fechamento (regra 7) é lógica de `AVL-APU-03` (Encerrar Etapa por UF), não DER desta transação.

**Reverter Desclassificação da Inscrição** — EE. Formas de lógica: 1 (só com o estado aberto), 2, 3, 5, 6 (apaga a desclassificação em *Apuração por Etapa*), 8, 9 (recalcula colocações e linhas de corte), 10. Intenção primária: manter ALI.
- **ALR (3)**: Avaliação de Inscrição *(apaga a desclassificação no subgrupo Apuração por Etapa e lê o Fechamento de Etapa por UF para conferir o estado aberto)* · Inscrição *(a inscrição devolvida à disputa)* · Premiação *(a Etapa)*. Não referencia Usuário: a reversão **não** grava responsável — ela apaga o da desclassificação (regra 13).
- **DER (6)** — entrada (1): Inscrição. Saída (3): Colocação restituída · Linha de corte de classificação · Linha de corte de premiação. Padrão (2): Mensagem · Ação.
- **Fora da contagem**: a reversão não pede justificativa, então o DER da justificativa não entra; apagar data e responsável é efeito do mesmo PE, não dado que atravesse a fronteira.

**Total: 12 PF** (2 processos elementares).

⚠️ **Uma decisão de granularidade cabe à métrica.** Os dois processos elementares foram contados **separados** porque a lógica de processamento e os dados que atravessam a fronteira diferem: a desclassificação valida e grava uma justificativa obrigatória de até 100 caracteres, com responsável e data; a reversão não recebe justificativa e apaga os três. É o que separa este par do caso clássico de *toggle* contado como um só processo elementar — `CFG-CAT-05` (Ativar/Inativar Categoria), em que as duas direções movem o mesmo campo com os mesmos dados. Se a métrica entender que a alternância é um processo elementar único, a feature vale **6 PF** em vez de 12.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature criada | N3 negocial da desclassificação manual e da sua reversão, derivado do resumo de entrega da Sprint 6 (entrega de 2026-10-01, migração **V00035**). Capacidade sem especificação até aqui. As duas direções vivem numa feature só, como **par de alternância** de um estado binário, e o verbo `desclassificar` foi registrado em `global/VOCABULARY-OVERRIDES.md`. Dois processos elementares contados sobre este N3 — **12 PF** (EE 4×8 e EE 3×6, ambos Alta). ⚠️ Pendente de validação pela equipe de métricas, inclusive quanto a serem dois PE ou um |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
