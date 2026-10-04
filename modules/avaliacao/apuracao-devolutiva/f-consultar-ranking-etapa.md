<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-08
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
prioridade: P2
mvp: false
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
---

# Consultar Ranking da Etapa
> **Nível 3** - Feature Set: Apuração e Devolutiva — Domínio: Avaliação - `AVL-APU-08`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Apresenta em tela própria, somente para leitura, o resultado já apurado de uma etapa — a colocação de cada inscrição dentro do seu bloco de disputa, a média e os selos de classificado e de premiado — para consulta depois do fechamento.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/ranking-etapa` (e `/avaliacao-admin/ranking-etapa/:etapaId` quando a etapa vem preselecionada)

**Fidelidade ao protótipo**: referência · `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`

A desclassificação e a sua reversão não são acionáveis aqui — a consulta é somente leitura e as duas ações vivem na tela de Fechamento de Etapa. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa) e `AVL-APU-13` (Desclassificar Inscrição na Etapa)

---

</div>

## Regras de negócio

1. Só entram na consulta as etapas que já têm resultado apurado.
2. A consulta é somente leitura: não altera colocação, classificação nem premiação. → ver `AVL-APU-01` (Apurar Resultado da Etapa)
3. A composição dos blocos de disputa e a ordem dentro de cada bloco são as mesmas da apuração da etapa.
4. O que cada perfil enxerga de uma etapa deriva da **natureza da etapa**: em etapa **regional**, o Administrador Nacional consulta os blocos de todos os estados e o Administrador Regional apenas os das unidades federativas às quais está vinculado; a etapa **nacional** não é apresentada ao Administrador Regional. → ver o N2 do Feature Set, *Visibilidade da etapa por perfil*.
5. A etapa cujo recorte de unidade federativa não devolve nenhum bloco é apresentada como sem resultado para aquele usuário.
6. A inscrição desclassificada integra o resultado com a marca de desclassificada e a justificativa registrada na desclassificação. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Consultar o resultado de uma etapa encerrada
  Given que a etapa Regional está encerrada e apurada
  When escolho a premiação e a etapa na consulta de ranking
  Then vejo os blocos de disputa com a colocação, o protocolo, o participante, a média e os selos de classificado e premiado de cada inscrição

Scenario: Abrir o ranking já com a etapa escolhida
  Given que vim de outra tela indicando a etapa
  When a consulta de ranking abre
  Then a etapa já vem selecionada e o resultado é apresentado

# ── Estados especiais ──────────────────────────────────────────

Scenario: Etapa sem resultado apurado
  Given que a etapa ainda não foi apurada
  When abro a lista de etapas da consulta
  Then essa etapa não é oferecida para seleção

Scenario: Recorte de unidade federativa sem resultado
  Given que estou autenticado como Administrador Regional vinculado a uma unidade federativa sem inscrições apuradas na etapa
  When seleciono a etapa
  Then o sistema informa que não há resultado para o meu recorte

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Avaliador tenta consultar o ranking
  Given que estou autenticado como Avaliador
  When tento abrir a consulta de ranking
  Then o sistema nega o acesso
```

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Colocação | derivado (posição no bloco de disputa) | padrão ↑ |
| Protocolo | Inscrição | — |
| Participante / Projeto | Inscrição | — |
| Média | Apuração por Etapa | — |
| Coleta | derivado (avaliadores finalizados sobre alocados) | — |
| Classificação | derivado (selos de classificado e de premiado) | — |

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Premiação | seleção → Premiação | editável | lista de opções | sim | apenas premiações ativas |
| Etapa | seleção → Etapa da premiação | editável | lista de opções | sim | apenas etapas com resultado apurado |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação da etapa | Aberta ou Fechada, exibida junto da seleção | Ao selecionar a etapa |
| Linha de corte de classificação | posição correspondente à quantidade de classificados da etapa | Ao apresentar cada bloco |
| Linha de corte de premiação | posição correspondente à quantidade de premiados da etapa, quando a etapa premia | Ao apresentar cada bloco |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao-admin/ranking-etapa`, com os seletores de premiação e de etapa no topo, o botão de exportação do relatório da etapa e, abaixo, os blocos de disputa com a lista ordenada. As linhas que marcam os cortes de classificação e de premiação ficam destacadas dentro de cada bloco.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe indicador no lugar dos blocos enquanto o resultado é recuperado |
| Erro de validação | Não se aplica (só há seleção em lista) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta os blocos com a colocação, a média e os selos |
| Empty state | Sem etapa selecionada, orienta a escolher premiação e etapa; sem resultado no recorte, informa que não há resultado |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O resultado apurado de uma etapa encerrada pode ser consultado sem passar pela tela de fechamento | cenário "Consultar o resultado de uma etapa encerrada" |
| SC-02 | Etapa sem apuração não é oferecida na consulta | cenário "Etapa sem resultado apurado" |
| SC-03 | O Administrador Regional vê apenas os blocos das suas unidades federativas | cenário "Recorte de unidade federativa sem resultado" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Ranking da Etapa | SE | 7 | 18 | Alta | 7 | 2026-10-04 |

### Memória de cálculo

**Consultar Ranking da Etapa** — SE. Formas de lógica: 4 (recorte por UF conforme o perfil), 7, 8, 9 (a Coleta é contagem derivada, e as duas linhas de corte são posições derivadas das quantidades da etapa), 11, 13. A consulta não recalcula a apuração (regra 2), mas **cria dados derivados** para apresentar — o que exclui CE.
- **ALR (7)**: Avaliação de Inscrição *(a apuração gravada: média, colocação, selos)* · Inscrição *(protocolo, participante/projeto)* · Premiação *(a Etapa, a sua situação e as quantidades de classificados e premiados)* · Categoria · Modalidade · Tipo de Participante *(o grupo de disputa)* · Usuário *(o vínculo por UF que recorta o que o Regional enxerga, regra 4)*.
- **DER (18)** — entrada (3): Premiação · Etapa · Bloco endereçado. Saída (13): Situação da etapa · Estado · Grupo de disputa · Colocação · Protocolo · Participante/Projeto · Média · Coleta · Classificação · **Selo de desclassificada** · **Justificativa da desclassificação** · Linha de corte de classificação · Linha de corte de premiação · Mensagem · Ação. Os dois entraram em 2026-10-04, na mesma faixa de 6 a 19 DET — complexidade Alta e **7 PF** inalterados.
- **Fora da contagem**: a etapa sem bloco no recorte do usuário (regra 5) é estado de tela, não DER próprio.
- ⚠️ **Classificação a confirmar**: se a equipe de métricas entender que as linhas de corte e a Coleta são recuperação e não derivação, o PE cai para **CE** e vale 6 PF em vez de 7.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do selo de desclassificada e da sua justificativa na consulta. *Antes* o ranking apresentava colocação, média, Coleta e os selos de classificado e premiado — a desclassificação não existia. *Agora* a inscrição desclassificada aparece com o selo e a justificativa (RN6), e a RN7 registra que a consulta **não** oferece as ações de desclassificar e reverter, que são da tela de fechamento. DER 16 → 18, sem mover o PF |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Decisões de produto (docqui) | Regra ampliada | A visibilidade passa a derivar da natureza da etapa: confirmado o recorte por UF do Administrador Regional na etapa regional, e acrescentado que a **etapa nacional não é apresentada** a ele. A matriz completa está no N2 |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (tela dedicada de consulta ao ranking apurado) — o ranking era descrito apenas dentro de AVL-APU-01, sem a tela própria |

---

*Feature Set: Apuração e Devolutiva · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
