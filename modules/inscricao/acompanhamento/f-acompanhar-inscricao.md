<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-ACO-01
feature_set: INS-ACO
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
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

# Acompanhar Inscrição
> **Nível 3** - Feature Set: Acompanhamento — Major Feature Set: Inscrição - `INS-ACO-01`

## Descrição
Permite ao participante acompanhar as próprias inscrições em um painel com indicadores e a situação atual de cada uma, com acesso à ação correspondente ao andamento.

Ao entrar na área do participante, ele vê no painel os indicadores de total, finalizadas e pendentes e a lista das próprias inscrições com a situação de cada uma, e aciona em cada inscrição a ação que o andamento permite, como continuar o preenchimento, ver o resumo ou ver os feedbacks.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-016_Dashboard_Participante`](../../../hus/HU-016_Dashboard_Participante.docx) | Criação | — a HU não numera critérios; realiza "Visualizar Dashboard do Participante" (saudação, indicadores de total, finalizadas e pendentes, lista das inscrições com a situação) e a oferta de continuar ou de ver o resumo conforme a situação, com o texto do último ajuste na inscrição aguardando ajuste |
| [`PDTIC25093-69`](../../../analise-impacto/AIM-PDTIC25093-69.md) | Alteração | — acesso aos feedbacks oferecido no painel só quando há devolutiva liberada para a inscrição (item 3 do card) |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/participante/dashboard` (Dashboard do Participante).

**Fidelidade ao protótipo**: referência — `prototypes/inscricao/acompanhamento/flow.html` *(aparece como contexto do fluxo, não como assunto dele)*

---

</div>

## Regras de negócio

1. O participante acompanha apenas as próprias inscrições.
2. Uma inscrição em estado editável — rascunho, em andamento ou aguardando ajuste — pode ter o preenchimento retomado pelo participante; nos demais estados, é consultada sem edição.
3. Para uma inscrição aguardando ajuste, o texto do último ajuste solicitado fica disponível ao participante.
4. Os indicadores consolidam a quantidade total de inscrições do participante, quantas estão finalizadas e quantas seguem pendentes.
5. O acesso à devolutiva de uma inscrição é oferecido apenas quando existe devolutiva já liberada para ela. → ver `INS-ACO-02` (Visualizar Devolutiva)

---

## Cenários

```gherkin
Feature: Acompanhar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Acompanhar as próprias inscrições
    Given que sou um participante com inscrições cadastradas
    When acesso o painel do participante
    Then o sistema apresenta os indicadores e a lista das minhas inscrições com categoria, modalidade, tipo de participante e situação

  Scenario: Inscrição editável oferece continuidade
    Given que tenho uma inscrição em rascunho
    When acompanho a inscrição no painel
    Then o sistema disponibiliza a continuidade do preenchimento

  Scenario: Inscrição aguardando ajuste mostra o ajuste solicitado
    Given que tenho uma inscrição aguardando ajuste
    When acompanho a inscrição no painel
    Then o sistema apresenta o texto do último ajuste solicitado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Participante sem inscrições
    Given que ainda não tenho nenhuma inscrição
    When acesso o painel do participante
    Then o sistema exibe "Nenhum registro encontrado."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Participante | externo: Portal corporativo (SSO) | externo: Portal corporativo (SSO) | somente leitura | texto | — | nome do participante autenticado (saudação) |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Categoria | Inscrição | — |
| Modalidade | Inscrição | — |
| Tipo de participante | Inscrição | — |
| Situação | Inscrição | ordenável |
| Número de protocolo | Inscrição | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Total de inscrições | Quantidade de inscrições do participante | Ao abrir o painel |
| Inscrições finalizadas | Quantidade de inscrições finalizadas do participante | Ao abrir o painel |
| Inscrições pendentes | Quantidade de inscrições ainda não finalizadas | Ao abrir o painel |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Inscrição | lê | Lista das inscrições do próprio participante, com situação e protocolo, e base dos indicadores de total, finalizadas e pendentes (regras 1 e 4) |
| Premiação | lê | Nome do prêmio de cada inscrição da lista (ALR do baseline) |
| Categoria | lê | Categoria de cada inscrição da lista |
| Modalidade | lê | Modalidade de cada inscrição da lista |
| Tipo de Participante | lê | Tipo de participante de cada inscrição da lista |
| Item de Ajuste | lê | Texto do último ajuste solicitado, apresentado na inscrição aguardando ajuste (regra 3) |
| Apuração por Etapa | lê | Existência de devolutiva consolidada para a inscrição, condição para oferecer o acesso aos feedbacks (regra 5) |
| Etapa | lê | Data de liberação do feedback da etapa, que decide se a devolutiva já está liberada (regra 5) |

---

## Comportamento de tela

### Onde fica
Dashboard do participante em `/participante/dashboard`, com saudação personalizada, cards de indicadores (total, finalizadas e pendentes) e a lista de inscrições, cada uma com a situação atual e a ação de continuar ou de ver o resumo.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto recupera as inscrições do participante |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Apresenta os indicadores e a lista de inscrições |
| Empty state | Participante sem inscrições: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O painel lista as inscrições do participante com categoria, modalidade, tipo e situação | cenário "Acompanhar as próprias inscrições" |
| SC-02 | Inscrições editáveis oferecem a continuidade; as demais, apenas consulta | cenário "Inscrição editável oferece continuidade" |
| SC-03 | Inscrições aguardando ajuste apresentam o texto do último ajuste solicitado | cenário "Inscrição aguardando ajuste mostra o ajuste solicitado" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Acompanhar Inscrição | principal | SE | 5 | 18 | Complexo | 7 | 2026-02-28 |

> No baseline, o processo elementar se chama *Consultar Dashboard do Participante*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Acompanhar Inscrição** — SE · ALR 5 · DER 18 · Complexo · 7 PF

```json
{"pe": "Acompanhar Inscrição",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo de Participante", "Inscrição"],
 "der": ["Nome Usuário", "Foto", "Total de Inscrições", "Status Inscrições", "Total Inscrições por Status", "Nome Premio", "Status Inscrição", "Categoria", "Modalidade", "Tipo Participante", "Percentual Inscrição", "Número Inscrição", "Total Notificações", "Titulo Notificação", "Descrição Notificação", "Qtd Notificações não lidas", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — o nome do prêmio de cada inscrição da lista
2. `Categoria` — a categoria de cada inscrição
3. `Modalidade` — a modalidade de cada inscrição
4. `Tipo de Participante` — o tipo de participante de cada inscrição
5. `Inscrição` — as inscrições do participante, com situação, protocolo e percentual, e os totais por situação dos indicadores

⚠️ A planilha enumera quatro DER do sino de notificações (*Total Notificações*, *Titulo Notificação*, *Descrição Notificação*, *Qtd Notificações não lidas*) sem contar *Notificação Participante* entre os ALR. Ficou o número da planilha; a divergência vai à equipe de métricas junto com o questionamento do baseline.

⚠️ Desde a Sprint 6 (regra 5), a transação também lê *Apuração por Etapa* — do ALI *Avaliação de Inscrição* — para decidir se oferece o acesso aos feedbacks, o que o baseline, anterior, não enumera. Com ALR 6 a SE seguiria Complexo e o PF não muda; registrado para a equipe de métricas confirmar.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios cobertos da HU (sem numeração na fonte) e do ticket na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do acesso condicionado à devolutiva. *Antes* o painel não dizia como o participante chega à devolutiva, e o caminho era entrar na inscrição e procurar a aba. *Agora* a RN5 fixa que o acesso é oferecido no painel **apenas** quando existe devolutiva liberada para aquela inscrição. +1 regra. Sem Δ DER — é condição de apresentação de uma ação já existente |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/inscricao/acompanhamento/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-016 |

---

*Feature Set: Acompanhamento · Major Feature Set: Inscrição · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
