<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-02
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

# Cadastrar Prêmio
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-02`

## Descrição
Permite ao administrador registrar uma nova edição da premiação com nome, descrição, período e banner, deixando-a em modo de edição para a configuração dos demais itens.

Na Lista de Prêmios, o administrador aciona "Nova Premiação", informa o nome e o período e, se quiser, a descrição e o banner, e aciona "Salvar"; a edição criada segue aberta em modo de edição.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-002_Cadastrar_Premios`](../../../hus/HU-002_Cadastrar_Premios.docx) | Criação | `CA-1, CA-2, CA-3, CA-7` — nome obrigatório e único, com erro claro na duplicidade; data de término igual ou posterior à de início; edição aberta em modo de edição com o identificador gerado; validação dos campos obrigatórios antes de gravar |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/novo` (Formulário do Prêmio)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O nome do prêmio é único em todo o sistema.
2. A data de início não pode ser posterior à data de término. → ver RULES-DICTIONARY: RC-03 — Período de vigência (parâmetro: data de início ≤ data de término)
3. O banner da edição é opcional.

---

## Cenários

```gherkin
Feature: Cadastrar Prêmio

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Criar edição com dados válidos
    Given que acesso o formulário de nova premiação
    When informo o nome "Prêmio IEL de Talentos 2026", o período e salvo
    Then o sistema registra a edição e exibe "Registro salvo com sucesso."
    And a edição segue aberta em modo de edição para configurar termos e links públicos

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome em branco
    Given que estou no formulário de premiação
    When deixo o campo Nome em branco e clico em "Salvar"
    Then o sistema não registra e exibe "Campo obrigatório."

  Scenario: Data de término anterior à data de início
    Given que informo a data de início 01/06/2026 e a data de término 01/05/2026
    When clico em "Salvar"
    Then o sistema não registra e exibe "A data de término deve ser igual ou posterior à data de início."

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Nome de prêmio duplicado
    Given que já existe o prêmio "Prêmio IEL de Talentos 2026"
    When tento criar outra edição com o mesmo nome
    Then o sistema não registra e exibe "Já existe um prêmio com este nome."
    # ← MESSAGE-DICTIONARY: CFG_PREMIO_NOME_DUPLICADO
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Nome da premiação | Premiação | entrada do usuário | editável | texto | sim | único no sistema; máximo de 200 caracteres |
| Descrição | Premiação | entrada do usuário | editável | texto longo | não | texto livre |
| Data de início | Premiação | entrada do usuário | editável | data | sim | não posterior à data de término |
| Data de término | Premiação | entrada do usuário | editável | data | sim | igual ou posterior à data de início |
| Imagem do banner | Premiação | entrada do usuário | editável | imagem | não | imagem de identidade visual da edição |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativo | Na criação da edição |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/configuracao-premiacao/premiacoes/novo` com os campos Nome, Descrição, Data de início, Data de término e Imagem do banner; após salvar, a edição permanece aberta em modo de edição exibindo o identificador gerado e habilitando os Termos de Aceite e os Links Públicos.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Nome com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e segue em modo de edição |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma edição com nome válido e período coerente é registrada | cenário "Criar edição com dados válidos" |
| SC-02 | A tentativa de nome duplicado é rejeitada com mensagem clara | Critério de aceite 1 (HU-002) |
| SC-03 | Após a criação, a edição permanece em modo de edição exibindo o identificador gerado | Critério de aceite 3 (HU-002) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Prêmio | principal | EE | 1 | 6 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Incluir Prêmio*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Cadastrar Prêmio** — EE · ALR 1 · DER 6 · Simples · 3 PF

```json
{"pe": "Cadastrar Prêmio",
 "alr": ["Premiação"],
 "der": ["Nome", "Descrição", "Data Início", "Data Fim", "Ação", "Mensagem"],
 "nao_contados": "Imagem do banner — o formulário a recebe, mas a planilha não a conta"}
```

Por que cada ALR:
1. `Premiação` — a transação grava a edição nova, com nome, descrição e período

⚠️ O formulário recebe também a *Imagem do banner*, que a planilha não enumera entre os DER. Ficou o número da planilha (DER 6); a divergência vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e um ⚠️ com a divergência da planilha. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
