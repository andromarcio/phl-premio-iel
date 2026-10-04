<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-01
feature_set: CFG-PRE
dominio: CFG
entidade: Premiação
data_model_ref: data-models/configuracao.md#premiacao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-001_Gerenciar_Premios
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

# Pesquisar Prêmios
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-01`

## Descrição
Permite ao administrador localizar edições da premiação por nome e por período de datas, listando os resultados de forma paginada para consulta, configuração ou reaproveitamento.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-001_Gerenciar_Premios`](../../../hus/HU-001_Gerenciar_Premios.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes` (Lista de Prêmios)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A busca abrange todas as edições cadastradas, tanto ativas quanto inativas.
2. A busca por nome é por correspondência parcial, dispensando o nome exato.
3. O período informado restringe o resultado às edições cujo intervalo entre data de início e data de término se sobrepõe ao intervalo pesquisado.
4. Edições inativas constam do resultado administrativo, mas não são ofertadas nos fluxos públicos de inscrição.

---

## Cenários

```gherkin
Feature: Pesquisar Prêmios

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Listar prêmios cadastrados
    Given que existem edições cadastradas
    When acesso a lista de Prêmios
    Then o sistema exibe as edições com nome, categorias vinculadas, período e situação

  Scenario: Pesquisar por nome e período
    Given que estou na lista de Prêmios
    When informo parte do nome e um intervalo de datas e confirmo a busca
    Then o sistema apresenta apenas as edições que correspondem aos critérios informados

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Limpar os critérios de busca
    Given que apliquei critérios de nome e período
    When aciono a limpeza dos critérios
    Then o sistema recarrega a lista sem nenhum critério aplicado

  Scenario: Busca sem resultados
    Given que nenhuma edição corresponde aos critérios informados
    When confirmo a busca
    Then o sistema exibe "Nenhum resultado para a busca."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | não | correspondência parcial; máximo de 200 caracteres |
| Início do período | entrada do usuário | editável | data | não | limite inicial do intervalo pesquisado |
| Fim do período | entrada do usuário | editável | data | não | limite final do intervalo pesquisado |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Nome da premiação | Premiação | padrão ↑ |
| Categorias vinculadas | derivado (contagem) | — |
| Data de início | Premiação | ordenável |
| Data de término | Premiação | ordenável |
| Situação | Premiação | ordenável |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página própria em `/configuracao-premiacao/premiacoes` (Lista de Prêmios): campo de busca por nome, seletor de intervalo de datas e a lista paginada de edições, com padrão de 10 registros por página.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto a lista é recuperada |
| Erro de validação | Não se aplica (critérios são opcionais) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe a lista de edições correspondentes |
| Empty state | Sem edições cadastradas: "Nenhum registro encontrado."; busca sem resultado: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A lista é paginada com padrão de 10 itens por página e permite navegar entre páginas | Critério de aceite 1 (HU-001) |
| SC-02 | Os critérios de nome e período funcionam de forma combinada e individual | Critério de aceite 2 (HU-001) |
| SC-03 | A busca por parte do nome retorna as edições cujo nome contém o termo | cenário "Pesquisar por nome e período" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Pesquisar Premiações | SE | 1 | 7 | Simples | 4 | 2026-02-28 |

### Memória de cálculo

- **Pesquisar Premiações** — ALR (1): Premiação. DER (7): Nome · Período · Data de Início · Data Fim · Qtd Categoria · Ação · Mensagem.

```json
{"pe": "Pesquisar Premiações",
 "alr": ["Premiação"],
 "der": ["Nome", "Período", "Data de Início", "Data Fim", "Qtd Categoria", "Ação", "Mensagem"]}
```

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-001 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
