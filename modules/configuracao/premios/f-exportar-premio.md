<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-05
feature_set: CFG-PRE
dominio: CFG
entidade: Premiação
data_model_ref: data-models/configuracao.md#premiacao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-003_Exportar_Premios
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

# Exportar Prêmios
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-05`

## Descrição
Permite ao administrador gerar uma planilha com toda a hierarquia de uma edição para reaproveitar a estrutura na criação de novas premiações.

Na linha da edição, na Lista de Prêmios, o administrador aciona o ícone de exportação e o download da planilha começa em seguida, sem sair da lista.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-003_Exportar_Premios`](../../../hus/HU-003_Exportar_Premios.docx) | Criação | `CA-1` — planilha completa, com uma aba para cada nível da hierarquia da edição |
| [`HU-001_Gerenciar_Premios`](../../../hus/HU-001_Gerenciar_Premios.docx) | Criação | `CA-5` — download da planilha iniciado automaticamente, sem abrir nova aba |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Lista de Prêmios (`/configuracao-premiacao/premiacoes`), na linha da edição

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A exportação abrange toda a hierarquia da edição, da premiação aos itens de configuração de inscrição e de avaliação de cada tipo de participante.
2. A planilha exportada preserva a edição de origem inalterada e serve de base para criar uma nova edição por importação.

---

## Cenários

```gherkin
Feature: Exportar Prêmios

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Exportar a hierarquia de uma edição
    Given que identifico uma edição na lista de Prêmios
    When aciono a exportação da edição
    Then o sistema gera a planilha com abas para premiação, categorias, modalidades, tipos de participante, enquadramentos, formulários, campos, questionários, questões, alternativas e anexos
    And o download da planilha inicia automaticamente, sem abrir nova aba

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Falha ao gerar a planilha
    Given que aciono a exportação de uma edição
    When ocorre uma falha durante a geração da planilha
    Then o sistema informa que não foi possível gerar o arquivo e nenhuma edição é alterada
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Prêmio | Premiação | entrada do usuário | somente leitura | seleção → Premiação | sim | edição escolhida na linha da lista, cuja hierarquia será exportada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Planilha da edição | Arquivo `.xlsx` com a hierarquia completa | Ao acionar a exportação |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Categoria | lê | Alimenta a aba de categorias da planilha (regra 1) |
| Premiação × Categoria | lê | Diz quais categorias pertencem à edição (regra 1) |
| Modalidade | lê | Alimenta a aba de modalidades |
| Modalidade × Categoria | lê | Diz quais modalidades pertencem a cada categoria da edição |
| Tipo de Participante | lê | Alimenta a aba de tipos de participante |
| Oferta | lê | Diz quais tipos de participante são ofertados em cada modalidade da edição |
| Enquadramento | lê | Alimenta a aba de enquadramentos de cada tipo de participante |
| Formulário Dinâmico | lê | Alimenta a aba de formulários de inscrição |
| Campo do Formulário | lê | Alimenta a aba de campos dos formulários |
| Questionário | lê | Alimenta a aba de questionários de avaliação |
| Questão de Avaliação | lê | Alimenta a aba de questões dos questionários |
| Alternativa da Questão | lê | Alimenta a aba de alternativas das questões |
| Configuração de Anexo | lê | Alimenta a aba de anexos exigidos |

---

## Comportamento de tela

### Onde fica
Ação disparada na linha da edição, na Lista de Prêmios (`/configuracao-premiacao/premiacoes`); ao ser acionada, o download da planilha começa automaticamente e a lista permanece na mesma posição.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto a planilha é gerada |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Inicia o download da planilha da edição |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A exportação gera uma planilha completa com todas as abas da hierarquia | Critério de aceite 1 (HU-003) |
| SC-02 | O download começa automaticamente, sem abrir nova aba | Critério de aceite 5 (HU-001) |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem PE no baseline ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), `## Origem` acrescentada com as HUs de que o N3 deriva (HU-003 e HU-001, como registra a linha *Feature criada*), com os critérios `CA-n` de cada uma e o bloco `origem` no front-matter, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel na tabela de `## Métricas de tamanho`. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado das HUs 001 e 003 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
