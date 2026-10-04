<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-14
feature_set: AVL-APU
dominio: AVL
entidade: Disparo de Feedback
data_model_ref: data-models/avaliacao.md#disparo-de-feedback
endpoints: []
error_codes: []
depende_de: [AVL-APU-03, AVL-PAI-03]
origem:
  tipo: issue
  chave: PDTIC25093-69
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

# Enviar Feedback ao Participante
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-14`

## Descrição
Permite ao Administrador Nacional avisar por e-mail os participantes de uma etapa encerrada de que a devolutiva já está disponível, conferindo antes quem vai receber e acompanhando depois o que foi enviado.

Até aqui a devolutiva ficava à espera de o participante voltar ao sistema e procurá-la: a liberação era um estado que ele tinha de ir conferir. O envio fecha essa lacuna sem automatizar nada — quem decide o momento é o administrador, e o e-mail leva o participante de volta ao sistema, onde a devolutiva é lida com o contexto da etapa.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`PDTIC25093-69`](../../../analise-impacto/AIM-PDTIC25093-69.md) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/disparo-feedback` *(Disparo de Feedback)*, alcançada por ação no Painel de Avaliações (`/avaliacao-admin/avaliacoes`) ⚠️ *(rota derivada do nome do componente no resumo de entrega — a confirmar)*

**Fidelidade ao protótipo**: n/a *(tela nova, entrega de 2026-10-01 — posterior ao desenho dos protótipos)*

---

</div>

## Regras de negócio

1. Só o Administrador Nacional envia o feedback de uma etapa.
2. O envio alcança uma etapa de uma premiação por vez.
3. A etapa só tem o envio liberado quando está **inteiramente** encerrada: o fechamento de um estado isolado não basta. → ver `AVL-APU-03` (Encerrar Etapa por UF), regra 9
4. A etapa só tem o envio liberado quando a devolutiva daquela etapa já foi liberada ao participante. → ver `INS-ACO-02` (Visualizar Devolutiva), regras 3 e 4
5. Nenhum envio é automático: o aviso sai apenas por ação do administrador.
6. O participante que já recebeu o aviso daquela etapa, ou cujo aviso já está na fila de envio, fica fora da seleção proposta.
7. A inscrição desclassificada na etapa não recebe o aviso. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa), regra 9
8. Cada envio registra quem o fez, quando, o recorte escolhido e as quantidades de selecionados, de e-mails enfileirados e de participantes sem e-mail.
9. A situação de cada aviso assume um entre três valores: enviado, aguardando ou falha.
10. O participante sem e-mail cadastrado é contabilizado como falha de envio.
11. O aviso informa que a devolutiva da etapa está disponível e leva o endereço pelo qual o participante alcança o sistema; o texto da devolutiva não vai no e-mail. → ver `CFG-EMA-02` (Editar Modelo de E-mail), marcador `{{link_sistema}}`
12. O conteúdo do aviso vem do modelo de e-mail da premiação do tipo feedback disponível, editável pelo administrador. → ver `CFG-EMA-02` (Editar Modelo de E-mail)
13. O reenfileiramento alcança apenas os avisos cuja situação é falha.

---

## Cenários

```gherkin
Feature: Enviar Feedback ao Participante

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Conferir quem vai receber antes de enviar
    Given que sou Administrador Nacional e a etapa está encerrada com a devolutiva liberada
    When escolho a premiação e a etapa
    Then o sistema apresenta os participantes que receberão o aviso, com a situação de cada um

  Scenario: Enviar o aviso de feedback disponível
    Given que confiro a relação de participantes da etapa
    When aciono o envio
    Then o sistema enfileira um aviso para cada participante selecionado
    And registra o envio com o responsável, a data e as quantidades de selecionados, enfileirados e sem e-mail

  Scenario: Reenfileirar os avisos que falharam
    Given que alguns avisos daquele envio estão com situação de falha
    When aciono o reenfileiramento das falhas
    Then o sistema devolve à fila apenas os avisos que falharam

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Etapa com apenas um estado encerrado
    Given que a etapa tem um estado encerrado e outros ainda abertos
    When escolho essa etapa
    Then o sistema não permite o envio e informa que a etapa ainda não está encerrada

  Scenario: Etapa encerrada com a devolutiva ainda não liberada
    Given que a etapa está encerrada e a devolutiva daquela etapa ainda não foi liberada
    When escolho essa etapa
    Then o sistema não permite o envio e informa que a devolutiva ainda não foi liberada

  Scenario: Participante que já recebeu o aviso
    Given que um participante já recebeu o aviso daquela etapa
    When escolho a premiação e a etapa
    Then o sistema o apresenta fora da seleção proposta

  Scenario: Participante sem e-mail cadastrado
    Given que um participante da etapa não tem e-mail cadastrado
    When envio o aviso
    Then o sistema contabiliza aquele participante como falha de envio

  Scenario: Inscrição desclassificada não recebe o aviso
    Given que uma inscrição da etapa foi desclassificada
    When escolho a premiação e a etapa
    Then o sistema não apresenta aquele participante entre os que receberão

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Administrador Regional tenta enviar
    Given que sou Administrador Regional
    When acesso o painel de avaliações
    Then o sistema não oferece o envio do feedback
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | entrada do usuário | editável | seleção → Premiação | sim | — |
| Etapa | Etapa | entrada do usuário | editável | seleção → Etapa | sim | habilitada depois da premiação; apenas etapas inteiramente encerradas e com a devolutiva liberada têm o envio permitido |
| Participantes selecionados | Inscrição | entrada do usuário | editável | seleção múltipla → Inscrição | sim | proposta sem quem já recebeu, quem já está na fila e as inscrições desclassificadas |
| Observação | Disparo de Feedback | entrada do usuário | editável | texto | não | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Data do disparo | data e hora do envio | Ao enviar |
| Usuário responsável | administrador autenticado | Ao enviar |
| Nome do responsável | nome do administrador autenticado | Ao enviar |
| Selecionados | quantidade de participantes selecionados | Ao enviar |
| Enfileirados | quantidade de avisos colocados na fila | Ao enviar |
| Sem e-mail | quantidade de participantes sem e-mail cadastrado | Ao enviar |
| Situação do aviso | enviado, aguardando ou falha | Ao enviar e a cada tentativa de entrega |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Disparo de Feedback | grava | Guarda o registro de cada envio: recorte, responsável, data e quantidades — regra 8 |
| Auditoria de E-mail | lê e grava | Enfileira um aviso por participante, guarda a situação de cada um e é o que diz quem já recebeu — regras 6, 9 e 13 |
| Inscrição | lê | Identifica os participantes da etapa e os seus e-mails — regras 2 e 10 |
| Avaliação de Inscrição | lê | Confere a devolutiva consolidada da etapa e exclui as inscrições desclassificadas — regras 4 e 7 |
| Premiação | lê | A Etapa e a sua situação, a liberação da devolutiva e o modelo de e-mail do tipo feedback disponível — regras 3, 4 e 12 |
| Usuário | lê | Resolve o perfil que autoriza o envio e o responsável registrado — regras 1 e 8 |

---

## Comportamento de tela

### Onde fica
Tela própria de Disparo de Feedback, alcançada por uma ação no Painel de Avaliações (`/avaliacao-admin/avaliacoes`) oferecida só ao Administrador Nacional. → ver `AVL-PAI-01` (Acompanhar Painel de Avaliações), regra 15

A tela abre com a escolha da premiação e da etapa. Escolhida a etapa, apresenta a relação dos participantes que receberão o aviso, cada um com a sua situação de envio, e só então habilita o envio. Quando uma das duas condições não é atendida — etapa não inteiramente encerrada, devolutiva não liberada —, o envio fica desabilitado e a tela diz qual delas falta. Depois do envio, a mesma relação passa a mostrar a situação de cada aviso, e uma ação própria devolve à fila apenas os que falharam.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera a relação de participantes; ação de envio desabilitada com indicador enquanto enfileira |
| Erro de validação | Envio desabilitado enquanto a etapa não está inteiramente encerrada ou a devolutiva não foi liberada, com o motivo apresentado na tela |
| Erro de servidor | Exibe "Não foi possível carregar os dados." na relação e "Ocorreu um erro. Tente novamente." no envio |
| Sucesso | Exibe "Registro salvo com sucesso." e apresenta a situação de cada aviso |
| Empty state | Etapa sem participante a avisar: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O administrador confere a relação de participantes antes de enviar | cenário "Conferir quem vai receber antes de enviar" |
| SC-02 | O envio só é permitido com a etapa inteiramente encerrada e a devolutiva liberada | cenários "Etapa com apenas um estado encerrado" e "Etapa encerrada com a devolutiva ainda não liberada" |
| SC-03 | Nenhum participante recebe o aviso duas vezes pela seleção proposta | cenário "Participante que já recebeu o aviso" |
| SC-04 | Cada envio fica registrado com responsável, data e as três quantidades | cenário "Enviar o aviso de feedback disponível" |
| SC-05 | O reenfileiramento alcança apenas os avisos que falharam | cenário "Reenfileirar os avisos que falharam" |
| SC-06 | A inscrição desclassificada não recebe o aviso | cenário "Inscrição desclassificada não recebe o aviso" |

---

## Métricas de tamanho

> Contagem realizada em 2026-10-04 sobre este N3, para processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade foi entregue em 2026-10-01, na Sprint 6. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios; o Disparo de Feedback é subgrupo do ALI Auditoria de E-mails). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Envio de Feedback | SE | 4 | 12 | Alta | 7 | 2026-10-04 |
| Enviar Feedback da Etapa | EE | 5 | 10 | Alta | 6 | 2026-10-04 |
| Reenfileirar Falhas de Envio | EE | 2 | 5 | Média | 4 | 2026-10-04 |

### Memória de cálculo

**Consultar Envio de Feedback** — SE. Formas de lógica: 3 (exclui quem já recebeu, quem está na fila e as desclassificadas), 4, 7, 8, 9 (apura as condições de etapa encerrada e devolutiva liberada), 11, 12. Intenção primária: apresentar, com dado derivado.

```json
{"pe": "Consultar Envio de Feedback",
 "alr": ["Inscrição", "Avaliação de Inscrição", "Premiação", "Auditoria de E-mails"],
 "der": ["Premiação", "Etapa", "Participante", "Protocolo", "E-mail do participante", "Situação do aviso", "Etapa inteiramente encerrada", "Devolutiva liberada", "Motivo do impedimento", "Marcação de selecionado", "Mensagem", "Ação"]}
```
- **ALR (4)**: Inscrição *(os participantes da etapa e os seus e-mails)* · Avaliação de Inscrição *(a devolutiva consolidada e a desclassificação)* · Premiação *(a Etapa, a sua situação e a liberação da devolutiva)* · Auditoria de E-mails *(o que já foi enviado ou está na fila, e os disparos anteriores)*.
- **DER (12)** — entrada (2): Premiação · Etapa. Saída (8): Participante · Protocolo · E-mail do participante · Situação do aviso · Etapa inteiramente encerrada · Devolutiva liberada · Motivo do impedimento · Marcação de selecionado. Padrão (2): Mensagem · Ação.
- **Fora da contagem**: a exclusão de quem já recebeu (regra 6) é forma de lógica de processamento, não DER.

**Enviar Feedback da Etapa** — EE. Formas de lógica: 1 (condições de etapa encerrada e devolutiva liberada), 2, 3, 5, 6 (grava o Disparo de Feedback e enfileira os avisos), 8, 9 (apura selecionados, enfileirados e sem e-mail), 10. Intenção primária: manter ALI.

```json
{"pe": "Enviar Feedback da Etapa",
 "alr": ["Auditoria de E-mails", "Inscrição", "Avaliação de Inscrição", "Premiação", "Usuário"],
 "der": ["Premiação", "Etapa", "Participantes selecionados", "Data do disparo", "Responsável", "Selecionados", "Enfileirados", "Sem e-mail", "Mensagem", "Ação"]}
```
- **ALR (5)**: Auditoria de E-mails *(grava o registro do disparo e enfileira um aviso por participante — o Disparo de Feedback é subgrupo deste ALI)* · Inscrição *(os destinatários e os seus e-mails)* · Avaliação de Inscrição *(a devolutiva referida e a exclusão das desclassificadas)* · Premiação *(a Etapa e o modelo de e-mail do tipo feedback disponível, subgrupo deste ALI)* · Usuário *(o responsável gravado no disparo)*.
- **DER (10)** — entrada (3): Premiação · Etapa · Participantes selecionados. Saída (5): Data do disparo · Responsável · Selecionados · Enfileirados · Sem e-mail. Padrão (2): Mensagem · Ação.
- **Fora da contagem**: a observação do disparo é campo do registro e não condiciona o envio; o corpo do e-mail vem do modelo e não é dado informado nesta transação.

**Reenfileirar Falhas de Envio** — EE. Formas de lógica: 3 (alcança apenas as falhas), 5, 6 (devolve os avisos à fila), 8. Intenção primária: manter ALI.

```json
{"pe": "Reenfileirar Falhas de Envio",
 "alr": ["Auditoria de E-mails", "Inscrição"],
 "der": ["Disparo", "Situação do aviso", "Avisos reenfileirados", "Mensagem", "Ação"]}
```
- **ALR (2)**: Auditoria de E-mails *(lê a situação de falha e devolve o aviso à fila)* · Inscrição *(o destinatário do aviso reenfileirado)*.
- **DER (5)** — entrada (1): Disparo. Saída (2): Situação do aviso · Avisos reenfileirados. Padrão (2): Mensagem · Ação.
- **Fora da contagem**: o reenfileiramento não altera o registro do disparo — as quantidades gravadas são as do envio original.

**Total: 17 PF** (3 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (3 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature criada | N3 negocial do envio do feedback ao participante, derivado do resumo de entrega da Sprint 6 (entrega de 2026-10-01, migração **V00034**). Funcionalidade inédita: não existia antes da Sprint 6. A tela do produto se chama *Disparo de Feedback*; a feature usa o verbo canônico `enviar`, porque `envio` é nominalização bloqueada pelo `engine/FEATURE-DEFINITION.md`. Três processos elementares contados sobre este N3 — **17 PF** (SE 4×12, EE 5×10 e EE 2×5). ⚠️ Pendente de validação pela equipe de métricas |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
