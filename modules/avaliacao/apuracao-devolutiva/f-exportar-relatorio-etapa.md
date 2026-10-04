<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-09
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: [AVL-APU-08]
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

# Exportar Relatório da Etapa
> **Nível 3** - Feature Set: Apuração e Devolutiva — Major Feature Set: Avaliação - `AVL-APU-09`

## Descrição
Gera a planilha com o resultado completo de uma etapa — um resumo por estado e grupo e, para cada tipo de participante, a lista das inscrições com colocação, média, selos e as notas de cada avaliador — para uso fora do sistema.

Na tela de Fechamento de Etapa, com a premiação e uma etapa com resultado selecionadas, o administrador aciona "Relatório da etapa (XLSX)" e o navegador baixa a planilha.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`PDTIC25093-49`](../../../analise-impacto/AIM-PDTIC25093-49.md) | Criação | — planilha XLSX com aba de resumo por estado e grupo e uma aba por tipo de participante, com respostas do formulário, notas por avaliador, feedback consolidado e decisão de corte; o Administrador Regional recebe o recorte das suas UFs |
| [`PDTIC25093-64`](../../../analise-impacto/AIM-PDTIC25093-64.md) | Alteração | — colocação no ranking das etapas fechadas incluída no relatório da etapa, junto com a média final |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Fechamento de Etapa (`/avaliacao-admin/fechamento-etapa/:etapaId`), botão "Relatório da etapa (XLSX)" *(origem corrigida em 2026-10-04: a registrada antes, a Consulta de Ranking da Etapa, estava errada — o resumo de entrega da Sprint 6 situa o relatório na tela de Fechamento, e o Ranking é somente leitura, sem ações)*

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-fechamento.html`

---

</div>

## Regras de negócio

1. A planilha reproduz o resultado já apurado da etapa, sem recalcular colocação nem selos. → ver `AVL-APU-01` (Apurar Resultado da Etapa)
2. O relatório cobre todas as inscrições do resultado da etapa, agrupadas por tipo de participante.
3. O conteúdo exportado de cada inscrição é o mesmo que o administrador já acessa no sistema: identificação, respostas da inscrição e desempenho dos avaliadores.
4. Quando a premiação está configurada com avaliação às cegas, a identificação do avaliador na planilha é substituída por um apelido numerado.
5. O Administrador Regional exporta apenas as inscrições das unidades federativas às quais está vinculado.
6. A exportação não tem limite de linhas: traz o resultado inteiro do recorte.
7. A colocação de cada inscrição integra a planilha e é a mesma apresentada no ranking da etapa, sem recálculo. → ver `AVL-APU-01` (Apurar Resultado da Etapa)
8. A colocação é preenchida apenas para as inscrições de estados já fechados; no estado ainda aberto a célula fica vazia, porque a posição pode mudar até o fechamento.
9. A colocação é gravada na planilha como número, e não como texto, para que a planilha possa ser ordenada por ela.
10. A planilha reflete a desclassificação: a inscrição desclassificada aparece sem colocação. → ver `AVL-APU-13` (Desclassificar Inscrição na Etapa)

---

## Cenários

```gherkin
Feature: Exportar Relatório da Etapa

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Exportar o resultado de uma etapa encerrada
    Given que estou consultando o ranking de uma etapa apurada
    When aciono "Relatório da etapa (XLSX)"
    Then o sistema entrega uma planilha com a aba de resumo e uma aba por tipo de participante
    And cada linha traz colocação, média final, selos de classificado e premiado e as notas por avaliador

  Scenario: Exportar etapa com avaliação às cegas
    Given que a premiação está configurada com avaliação às cegas
    When exporto o relatório da etapa
    Then os avaliadores aparecem na planilha como apelidos numerados, sem os nomes reais

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Colocação em estado ainda aberto
    Given que o estado da inscrição ainda não foi fechado na etapa
    When exporto o relatório da etapa
    Then a planilha traz a inscrição com a coluna de colocação vazia

  Scenario: Inscrição desclassificada na planilha
    Given que uma inscrição foi desclassificada na etapa
    When exporto o relatório da etapa
    Then a planilha traz a inscrição sem colocação

  Scenario: Etapa sem inscrições no recorte
    Given que o recorte de unidade federativa não devolve nenhuma inscrição
    When exporto o relatório da etapa
    Then a planilha é entregue com o aviso de que não há inscrições para esta etapa

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Avaliador tenta exportar
    Given que estou autenticado como Avaliador
    When tento exportar o relatório da etapa
    Then o sistema nega a operação
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Etapa | Etapa | entrada do usuário | somente leitura | seleção → Etapa | sim | a etapa da premiação em consulta no ranking |
| Unidade federativa | Unidade Federativa | entrada do usuário | somente leitura | seleção → Unidade Federativa | não | recorte herdado da consulta; limitado às unidades do usuário quando Administrador Regional |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Resumo por estado e grupo | uma linha por estado e grupo, com participantes, classificados, premiados, data e responsável pelo fechamento — na primeira aba da planilha | Ao gerar a planilha |
| Detalhe por tipo de participante | uma aba por tipo de participante com inscrições no resultado; cada campo do formulário daquele tipo vira uma coluna, e cada avaliador ocupa um bloco de quatro colunas | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório da etapa | Ao entregar a planilha |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Apuração por Etapa | lê | Fornece a colocação, a média final, a decisão de corte, o feedback consolidado e a desclassificação de cada inscrição (regras 1, 7 e 10) |
| Avaliação de Inscrição | lê | Fornece os avaliadores de cada inscrição, que ocupam um bloco de colunas cada (campo automático *Detalhe por tipo de participante*) |
| Nota de Avaliação | lê | Fornece as notas de que sai a nota por avaliador (regra 3) |
| Inscrição | lê | Fornece a identificação de cada inscrição do resultado (regras 2 e 3) |
| Resposta de Formulário | lê | Fornece as respostas da inscrição exportadas na aba do tipo de participante (regra 3) |
| Campo do Formulário | lê | Cada campo do formulário do tipo de participante vira uma coluna (campo automático *Detalhe por tipo de participante*) |
| Fechamento de Etapa por UF | lê | Data e responsável pelo fechamento no resumo; a colocação só é preenchida em estado fechado (regra 8) |
| Premiação | lê | A configuração de avaliação às cegas troca a identificação do avaliador por apelido (regra 4) |
| Categoria | lê | Compõe o grupo do resumo |
| Modalidade | lê | Compõe o grupo do resumo |
| Tipo de Participante | lê | Compõe o grupo e separa as abas de detalhe (regra 2) |
| Usuário | lê | Identifica os avaliadores e recorta as UFs do Administrador Regional (regra 5) |

---

## Comportamento de tela

### Onde fica
Botão "Relatório da etapa (XLSX)" no topo do Fechamento de Etapa (`/avaliacao-admin/fechamento-etapa/:etapaId`), habilitado depois que uma premiação e uma etapa com resultado estão selecionadas. A planilha é baixada pelo navegador.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão desabilitado com indicador enquanto a planilha é gerada |
| Erro de validação | Botão permanece desabilitado enquanto não houver etapa selecionada |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | O download da planilha começa |
| Empty state | Sem inscrições no recorte, a planilha vem com o aviso de ausência de resultado |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A planilha reproduz o mesmo resultado apresentado na consulta de ranking | cenário "Exportar o resultado de uma etapa encerrada" |
| SC-02 | A avaliação às cegas é preservada na planilha | cenário "Exportar etapa com avaliação às cegas" |
| SC-03 | A colocação só é preenchida para inscrições de estados fechados, e sai como número ordenável | cenário "Colocação em estado ainda aberto" e regras 8 e 9 |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Exportar Relatório da Etapa | principal | SE | 7 | 19 | Alta | 7 | 2026-10-02 |

### Memória de cálculo

**Exportar Relatório da Etapa** — SE · ALR 7 · DER 19 · Alta · 7 PF

```json
{"pe": "Exportar Relatório da Etapa",
 "alr": ["Avaliação de Inscrição", "Inscrição", "Premiação", "Categoria", "Modalidade", "Tipo de Participante", "Usuário"],
 "der": ["Etapa", "Unidade federativa", "Estado", "Grupo", "Participantes", "Classificados", "Premiados", "Tipo de participante", "Identificação da inscrição", "Respostas da inscrição", "Colocação", "Média final", "Nota por avaliador", "Avaliador ou apelido", "Feedback consolidado", "Decisão de corte", "Nome do arquivo", "Mensagem", "Ação"]}
```

Por que cada ALR:
1. `Avaliação de Inscrição` — apuração, notas por avaliador e feedback consolidado
2. `Inscrição` — identificação e respostas
3. `Premiação` — a etapa e a configuração de avaliação às cegas
4. `Categoria` — as respostas do formulário e do questionário
5. `Modalidade` — as respostas do formulário e do questionário
6. `Tipo de Participante` — as respostas do formulário e do questionário
7. `Usuário` — os avaliadores e o recorte por UF do Administrador Regional (regra 5)

Classificação SE. Formas de lógica: 3 (apelido numerado no lugar do avaliador, na avaliação às cegas), 4, 7, 8, 9 (o resumo por estado e grupo conta participantes, classificados e premiados), 11, 12. Intenção primária: apresentar, com dado derivado.

Dos 19 DER, 2 são de entrada (Etapa e Unidade federativa), 5 de saída do resumo (Estado, Grupo, Participantes, Classificados e Premiados), 9 de saída do detalhe (de Tipo de participante a Decisão de corte) e 3 padrão (Nome do arquivo, Mensagem e Ação). Nas abas por tipo de participante a **Colocação** precede a **Média final**.

Fora da contagem: a ausência de limite de linhas (regra 6) é característica do processamento, não DER.

**Total: 7 PF** (1 processo elementar). A inclusão da colocação e da média final em 2026-10-02 levou o DER de 17 a 19, dentro da mesma faixa de 6 a 19 — a complexidade segue Alta e o PF não se move. A conciliação de 2026-10-04 com o resumo de entrega da Sprint 6 confirmou os dois DER e não acrescentou nenhum: a célula vazia no estado aberto e o valor gravado como número são características do mesmo dado.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa do que a feature realiza de cada ticket na `## Origem`, coluna Entidade e as sete colunas do padrão em `## Campos` (a seleção sai do Preenchimento e vai para o Tipo), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com a anotação sobre a ordem das colunas levada da lista para a prosa. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | Análise de impacto SP06 (docqui) | Origem corrigida · feature alterada | **Correção** da origem e **inclusão** das regras da colocação. *Antes* a `## Superfície` dizia que o relatório é acionado na Consulta de Ranking da Etapa, e nenhuma regra falava de colocação — ela aparecia só na descrição e num cenário. *Agora* a origem é a tela de **Fechamento de Etapa**, confirmada pelo resumo de entrega da Sprint 6 (o Ranking é somente leitura, sem ações), e três regras novas fixam o comportamento da coluna: vem do ranking sem recálculo (RN7), fica vazia em estado aberto (RN8), sai como número ordenável (RN9). A RN10 registra que a planilha reflete a desclassificação. +4 regras, +2 cenários, +1 critério. Sem Δ PF |
| 2026-10-02 | Análise de impacto `PDTIC25093-64` (docqui) | Memória de cálculo corrigida | **Inclusão** da colocação no ranking e da média final na enumeração de DER, que é o que o card pede. *Antes* a descrição e o cenário do caminho feliz já diziam que cada linha da planilha traz colocação e média, mas a memória de cálculo não as enumerava — DER 17. *Agora* DER 19, na mesma faixa de 6 a 19: complexidade Alta e **7 PF** inalterados. Registrado em `## Superfície` o ⚠️ de que o card localiza o relatório na tela de fechamento, e não na de ranking |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exportação do relatório da etapa em planilha multi-abas) — capacidade implementada e até então não especificada |

---

*Feature Set: Apuração e Devolutiva · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
