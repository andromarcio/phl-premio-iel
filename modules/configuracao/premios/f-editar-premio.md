<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-03
feature_set: CFG-PRE
dominio: CFG
entidade: Premiação
data_model_ref: data-models/configuracao.md#premiacao
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

# Editar Prêmio
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-03`

## Descrição
Permite ao administrador alterar os dados de uma edição já criada — nome, descrição, período e banner — mantendo a configuração da premiação atualizada.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-002_Cadastrar_Premios`](../../../hus/HU-002_Cadastrar_Premios.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` (Formulário do Prêmio, aba Dados)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O nome do prêmio é único em todo o sistema.
2. A data de início não pode ser posterior à data de término. → ver RULES-DICTIONARY: Período de vigência (parâmetro: data de início ≤ data de término)
3. A situação (ativa/inativa) da edição não é alterada na edição de dados; sua mudança ocorre apenas pela ação própria de ativação/inativação.

---

## Cenários

```gherkin
Feature: Editar Prêmio

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar dados da edição
    Given que selecionei uma edição existente
    When altero o nome, a descrição e o período e clico em "Salvar"
    Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome apagado na edição
    Given que estou editando uma edição
    When apago o campo Nome e clico em "Salvar"
    Then o sistema não grava e exibe "Campo obrigatório."

  Scenario: Período invertido na edição
    Given que altero a data de término para antes da data de início
    When clico em "Salvar"
    Then o sistema não grava e exibe "A data de término deve ser igual ou posterior à data de início."

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Renomear para um nome já usado
    Given que já existe outra edição "Prêmio IEL de Talentos 2025"
    When renomeio a edição atual para "Prêmio IEL de Talentos 2025"
    Then o sistema não grava e exibe "Já existe um prêmio com este nome."
    # ← MESSAGE-DICTIONARY: CFG_PREMIO_NOME_DUPLICADO
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome da premiação | entrada do usuário | editável | texto | sim | único no sistema; máximo de 200 caracteres |
| Descrição | entrada do usuário | editável | texto longo | não | texto livre |
| Data de início | entrada do usuário | editável | data | sim | não posterior à data de término |
| Data de término | entrada do usuário | editável | data | sim | igual ou posterior à data de início |
| Imagem do banner | entrada do usuário | editável | imagem | não | imagem de identidade visual da edição |
| Situação | — | somente leitura | lista (Ativo, Inativo) | — | alterada apenas pela ação de ativação/inativação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Formulário da edição em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar`, aba "Dados", com os mesmos campos do cadastro; a situação aparece como somente leitura e a barra de ações dá acesso aos Termos de Aceite e aos Links Públicos.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de dados de uma edição são persistidas | cenário "Editar dados da edição" |
| SC-02 | A tentativa de renomear para um nome já usado é rejeitada | cenário "Renomear para um nome já usado" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — edição do prêmio diluída nas abas de "Gerenciar Prêmio" ⚠️. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
