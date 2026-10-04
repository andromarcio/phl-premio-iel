<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-PAI-04
feature_set: AVL-PAI
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliacao-de-inscricao
endpoints: []
error_codes: []
depende_de: [AVL-PAI-01]
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

# Exportar Relatório de Avaliadores
> **Nível 3** - Feature Set: Painel Administrativo de Avaliações — Major Feature Set: Avaliação - `AVL-PAI-04`

## Descrição
Entrega em planilha o acompanhamento das avaliações por avaliador — quantas cada um tem alocadas, a iniciar, em andamento e finalizadas, e a lista de avaliações que sustenta esses números — para cobrança e acompanhamento fora do sistema.

No Painel de Avaliações, depois de aplicar os filtros da consulta, o administrador aciona a exportação e recebe para download a planilha com o resumo por avaliador e a lista das avaliações.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Painel de Avaliações (`/avaliacao-admin/avaliacoes`), ação de exportação

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/painel-administrativo/flow.html`

---

</div>

## Regras de negócio

1. A exportação usa exatamente os mesmos critérios da consulta que a originou. → ver `AVL-PAI-01`
2. A exportação não é paginada: traz todas as avaliações do recorte.
3. O relatório apresenta dois níveis: o total por avaliador e a lista das avaliações individuais.
4. Quando a premiação está configurada com avaliação às cegas, o identificador de acesso do avaliador é omitido do relatório.
5. O Administrador Regional exporta apenas as avaliações das unidades federativas às quais está vinculado.
6. A exportação é restrita aos perfis Administrador Nacional e Administrador Regional.

---

## Cenários

```gherkin
Feature: Exportar Relatório de Avaliadores

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Exportar o acompanhamento por avaliador
    Given que consultei o painel de avaliações com filtros aplicados
    When aciono a exportação
    Then o sistema entrega uma planilha com o resumo por avaliador e a lista das avaliações
    And o resumo traz, por avaliador, as quantidades alocadas, a iniciar, em andamento e finalizadas

  Scenario: Exportar com avaliação às cegas
    Given que a premiação está configurada com avaliação às cegas
    When exporto o relatório de avaliadores
    Then o identificador de acesso do avaliador não aparece na planilha

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Recorte sem avaliações
    Given que os filtros escolhidos não devolvem nenhuma avaliação
    When exporto o relatório
    Then a planilha é entregue sem linhas de avaliação

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Avaliador tenta exportar
    Given que estou autenticado como Avaliador
    When tento exportar o relatório de avaliadores
    Then o sistema nega a operação
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Premiação | Premiação | entrada do usuário | somente leitura | seleção → Premiação | sim | herdada da consulta que originou a exportação |
| Etapa | Etapa | entrada do usuário | somente leitura | seleção → Etapa | sim | herdada da consulta que originou a exportação |
| Estado | Unidade Federativa | entrada do usuário | somente leitura | seleção múltipla → Unidade Federativa | sim | herdado da consulta que originou a exportação |
| Situação | dado de código | entrada do usuário | somente leitura | lista de opções | sim | herdada da consulta que originou a exportação |

*Os quatro critérios são os da consulta do Painel de Avaliações que originou a exportação (regra 1) — antes registrados numa linha só, Critérios da consulta, com o painel como origem.*

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Resumo por avaliador | uma linha por avaliador com as quantidades alocadas, a iniciar, em andamento e finalizadas | Ao gerar a planilha |
| Detalhe das avaliações | uma linha por avaliação, com avaliador, unidade federativa, premiação, etapa, protocolo, participante, situação, início e finalização | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório de avaliadores | Ao entregar a planilha |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Avaliação de Inscrição | lê | A situação, o início e a finalização de cada avaliação, que alimentam o resumo por avaliador e a lista (regra 3) |
| Alocação de Avaliadores | lê | Quem está alocado a cada grupo do recorte |
| Inscrição | lê | O protocolo, o participante e a unidade federativa de cada inscrição avaliada (regras 3 e 5) |
| Usuário | lê | O avaliador, o seu identificador de acesso e as UFs que recortam o que o Administrador Regional exporta (regras 4 e 5) |

---

## Comportamento de tela

### Onde fica
Ação de exportação no Painel de Avaliações (`/avaliacao-admin/avaliacoes`), aplicada sobre os filtros já escolhidos na consulta. A planilha é baixada pelo navegador.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto a planilha é gerada |
| Erro de validação | Não se aplica (os critérios vêm da consulta) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | O download da planilha começa |
| Empty state | Recorte sem avaliações gera planilha sem linhas |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A planilha traz o total por avaliador e a lista das avaliações do mesmo recorte da consulta | cenário "Exportar o acompanhamento por avaliador" |
| SC-02 | A avaliação às cegas é preservada na planilha | cenário "Exportar com avaliação às cegas" |

---

## Métricas de tamanho

> Contagem realizada em 2026-09-01 sobre este N3, para os processos elementares que **não existem no baseline APF** de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Regras do IFPUG CPM 4.3.1; as convenções de ALR seguem as do próprio baseline (Categoria, Modalidade e Tipo de Participante contam separado; UF vive no ALI Usuário; Etapa, Apuração por Etapa, Fechamento por UF e Desempate são subgrupos dos ALIs Premiação e Avaliação de Inscrição, não arquivos próprios). ⚠️ **Pendente de validação pela equipe de métricas.**

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Exportar Relatório de Avaliadores | principal | SE | 5 | 17 | Alta | 7 | 2026-09-01 |

### Memória de cálculo

**Exportar Relatório de Avaliadores** — SE · ALR 5 · DER 17 · Alta · 7 PF

```json
{"pe": "Exportar Relatório de Avaliadores",
 "alr": ["Alocação Avaliadores", "Avaliação de Inscrição", "Inscrição", "Premiação", "Usuário"],
 "der": ["Premiação (filtro)", "Etapa (filtro)", "Estado", "Situação", "Avaliador", "Alocadas", "A iniciar", "Em andamento", "Finalizadas", "Unidade federativa", "Premiação (detalhe)", "Etapa (detalhe)", "Inscrição", "Situação da avaliação", "Nome do arquivo", "Mensagem", "Ação"]}
```

Formas de lógica: 3 (omite o identificador de acesso na avaliação às cegas), 4, 7, 8, 9 (os totais por avaliador — alocadas, a iniciar, em andamento e finalizadas), 11, 12. Intenção primária: apresentar, com dado derivado.

Por que cada ALR:
1. `Alocação Avaliadores` — quem está alocado a cada grupo
2. `Avaliação de Inscrição` — a situação de cada avaliação
3. `Inscrição` — a inscrição avaliada
4. `Premiação` — a Etapa e a configuração de avaliação às cegas
5. `Usuário` — o avaliador e o recorte por UF do Regional (regra 5)

Como os 17 DER se distribuem: entrada (4), herdada do painel — Premiação, Etapa, Estado e Situação; saída do resumo (5) — Avaliador, Alocadas, A iniciar, Em andamento e Finalizadas; saída do detalhe (5) — Unidade federativa, Premiação, Etapa, Inscrição e Situação da avaliação; padrão (3) — Nome do arquivo, Mensagem e Ação.

⚠️ A contagem conta *Premiação* e *Etapa* duas vezes — como critério herdado do painel e como coluna do detalhe —, e o mesmo ocorre, com rótulos diferentes, com *Estado* e *Unidade federativa* e com *Situação* e *Situação da avaliação*. Pelo CPM o mesmo DER conta uma vez (entrada ∪ saída); mantido como a contagem de 2026-09-01 o registrou, com o lugar de cada um entre parênteses, a confirmar com a equipe de métricas. Sem as quatro repetições o DER cairia a 13, ainda na faixa de 6 a 19, e com ALR 5 a SE segue Alta — o PF não se move.

Fora da contagem: a ausência de paginação (regra 2) é característica do processamento, não DER.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); coluna Entidade em `## Campos`, com a linha única Critérios da consulta separada nos quatro critérios herdados do painel e o Preenchimento corrigido; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com os DER repetidos desambiguados entre filtro e detalhe e o porquê de cada ALR em prosa. Sem mudança de regra, cenário ou número de PF |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exportação do relatório de avaliadores em duas visões) — capacidade implementada e até então não especificada |

---

*Feature Set: Painel Administrativo de Avaliações · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
