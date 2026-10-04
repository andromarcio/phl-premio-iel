<!-- docqui: 2.8.0 | prompt: PROMPT_3A | atualizado: 2026-08-28 -->
---
id: AVL-APU-10
feature_set: AVL-APU
dominio: AVL
entidade: Inscrição
prioridade: P2
mvp: false
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Gerar Relatório de Inscrições
> **Nível 3** - Feature Set: Apuração e Devolutiva — Domínio: Avaliação - `AVL-APU-10`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Apresenta ao administrador nacional todas as inscrições de uma premiação separadas por tipo de participante, com as respostas de cada uma, filtráveis por unidade federativa, categoria, modalidade, situação e período de início — em tela, com amostra de cada grupo, e em planilha, com o recorte completo.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/validacao-inscricao/relatorio-inscricoes`; a mesma tela oferece a ação "Exportar XLSX"

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/apuracao-devolutiva/flow-relatorios.html`

---

</div>

## Regras de negócio

1. O relatório sempre exige uma premiação escolhida.
2. O relatório abrange inscrições em qualquer situação, e não apenas as paradas. → ver `AVL-APU-06` (Gerar Relatório de Inscrições Paradas)
3. As inscrições do relatório são agrupadas por tipo de participante.
4. Cada grupo carrega o total de inscrições que atendem aos critérios, independentemente de quantas sejam apresentadas.
5. A consulta em tela devolve uma amostra de cada grupo; o conjunto completo sai pela exportação em planilha.
6. O relatório é restrito ao Administrador Nacional, tanto na tela quanto na exportação.
7. A exportação usa exatamente os mesmos critérios da consulta que a originou e não aplica o corte de amostra: traz todas as inscrições do recorte.
8. O conteúdo exportado de cada inscrição é o mesmo que a consulta devolve, com a mesma separação por tipo de participante.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Consultar as inscrições de uma premiação
  Given que sou Administrador Nacional
  When escolho a premiação e aciono o relatório
  Then vejo as inscrições agrupadas por tipo de participante, com as respostas de cada uma
  And cada grupo informa o total de inscrições que atendem aos filtros

Scenario: Restringir o relatório por situação e período
  Given que o relatório de uma premiação está apresentado
  When seleciono as situações Validada e Rejeitada e um período de início
  Then a consulta passa a considerar apenas as inscrições que atendem a esses critérios

# ── Erros de validação ─────────────────────────────────────────

Scenario: Consultar sem escolher a premiação
  When aciono o relatório sem escolher a premiação
  Then o sistema não monta o relatório e aponta a premiação como obrigatória

# ── Estados especiais ──────────────────────────────────────────

Scenario: Grupo maior que a amostra apresentada
  Given que um tipo de participante tem mais inscrições do que a amostra apresentada
  When consulto o relatório
  Then o sistema informa quantas inscrições estão sendo exibidas do total e orienta a exportar para obter a lista completa

Scenario: Nenhuma inscrição no recorte
  Given que os filtros escolhidos não devolvem nenhuma inscrição
  When consulto o relatório
  Then o sistema informa que não há inscrições para os critérios aplicados

Scenario: Exportar o relatório completo
  Given que consultei o relatório de inscrições com filtros aplicados
  When aciono "Exportar XLSX"
  Then o sistema entrega uma planilha com todas as inscrições do recorte, separadas por tipo de participante

Scenario: Exportar um recorte maior que a amostra
  Given que um grupo tem mais inscrições do que as apresentadas na consulta
  When exporto o relatório
  Then a planilha traz todas as inscrições desse grupo, e não apenas as apresentadas

Scenario: Exportar um recorte sem inscrições
  Given que os filtros escolhidos não devolvem nenhuma inscrição
  When exporto o relatório
  Then a planilha é entregue sem linhas de inscrição

Scenario: Exportar sem escolher a premiação
  When aciono a exportação sem escolher a premiação
  Then o sistema não gera a planilha e aponta a premiação como obrigatória

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Administrador regional tenta consultar
  Given que estou autenticado como Administrador Regional
  When tento abrir o relatório de inscrições
  Then o sistema nega o acesso

Scenario: Administrador regional tenta exportar
  Given que estou autenticado como Administrador Regional
  When tento exportar o relatório de inscrições
  Then o sistema nega a operação
```

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Colunas de identificação da inscrição | Inscrição | — |
| Colunas das respostas do tipo de participante | Inscrição | — |

*As colunas de cada grupo variam com o tipo de participante: cada campo configurado para aquele tipo aparece como uma coluna.*

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Premiação | seleção → Premiação | editável | lista de opções | sim | apenas premiações ativas |
| Unidade federativa | seleção → Unidade Federativa | editável | lista de opções | não | vazio significa todas |
| Categoria | seleção → Categoria da premiação | editável | lista de opções | não | apenas categorias vinculadas à premiação escolhida |
| Modalidade | seleção → Modalidade da categoria | editável | lista de opções | não | apenas modalidades da categoria escolhida |
| Situação | entrada do usuário | editável | lista de opções (múltipla) | não | vazio significa todas as situações |
| Início a partir de | entrada do usuário | editável | data | não | menor ou igual a "Início até" |
| Início até | entrada do usuário | editável | data | não | maior ou igual a "Início a partir de" |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Total de inscrições do grupo | quantidade de inscrições do tipo de participante que atendem aos filtros | Ao montar o relatório |
| Separação por tipo de participante | uma aba por tipo de participante com inscrições no recorte | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório de inscrições | Ao entregar a planilha |

---

## Comportamento de tela

### Onde fica
Página própria em `/validacao-inscricao/relatorio-inscricoes`, alcançada a partir da área administrativa de validação. Traz o painel de filtros no topo — premiação, unidade federativa, categoria, modalidade, situação e período de início —, as ações de limpar e de exportar, e abaixo um bloco por tipo de participante com a amostra das inscrições. A ação "Exportar XLSX" entrega o mesmo recorte em planilha, com uma aba por tipo de participante e sem o corte de amostra; fica desabilitada enquanto não houver premiação escolhida ou enquanto a planilha é gerada.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe indicador no lugar dos blocos enquanto o relatório é montado |
| Erro de validação | Destaca a premiação não escolhida |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta um bloco por tipo de participante, com o total do grupo e o aviso de amostra quando houver mais inscrições do que as exibidas; a exportação inicia o download da planilha |
| Empty state | Sem inscrições no recorte, informa que não há inscrições para os critérios aplicados; a planilha é entregue sem linhas |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O administrador vê as inscrições da premiação agrupadas por tipo de participante, com as respostas de cada uma | cenário "Consultar as inscrições de uma premiação" |
| SC-02 | O total real de cada grupo fica visível mesmo quando a tela mostra só parte das inscrições | cenário "Grupo maior que a amostra apresentada" |
| SC-03 | A planilha traz todas as inscrições do recorte, sem o corte de amostra da consulta | cenário "Exportar um recorte maior que a amostra" |
| SC-04 | Os critérios da planilha são os mesmos aplicados na consulta em tela | cenário "Exportar o relatório completo" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Relatório de Inscrições | SE | 6 | 14 | Alta | 7 | 2026-09-01 |
| Exportar Relatório de Inscrições | SE | 6 | 13 | Alta | 7 | 2026-09-01 |

### Memória de cálculo

**Consultar Relatório de Inscrições** — SE. Formas de lógica: 4 (os cinco filtros), 7, 8, 9 (o total de inscrições do grupo, independente da amostra apresentada, e o aviso de amostra), 11, 12, 13. Intenção primária: apresentar, com dado derivado.

```json
{"pe": "Consultar Relatório de Inscrições",
 "alr": ["Inscrição", "Premiação", "Categoria", "Modalidade", "Tipo de Participante", "Usuário"],
 "der": ["Premiação", "Unidade federativa", "Categoria", "Modalidade", "Situação", "Início a partir de", "Início até", "Tipo de participante", "Colunas de identificação da inscrição", "Colunas das respostas", "Total de inscrições do grupo", "Aviso de amostra", "Mensagem", "Ação"]}
```
- **ALR (6)**: Inscrição *(as inscrições e as respostas de cada uma)* · Premiação · Categoria · Modalidade · Tipo de Participante *(uma coluna por campo configurado para o tipo)* · Usuário *(a UF do filtro)*.
- **DER (14)** — entrada (7): Premiação · Unidade federativa · Categoria · Modalidade · Situação · Início a partir de · Início até. Saída (5): Tipo de participante · Colunas de identificação da inscrição · Colunas das respostas · Total de inscrições do grupo · Aviso de amostra · Mensagem · Ação.
- **Fora da contagem**: as colunas variam com o tipo de participante — são um DER de agrupamento cada, não uma por campo configurado, porque o conjunto é o mesmo atributo lógico repetido.

**Exportar Relatório de Inscrições** — SE. Mesmos dados e mesmo recorte da consulta, sem o corte de amostra e com uma aba por tipo de participante. Formas de lógica: 4, 7, 8, 9, 11, 12. É PE distinto pela convenção de contrato destes sistemas — ver `global/SIZING.md` → *Funcionalidades iguais em formatos de saída diferentes*.

```json
{"pe": "Exportar Relatório de Inscrições",
 "alr": ["Inscrição", "Premiação", "Categoria", "Modalidade", "Tipo de Participante", "Usuário"],
 "der": ["Premiação", "Unidade federativa", "Categoria", "Modalidade", "Situação", "Início a partir de", "Início até", "Separação por tipo de participante", "Colunas de identificação", "Colunas das respostas", "Nome do arquivo", "Mensagem", "Ação"]}
```
- **ALR (6)**: Inscrição · Premiação · Categoria · Modalidade · Tipo de Participante · Usuário *(os mesmos da consulta)*.
- **DER (13)** — entrada (7), herdada da consulta: Premiação · Unidade federativa · Categoria · Modalidade · Situação · Início a partir de · Início até. Saída (4): Separação por tipo de participante · Colunas de identificação · Colunas das respostas · Nome do arquivo · Mensagem · Ação.
- **Fora da contagem**: o aviso de amostra e o total do grupo não vão para a planilha — a exportação traz o recorte inteiro.

**Total: 14 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processos elementares contados sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **14 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Decisão 6 (docqui) | Features unificadas | `AVL-APU-11` Exportar Relatório de Inscrições incorporada: mesmos dados e mesmo recorte, logo é uma ação só do ponto de vista da feature. A contagem não muda — a feature passa a absorver dois PE, ambos ainda a contar. O ID `AVL-APU-11` fica aposentado e não será reutilizado |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (relatório geral de inscrições, distinto do relatório de inscrições paradas) — capacidade implementada e até então não especificada |

---

*Feature Set: Apuração e Devolutiva · Domínio: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
