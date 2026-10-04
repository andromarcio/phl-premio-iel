<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-FIL-02
feature_set: VAL-FIL
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-023_Dashboard_Gerencial_Validacao
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

# Acompanhar Painel de Validação
> **Nível 3** - Feature Set: Fila e Painel de Validação — Major Feature Set: Validação - `VAL-FIL-02`

## Descrição
Permite ao validador acompanhar as métricas de validação de uma premiação, com a distribuição das inscrições por situação e a comparação por categoria ou por unidade federativa.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-023_Dashboard_Gerencial_Validacao`](../../../hus/HU-023_Dashboard_Gerencial_Validacao.docx) | Criação | — |
| [`PDTIC25093-58`](../../../analise-impacto/AIM-PDTIC25093-58.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/validacao-inscricao/dashboard` (Dashboard Gerencial de Validação)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/fila-validacao/flow.html`

---

</div>

## Regras de negócio

1. As métricas exigem uma premiação selecionada; sem premiação, não há dados a consolidar.
2. As métricas do validador regional restringem-se às unidades federativas a que ele está vinculado.
3. A distribuição por situação considera as situações de validação: Finalizada, Em Validação, Validada, Rejeitada, Aguardando Ajuste e Ajustes Concluídos.
4. O conjunto de inscrições que sustenta as métricas é o mesmo que a exportação do histórico leva para a planilha. → ver `VAL-FIL-03` (Exportar Histórico do Painel de Validação).

---

## Cenários

```gherkin
Feature: Acompanhar Painel de Validação

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Acompanhar a distribuição por situação
    Given que selecionei uma premiação no dashboard
    When as métricas são carregadas
    Then o sistema exibe a distribuição das inscrições por situação de validação

  Scenario: Comparar por categoria ou por unidade
    Given que estou acompanhando as métricas de uma premiação
    When alterno a comparação entre "Por Categoria" e "Por UF"
    Then o sistema exibe as inscrições agrupadas pela dimensão escolhida

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Restrição por período
    Given que informo uma data de início e uma data de fim
    When as métricas são recalculadas
    Then o sistema considera apenas as inscrições dentro do período informado

  Scenario: Sem premiação selecionada
    Given que nenhuma premiação está selecionada
    When acesso o dashboard
    Then o sistema não carrega os gráficos e exibe "Nenhum registro encontrado."

```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| UF | entrada do usuário | editável | lista (unidades federativas) | condicional | obrigatória para o validador regional; restrita às unidades a que está vinculado |
| Premiação | entrada do usuário | editável | lista (premiações) | sim | obrigatória para carregar as métricas |
| Categoria | entrada do usuário | editável | lista (categorias da premiação) | não | habilitada após escolher a premiação |
| Modalidade | entrada do usuário | editável | lista (modalidades da categoria) | não | habilitada após escolher a categoria |
| Data início | entrada do usuário | editável | data | não | início do período de apuração |
| Data fim | entrada do usuário | editável | data | não | fim do período de apuração |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Distribuição por situação | Quantidade de inscrições em cada situação de validação, dentro do recorte apurado | Ao carregar as métricas |
| Comparação por categoria ou por UF | Quantidade de inscrições por categoria ou por unidade federativa, conforme a dimensão escolhida | Ao carregar as métricas |

---

## Comportamento de tela

### Onde fica
Página própria em `/validacao-inscricao/dashboard` (Dashboard Gerencial de Validação), alcançada pelo botão "Dashboard Gerencial" da Fila de Validação: filtros em cascata (UF, premiação, categoria, modalidade e período), gráfico de distribuição das inscrições por situação, gráfico de barras empilhadas com alternância entre "Por Categoria" e "Por UF" e o botão de retorno à fila. A mesma tela oferece a ação "Exportar Excel", que é feature própria — ver `VAL-FIL-03` (Exportar Histórico do Painel de Validação).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto as métricas são recuperadas |
| Erro de validação | Não se aplica (premiação é pré-requisito de carga, não erro de formulário) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe os gráficos de distribuição por situação e a comparação por categoria ou UF |
| Empty state | Sem premiação selecionada: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O dashboard exibe a distribuição das inscrições por situação para a premiação selecionada | cenário "Acompanhar a distribuição por situação" |
| SC-02 | A comparação alterna entre "Por Categoria" e "Por UF" sobre os mesmos dados | cenário "Comparar por categoria ou por unidade" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Dashboard Gerencial | SE | 4 | 12 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

- **Consultar Dashboard Gerencial** — ALR (4): Premiação · Categoria · Modalidade · Inscrição. DER (12): UF · Premiação · Categoria · Modalidade · Data Inicio · Data Fim · Status · Qtd por Status · Qtd por UF/Status · Qtd por Categoria/Status · Ação · Mensagem.

```json
{"pe": "Consultar Dashboard Gerencial",
 "alr": ["Premiação", "Categoria", "Modalidade", "Inscrição"],
 "der": ["UF", "Premiação", "Categoria", "Modalidade", "Data Inicio", "Data Fim", "Status", "Qtd por Status", "Qtd por UF/Status", "Qtd por Categoria/Status", "Ação", "Mensagem"]}
```

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/fila-validacao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Especificação (docqui) | Exportação separada | A exportação do histórico saiu desta feature e virou `VAL-FIL-03` **Exportar Histórico do Painel de Validação**, conforme a decisão de produto de 2026-09-01. As regras 4 a 7, os cenários da exportação, os campos automáticos e os critérios SC-03 a SC-05 foram para lá; aqui ficou o ponteiro. A contagem desta feature não muda: os 7 PF são do `Consultar Dashboard Gerencial` |
| 2026-09-01 | Decisões de produto (docqui) | Limitação aceita | O produto confirmou estar ciente de que o nome e o telefone do participante são resolvidos pelos rótulos do formulário dinâmico e que renomear um rótulo esvazia a coluna na planilha. A regra 6 deixa de ser suposição a confirmar e passa a registrar a limitação como aceita |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Exportação do histórico em planilha documentada como ação da feature, restrita ao Administrador Nacional (APIPIT.22), com as informações Nome do Participante e Telefone resolvidas dos rótulos da inscrição |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-023 |

---

*Feature Set: Fila e Painel de Validação · Major Feature Set: Validação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
