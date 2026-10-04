<!-- docqui: 2.23.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-APU-09
feature_set: AVL-APU
dominio: AVL
entidade: Apuração por Etapa
prioridade: P2
mvp: false
data_model_ref: data-models/avaliacao.md#apuracao-por-etapa
endpoints: []
error_codes: []
depende_de: [AVL-APU-08]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Exportar Relatório da Etapa
> **Nível 3** - Feature Set: Apuração e Devolutiva — Domínio: Avaliação - `AVL-APU-09`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Gera a planilha com o resultado completo de uma etapa — um resumo por estado e grupo e, para cada tipo de participante, a lista das inscrições com colocação, média, selos e as notas de cada avaliador — para uso fora do sistema.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Etapa | seleção → Etapa da premiação | somente leitura | lista de opções | sim | a etapa em consulta no ranking |
| Unidade federativa | seleção → Unidade Federativa | somente leitura | lista de opções | não | recorte herdado da consulta; limitado às unidades do usuário quando Administrador Regional |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Resumo por estado e grupo | uma linha por estado e grupo, com participantes, classificados, premiados, data e responsável pelo fechamento — na primeira aba da planilha | Ao gerar a planilha |
| Detalhe por tipo de participante | uma aba por tipo de participante com inscrições no resultado; cada campo do formulário daquele tipo vira uma coluna, e cada avaliador ocupa um bloco de quatro colunas | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório da etapa | Ao entregar a planilha |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Exportar Relatório da Etapa | SE | 7 | 19 | Alta | 7 | 2026-10-02 |

### Memória de cálculo

**Exportar Relatório da Etapa** — SE. Formas de lógica: 3 (apelido numerado no lugar do avaliador, na avaliação às cegas), 4, 7, 8, 9 (o resumo por estado e grupo conta participantes, classificados e premiados), 11, 12. Intenção primária: apresentar, com dado derivado.
- **ALR (7)**: Avaliação de Inscrição *(apuração, notas por avaliador e feedback consolidado)* · Inscrição *(identificação e respostas)* · Premiação *(a Etapa e a configuração de avaliação às cegas)* · Categoria · Modalidade · Tipo de Participante *(as respostas do formulário e do questionário)* · Usuário *(os avaliadores e o recorte por UF do Regional, regra 5)*.
- **DER (19)** — entrada (2): Etapa · Unidade federativa. Saída do resumo (5): Estado · Grupo · Participantes · Classificados · Premiados. Saída do detalhe (9): Tipo de participante · Identificação da inscrição · Respostas da inscrição · **Colocação** · **Média final** · Nota por avaliador · Avaliador ou apelido · Feedback consolidado · Decisão de corte. Padrão (3): Nome do arquivo · Mensagem · Ação. Nas abas por tipo de participante a **Colocação** precede a **Média final**.
- **Fora da contagem**: a ausência de limite de linhas (regra 6) é característica do processamento, não DER.

**Total: 7 PF** (1 processo elementar). A inclusão da colocação e da média final em 2026-10-02 levou o DER de 17 a 19, dentro da mesma faixa de 6 a 19 — a complexidade segue Alta e o PF não se move. A conciliação de 2026-10-04 com o resumo de entrega da Sprint 6 confirmou os dois DER e não acrescentou nenhum: a célula vazia no estado aberto e o valor gravado como número são características do mesmo dado.

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Origem corrigida · feature alterada | **Correção** da origem e **inclusão** das regras da colocação. *Antes* a `## Superfície` dizia que o relatório é acionado na Consulta de Ranking da Etapa, e nenhuma regra falava de colocação — ela aparecia só na descrição e num cenário. *Agora* a origem é a tela de **Fechamento de Etapa**, confirmada pelo resumo de entrega da Sprint 6 (o Ranking é somente leitura, sem ações), e três regras novas fixam o comportamento da coluna: vem do ranking sem recálculo (RN7), fica vazia em estado aberto (RN8), sai como número ordenável (RN9). A RN10 registra que a planilha reflete a desclassificação. +4 regras, +2 cenários, +1 critério. Sem Δ PF |
| 2026-10-02 | Análise de impacto `PDTIC25093-64` (docqui) | Memória de cálculo corrigida | **Inclusão** da colocação no ranking e da média final na enumeração de DER, que é o que o card pede. *Antes* a descrição e o cenário do caminho feliz já diziam que cada linha da planilha traz colocação e média, mas a memória de cálculo não as enumerava — DER 17. *Agora* DER 19, na mesma faixa de 6 a 19: complexidade Alta e **7 PF** inalterados. Registrado em `## Superfície` o ⚠️ de que o card localiza o relatório na tela de fechamento, e não na de ranking |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exportação do relatório da etapa em planilha multi-abas) — capacidade implementada e até então não especificada |

---

*Feature Set: Apuração e Devolutiva · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
