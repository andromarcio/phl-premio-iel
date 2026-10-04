---
id: CFG-LIS-02
feature_set: CFG-LIS
dominio: CFG
entidade: Lista do Sistema
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#lista-do-sistema
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

# Cadastrar Lista
> **Nível 3** - Feature Set: Listas do Sistema — Domínio: Configuração da Premiação - `CFG-LIS-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador registrar uma nova lista de valores informando nome e um código único, habilitando em seguida a configuração dos seus itens.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/listas-sistema/novo` (Formulário da Lista, aba Dados da Lista)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O código da lista é único em todo o sistema.
2. O nome e o código são obrigatórios para salvar os dados básicos da lista.
3. A configuração de itens só fica disponível depois que a lista é salva pela primeira vez.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Cadastrar lista com nome e código
  Given que acesso o formulário de nova lista
  When informo o nome "UFs do Brasil" e o código "UF_BRASIL" e clico em "Salvar Lista"
  Then o sistema registra a lista e exibe "Registro salvo com sucesso."
  And a configuração de itens da lista fica disponível

# ── Erros de validação ─────────────────────────────────────────

Scenario: Nome ou código em branco
  Given que estou no formulário de dados da lista
  When deixo o campo Nome ou o campo Código em branco e clico em "Salvar Lista"
  Then o sistema não registra e exibe "Campo obrigatório."

# ── Conflitos com dados existentes ─────────────────────────────

# ← MESSAGE-DICTIONARY: CFG_LISTA_CODIGO_DUPLICADO
Scenario: Código já usado por outra lista
  Given que já existe uma lista com o código "UF_BRASIL"
  When tento criar outra lista com o mesmo código
  Then o sistema não registra e exibe "Já existe uma lista com este código."

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão de escrita
  Given que meu perfil não tem permissão para cadastrar listas
  When tento acessar o cadastro de lista
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | máximo de 200 caracteres |
| Código | entrada do usuário | editável | texto | sim | único em todo o sistema; máximo de 50 caracteres |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação | Ativa | Na criação da lista |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/configuracao-premiacao/listas-sistema/novo`, aba "Dados da Lista" (nome e código); após o primeiro salvamento, a aba "Itens" é habilitada para a configuração dos valores.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar Lista" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo obrigatório com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e habilita a aba de itens |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma lista com nome e código válidos é registrada e passa a constar no sistema | cenário "Cadastrar lista com nome e código" |
| SC-02 | Após salvar os dados básicos, a configuração de itens é habilitada | Critério de aceite RF-05 (HU-012) |
| SC-03 | A tentativa de cadastrar com código já existente é rejeitada | cenário "Código já usado por outra lista" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Incluir Lista do Sistema | EE | 1 | 7 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Incluir Lista do Sistema** — ALR (1): Listas do Sistema. DER (7): Nome · Código · Valor · Texto · Ordem · Ação · Mensagem.

```json
{"pe": "Incluir Lista do Sistema",
 "alr": ["Listas do Sistema"],
 "der": ["Nome", "Código", "Valor", "Texto", "Ordem", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-012 |

---

*Feature Set: Listas do Sistema · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
