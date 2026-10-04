<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-PAI-01
feature_set: AVL-PAI
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: []
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

# Acompanhar Painel de Avaliações
> **Nível 3** - Feature Set: Painel Administrativo de Avaliações — Major Feature Set: Avaliação - `AVL-PAI-01`

## Descrição
Permite ao administrador acompanhar as avaliações em andamento da premiação, organizadas por inscrição e etapa e recortáveis por estado, com indicadores agregados, busca e o andamento da consolidação de cada estado, para saber o que já pode ser consolidado e quais estados ainda faltam.

No menu Premiação › Avaliações, o administrador recorta a lista por filtros como premiação, etapa e estado, ou busca pelo protocolo, e acompanha a árvore de inscrições, etapas e avaliadores com os indicadores no topo; cada linha leva ao detalhe da avaliação.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-027_Painel_Administrativo_Avaliacoes`](../../../hus/HU-027_Painel_Administrativo_Avaliacoes.docx) | Criação | — funcionalidade "Acompanhar Avaliações em Andamento" da HU, que não numera critérios: a árvore por inscrição × etapa com os indicadores agregados, os filtros por premiação, etapa e status de consolidação e a busca livre |
| [`PDTIC25093-65`](../../../analise-impacto/AIM-PDTIC25093-65.md) | Alteração | — item 3 do card: a seleção de etapa restrita às etapas regionais para o Administrador Regional e o andamento da consolidação por estado só nas etapas regionais |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/avaliacoes` (Lista de Avaliações)

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/painel-administrativo/flow.html`

---

</div>

## Regras de negócio

1. O acompanhamento organiza as avaliações por inscrição e, dentro de cada inscrição, por etapa, com os avaliadores alocados sob cada etapa.
2. O status de consolidação de cada etapa assume um entre quatro valores: Aguardando avaliadores, Pronta para consolidação, Consolidada e Sem avaliadores.
3. Uma etapa fica pronta para consolidação somente quando todos os avaliadores alocados para a inscrição naquela etapa concluíram a avaliação.
4. A visibilidade de cada avaliação segue a capability configurada na etapa: cada administrador acompanha apenas as inscrições das etapas autorizadas ao seu acesso. ⚠️ *(capability por etapa definida em Etapas e Configuração da Avaliação — a confirmar o modelo de escopo)*
5. A confidencialidade configurada na premiação não se aplica ao administrador, que enxerga a identificação do participante e todos os dados da avaliação.
6. Cada inscrição acompanhada pertence ao estado (UF) do seu participante; as inscrições sem estado definido compõem o escopo Nacional. ⚠️ *(agrupamento "Nacional" adotado do fechamento por UF — a confirmar para o acompanhamento das avaliações)*
7. O Administrador Regional acompanha apenas as inscrições dos estados aos quais está vinculado; o Administrador Nacional acompanha as inscrições de todos os estados da premiação.
8. O andamento da consolidação é apurado por estado dentro de cada etapa: o estado está concluído quando todas as suas inscrições naquela etapa têm feedback consolidado, e pendente enquanto restar ao menos uma inscrição sem consolidação.
9. O andamento da consolidação por estado abrange somente os estados dentro do escopo de acompanhamento do usuário.
10. A seleção de etapa oferece ao Administrador Regional apenas as etapas de **natureza regional**; a etapa nacional não lhe é oferecida nem acompanhada. → ver `AVL-APU-08` (Consultar Ranking da Etapa), regra 4
11. O andamento da consolidação por estado (regra 8) é apresentado apenas nas etapas de **natureza regional**: na etapa nacional, cuja disputa não se organiza por estado, o acompanhamento não o traz.
12. A seleção de etapa só é oferecida depois que uma premiação está escolhida, e identifica cada etapa pela ordem, pelo nome e pela situação — Aberta ou Fechada.
13. A etapa selecionada recorta tanto a relação de avaliações quanto os indicadores agregados do topo.
14. Trocar ou limpar a premiação limpa a etapa selecionada.
15. O acesso ao disparo do feedback da etapa é oferecido neste acompanhamento, e apenas ao Administrador Nacional. → ver `AVL-APU-14` (Enviar Feedback ao Participante)

---

## Cenários

```gherkin
Feature: Acompanhar Painel de Avaliações

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Acompanhar as avaliações da premiação
    Given que existem avaliações em andamento na premiação
    When acesso a lista de avaliações
    Then o sistema apresenta as inscrições com sua premiação, categoria, modalidade, a relação de avaliações finalizadas sobre alocadas e o status de consolidação de cada etapa

  Scenario: Consultar os indicadores agregados
    Given que acompanho as avaliações da premiação
    When observo os indicadores no topo
    Then o sistema apresenta os totais de avaliadores alocados, avaliações em andamento, avaliações concluídas, prontas para consolidação, consolidadas e sem avaliadores

  Scenario: Consultar o andamento da consolidação por estado
    Given que a premiação tem inscrições de participantes de vários estados
    When observo o andamento da consolidação por estado
    Then o sistema apresenta cada estado com a quantidade de inscrições consolidadas sobre o total da etapa e a indicação de concluído ou pendente

  Scenario: Estado com a consolidação concluída
    Given que todas as inscrições do estado de Goiás na etapa têm feedback consolidado
    When observo o andamento da consolidação por estado
    Then o sistema apresenta Goiás como concluído

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Filtrar o acompanhamento por etapa
    Given que a premiação tem uma etapa regional e uma etapa nacional
    When seleciono a etapa regional
    Then o sistema apresenta apenas as avaliações daquela etapa
    And recalcula os indicadores agregados para aquela etapa

  Scenario: Trocar a premiação limpa a etapa
    Given que selecionei uma premiação e uma etapa
    When troco a premiação
    Then o sistema limpa a etapa selecionada

  Scenario: Etapa nacional sem consolidação por estado
    Given que selecionei uma etapa de natureza nacional
    When acompanho as avaliações daquela etapa
    Then o sistema não apresenta o andamento da consolidação por estado

  Scenario: Filtrar por status de consolidação
    Given que existem etapas em diferentes status de consolidação
    When seleciono o status "Pronta para consolidação"
    Then o sistema apresenta apenas as etapas prontas para consolidação

  Scenario: Filtrar as avaliações por estado
    Given que existem inscrições de participantes de vários estados
    When seleciono o estado "Minas Gerais"
    Then o sistema apresenta apenas as inscrições de participantes de Minas Gerais

  Scenario: Selecionar o escopo Nacional
    Given que existem inscrições sem estado definido
    When seleciono "Nacional" na seleção de estado
    Then o sistema apresenta apenas as inscrições sem estado definido

  Scenario: Buscar por protocolo
    Given que existe a inscrição de protocolo "2026-IEL-00123"
    When informo "2026-IEL-00123" na busca
    Then o sistema apresenta a inscrição correspondente

  Scenario: Busca sem resultados
    Given que nenhuma inscrição corresponde ao termo buscado
    When realizo a busca
    Then o sistema exibe "Nenhum resultado para a busca."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Administrador Regional só alcança etapas regionais
    Given que sou Administrador Regional
    When abro a seleção de etapa
    Then o sistema oferece apenas as etapas de natureza regional

  Scenario: Administrador Regional restrito aos seus estados
    Given que sou Administrador Regional vinculado apenas a Minas Gerais e ao Espírito Santo
    When acesso a lista de avaliações
    Then o sistema apresenta apenas as inscrições de Minas Gerais e do Espírito Santo e oferece somente esses estados na seleção de estado e no andamento da consolidação

  Scenario: Usuário sem permissão de acompanhamento
    Given que meu perfil não tem permissão para acompanhar avaliações
    When tento acessar a lista de avaliações
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | entrada do usuário | editável | seleção → Premiação | não | filtra as avaliações da premiação escolhida |
| Etapa | Etapa | entrada do usuário | editável | seleção → Etapa | não | habilitada depois da premiação; cada opção traz ordem, nome e situação (Aberta ou Fechada); o Administrador Regional recebe apenas as etapas de natureza regional |
| Estado (UF) | Unidade Federativa | entrada do usuário | editável | seleção múltipla → Unidade Federativa (inclui Nacional para as inscrições sem estado) | não | limitada aos estados do escopo do usuário |
| Status de consolidação | dado de código | entrada do usuário | editável | seleção múltipla (Aguardando avaliadores, Pronta para consolidação, Consolidada, Sem avaliadores) | não | seleção múltipla |
| Busca | Inscrição | entrada do usuário | editável | texto | não | correspondência por protocolo, identificador da inscrição ou nome do participante |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Inscrição (Identificador · Protocolo) | Inscrição | padrão ↑ |
| Premiação | Premiação | — |
| Categoria | Inscrição | — |
| Modalidade | Inscrição | — |
| Estado (UF) | Inscrição | ordenável |
| Avaliações (finalizadas / alocadas) | derivado (contagem) | — |
| Status de consolidação | Apuração por Etapa | ordenável |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Avaliação de Inscrição | lê | Os avaliadores alocados sob cada etapa e a relação de avaliações finalizadas sobre alocadas, que decide se a etapa está pronta para consolidação (regras 1 e 3) |
| Alocação de Avaliadores | lê | O indicador de avaliadores alocados no topo (ALR do baseline) |
| Apuração por Etapa | lê | O feedback consolidado de cada inscrição na etapa, que dá o status de consolidação e o andamento por estado (regras 2 e 8) |
| Categoria | lê | A coluna *Categoria* da inscrição (ALR do baseline) |
| Modalidade | lê | A coluna *Modalidade* da inscrição (ALR do baseline) |
| Usuário | lê | Os estados aos quais o Administrador Regional está vinculado recortam a lista, a seleção de estado e o andamento da consolidação (regras 7 e 9) |
| Perfil de Acesso à Etapa | lê | Os perfis autorizados em cada etapa e a natureza regional ou nacional da etapa definem o que cada administrador acompanha (regras 4, 10 e 11) |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao-admin/avaliacoes`: uma árvore com a inscrição como nó pai, suas etapas como filhos e os avaliadores alocados como netos, precedida dos indicadores agregados, do campo de busca e dos seletores de premiação, etapa, estado (UF) e status de consolidação. Acima da árvore, um resumo de consolidação por estado lista cada estado com a relação de inscrições consolidadas sobre o total da etapa e o selo de concluído ou pendente; para o Administrador Regional, tanto a seleção de estado quanto esse resumo trazem apenas os estados aos quais ele está vinculado, e a seleção de etapa oferece apenas as etapas de natureza regional. Na etapa de natureza nacional o resumo de consolidação por estado não é apresentado, porque a disputa ali não se organiza por estado. O Administrador Nacional encontra aqui também o acesso ao disparo do feedback da etapa, que não é oferecido aos demais perfis.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a árvore e os indicadores são recuperados |
| Erro de validação | Não se aplica (os filtros são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a árvore de avaliações e os indicadores agregados |
| Empty state | Sem avaliações na premiação: "Nenhum registro encontrado."; busca ou estado selecionado sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A lista apresenta as avaliações por inscrição × etapa com a relação finalizadas/alocadas e o status de consolidação | cenário "Acompanhar as avaliações da premiação" |
| SC-02 | Os indicadores agregados somam avaliadores alocados, em andamento, concluídas, prontas, consolidadas e sem avaliadores | cenário "Consultar os indicadores agregados" |
| SC-03 | A busca por protocolo e o filtro por status de consolidação restringem o resultado apresentado | cenários "Buscar por protocolo" e "Filtrar por status de consolidação" |
| SC-04 | A seleção de um estado restringe o resultado às inscrições daquele estado, e "Nacional" às inscrições sem estado definido | cenários "Filtrar as avaliações por estado" e "Selecionar o escopo Nacional" |
| SC-05 | O andamento da consolidação por estado distingue os estados concluídos dos pendentes, com a relação de inscrições consolidadas sobre o total | cenários "Consultar o andamento da consolidação por estado" e "Estado com a consolidação concluída" |
| SC-06 | O Administrador Regional alcança apenas as inscrições e os estados aos quais está vinculado | cenário "Administrador Regional restrito aos seus estados" |
| SC-07 | A seleção de etapa restringe o acompanhamento e os indicadores àquela etapa, oferece ao Administrador Regional somente as regionais e suprime a consolidação por estado quando a etapa é nacional | cenários "Filtrar o acompanhamento por etapa", "Administrador Regional só alcança etapas regionais" e "Etapa nacional sem consolidação por estado" |
| SC-08 | Trocar ou limpar a premiação limpa a etapa selecionada | cenário "Trocar a premiação limpa a etapa" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Acompanhar Painel de Avaliações | principal | SE | 5 | 20 | Complexo | 7 | 2026-02-28 |

> No baseline, o processo elementar se chama *Consultar Painel de Avaliações*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Acompanhar Painel de Avaliações** — SE · ALR 5 · DER 20 · Complexo · 7 PF

```json
{"pe": "Acompanhar Painel de Avaliações",
 "alr": ["Premiação", "Categoria", "Modalidade", "Alocação Avaliadores", "Avaliação de Inscrição"],
 "der": ["Qtd Avaliadores Alocados", "Percentual Avaliadores Alocados", "Qtd avaliações em andamento", "Percentual avaliações em andamento", "Qtd avaliações concluidas", "Percentual avaliações concluidas", "Qtd avaliações consolidadas", "Percentual avaliações consolidadas", "Qtd avaliação sem avaliadores", "Percentual avaliação sem avaliadores", "Número protocolo", "Status (filtro)", "Inscrição / Etapa / Avaliador", "Premiação", "Categoria", "Modalidade", "Avaliações", "Status (coluna)", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a premiação e a etapa selecionadas, e a coluna *Premiação* (a etapa é subgrupo da Premiação)
2. `Categoria` — a coluna *Categoria* de cada inscrição
3. `Modalidade` — a coluna *Modalidade* de cada inscrição
4. `Alocação Avaliadores` — o indicador de avaliadores alocados
5. `Avaliação de Inscrição` — os avaliadores sob cada etapa, a relação de avaliações finalizadas sobre alocadas e o status de consolidação

⚠️ A planilha conta *Status* duas vezes — no filtro de status de consolidação e na coluna da árvore. Pelo CPM o mesmo DER conta uma vez; mantido como o baseline contou, com o lugar de cada um entre parênteses, a confirmar com a equipe de métricas. Com ALR 5, um DER a menos (19) não muda a complexidade da SE.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza da HU, que não numera critérios, e do ticket; coluna Entidade em `## Campos`, normalizada para as sete colunas do template com a coluna Edição; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e o DER *Status*, contado duas vezes no baseline, desambiguado entre filtro e coluna. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Feature alterada | **Inclusão** do detalhe da seleção de etapa e do acesso ao disparo de feedback, conciliados com o resumo de entrega da Sprint 6. *Antes* o delta de 2026-10-02 registrou que a etapa restringe o acompanhamento, sem dizer que a seleção depende da premiação, que cada opção identifica a etapa por ordem, nome e situação, nem que o recorte alcança **também os indicadores** do topo. *Agora* as RN12 a RN14 fixam isso, e a RN15 registra que o acesso ao disparo do feedback vive nesta tela, só para o Administrador Nacional. +4 regras, +1 cenário, +1 critério. DER 20 já estava no topo da faixa — sem Δ PF |
| 2026-10-02 | Análise de impacto `PDTIC25093-65` (docqui) | Feature alterada | **Restrição** do acompanhamento pela natureza da etapa, item 3 do card. *Antes* a seleção de etapa não distinguia perfil — o Administrador Regional recebia também as etapas nacionais — e o andamento da consolidação por estado era apurado em toda etapa, inclusive na nacional, em que a disputa não é por estado. *Agora* a seleção oferece ao Regional apenas as etapas regionais (RN10) e a consolidação por estado só aparece nas etapas regionais (RN11). +2 regras, +3 cenários, +1 critério de sucesso. A contagem não se move: DER já estava em 20, no topo da faixa |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/painel-administrativo/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Seleção por estado (UF) com escopo do Administrador Regional e andamento da consolidação por estado |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-027 |

---

*Feature Set: Painel Administrativo de Avaliações · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
