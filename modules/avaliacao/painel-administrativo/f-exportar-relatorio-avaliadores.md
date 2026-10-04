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
> **Nível 3** - Feature Set: Painel Administrativo — Major Feature Set: Avaliação - `AVL-PAI-04`

## Descrição
Entrega em planilha o acompanhamento das avaliações por avaliador — quantas cada um tem alocadas, a iniciar, em andamento e finalizadas, e a lista de avaliações que sustenta esses números — para cobrança e acompanhamento fora do sistema.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Critérios da consulta | Painel de Avaliações | somente leitura | conjunto de critérios | sim | herdados da consulta que originou a exportação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Resumo por avaliador | uma linha por avaliador com as quantidades alocadas, a iniciar, em andamento e finalizadas | Ao gerar a planilha |
| Detalhe das avaliações | uma linha por avaliação, com avaliador, unidade federativa, premiação, etapa, protocolo, participante, situação, início e finalização | Ao gerar a planilha |
| Nome do arquivo | identificação do relatório de avaliadores | Ao entregar a planilha |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Exportar Relatório de Avaliadores | SE | 5 | 17 | Alta | 7 | 2026-09-01 |

### Memória de cálculo

**Exportar Relatório de Avaliadores** — SE. Formas de lógica: 3 (omite o identificador de acesso na avaliação às cegas), 4, 7, 8, 9 (os totais por avaliador — alocadas, a iniciar, em andamento e finalizadas), 11, 12. Intenção primária: apresentar, com dado derivado.
- **ALR (5)**: Alocação Avaliadores *(quem está alocado a cada grupo)* · Avaliação de Inscrição *(a situação de cada avaliação)* · Inscrição *(a inscrição avaliada)* · Premiação *(a Etapa e a configuração de avaliação às cegas)* · Usuário *(o avaliador e o recorte por UF do Regional, regra 5)*.
- **DER (17)** — entrada (4), herdada do painel: Premiação · Etapa · Estado · Situação. Saída do resumo (5): Avaliador · Alocadas · A iniciar · Em andamento · Finalizadas. Saída do detalhe (5): Unidade federativa · Premiação · Etapa · Inscrição · Situação da avaliação · Nome do arquivo · Mensagem · Ação.
- **Fora da contagem**: a ausência de paginação (regra 2) é característica do processamento, não DER.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-02 | Protótipo (docqui) | Protótipo vinculado | A feature passa a estar desenhada — fidelidade **referência**. Era uma das cinco da SP05 sem protótipo |
| 2026-09-01 | Contagem APF (docqui) | Contagem realizada | Processo elementar contado sobre este N3 — fora do baseline de 2026-02-28, porque a capacidade não existia então. **7 PF**, com a memória de cálculo (ALR e DER nomeados). ⚠️ Pendente de validação pela equipe de métricas |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (exportação do relatório de avaliadores em duas visões) — capacidade implementada e até então não especificada |

---

*Feature Set: Painel Administrativo · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
