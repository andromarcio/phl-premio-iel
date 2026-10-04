<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-11
feature_set: CFG-PRE
dominio: CFG
entidade: Termo de Aceite
data_model_ref: data-models/configuracao.md#termo-de-aceite
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-002_Cadastrar_Premios
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

# Excluir Termo de Aceite
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-11`

## Descrição
Permite ao administrador remover um termo de aceite da edição, deixando de exigi-lo dos participantes.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-002_Cadastrar_Premios`](../../../hus/HU-002_Cadastrar_Premios.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Termos de Aceite do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)*), na linha do termo

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A exclusão de um termo é lógica: o termo deixa de ser exigido dos participantes e permanece registrado para consulta posterior.
2. Um termo já aceito em inscrições concluídas permanece registrado no histórico dessas inscrições, independentemente da exclusão do termo na edição. ⚠️ *(derivado do modelo de dados — a confirmar)*

---

## Cenários

```gherkin
Feature: Excluir Termo de Aceite

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Excluir um termo de aceite
    Given que identifico um termo de aceite na relação da edição
    When aciono a exclusão do termo e confirmo "Deseja realmente excluir este registro?"
    Then o sistema remove o termo da edição e exibe "Registro excluído com sucesso."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Cancelar a exclusão
    Given que acionei a exclusão de um termo de aceite
    When cancelo a confirmação
    Then a operação é abortada e o termo permanece na relação da edição
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Termo de aceite | seleção na relação | somente leitura | seleção → Termo de Aceite | sim | termo a ser removido da edição |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação do termo | Excluído (exclusão lógica) | Ao confirmar a exclusão |

---

## Comportamento de tela

### Onde fica
Ação disparada na linha do termo, na tela Termos de Aceite do Prêmio (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Premiação → aba **Termos & E-mails**)*); a exclusão pede confirmação antes de efetivar e, ao concluir, o termo sai da relação apresentada.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto o termo é removido |
| Erro de validação | Não se aplica |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro excluído com sucesso." e atualiza a relação de termos |
| Empty state | Sem termos na edição: "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A exclusão exige confirmação e retira o termo da relação da edição | cenário "Excluir um termo de aceite" |
| SC-02 | O cancelamento da confirmação mantém o termo na edição | cenário "Cancelar a exclusão" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Excluir Termo de Aceite | EE | 1 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Excluir Termo de Aceite** — ALR (1): Premiação. DER (3): ID · Ação · Mensagem.

```json
{"pe": "Excluir Termo de Aceite",
 "alr": ["Premiação"],
 "der": ["ID", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
