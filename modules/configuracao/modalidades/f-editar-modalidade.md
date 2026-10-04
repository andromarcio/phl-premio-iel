---
id: CFG-MOD-03
feature_set: CFG-MOD
dominio: CFG
entidade: Modalidade
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#modalidade
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

# Editar Modalidade
> **Nível 3** - Feature Set: Modalidades — Domínio: Configuração da Premiação - `CFG-MOD-03`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador alterar o nome, a descrição, o link de regulamento e o período de inscrição de uma modalidade já cadastrada, sem mudá-la de categoria.

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/modalidades/:id/visualizar` (Formulário de Modalidade, aba Dados Gerais)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O nome da modalidade é único dentro da mesma categoria; o mesmo nome é permitido em categorias diferentes.
2. A categoria à qual a modalidade pertence é imutável: a edição não move a modalidade para outra categoria.
3. O período de inscrição é opcional; quando informado, a data de início é anterior à data de fim.
4. O período de inscrição da modalidade tem precedência sobre as datas globais do prêmio para o acesso ao fluxo público de inscrição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Editar dados e período da modalidade
  Given que selecionei uma modalidade existente
  When altero o nome, o link de regulamento e o período de inscrição e clico em "Salvar"
  Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

# ── Erros de validação ─────────────────────────────────────────

Scenario: Nome apagado na edição
  Given que estou editando uma modalidade
  When apago o campo Nome e clico em "Salvar"
  Then o sistema não grava e exibe "Campo obrigatório."

# ── Conflitos com dados existentes ─────────────────────────────

# ← MESSAGE-DICTIONARY: CFG_MODALIDADE_PERIODO_INVALIDO
Scenario: Período de inscrição com fim anterior ao início
  Given que edito o período e informo o fim das inscrições anterior ao início
  When clico em "Salvar"
  Then o sistema não grava e exibe "A data de fim das inscrições deve ser posterior à data de início."

# ← MESSAGE-DICTIONARY: CFG_MODALIDADE_NOME_DUPLICADO
Scenario: Renomear para um nome já usado na mesma categoria
  Given que já existe outra modalidade "Individual" na mesma categoria
  When renomeio a modalidade atual para "Individual"
  Then o sistema não grava e exibe "Já existe uma modalidade com este nome nesta categoria."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | único dentro da mesma categoria; máximo de 200 caracteres |
| Descrição | entrada do usuário | editável | texto longo | não | texto livre |
| Link do regulamento | entrada do usuário | editável | texto (URL) | não | → ver FIELD-DICTIONARY: URL |
| Início das inscrições | entrada do usuário | editável | data e hora | não | quando informado, anterior ao fim das inscrições |
| Fim das inscrições | entrada do usuário | editável | data e hora | não | quando informado, posterior ao início das inscrições |
| Categoria | — | imutável | seleção → Categoria | — | não pode ser alterada após a criação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Formulário da modalidade em `/modalidades/:id/visualizar`, aba "Dados Gerais"; também acessível pelo editor contextual da árvore de configuração do prêmio.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo com "Campo obrigatório." ou o período com a mensagem de período inválido |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de dados e período de uma modalidade são persistidas | cenário "Editar dados e período da modalidade" |
| SC-02 | A tentativa de renomear para um nome já usado na mesma categoria é rejeitada | cenário "Renomear para um nome já usado na mesma categoria" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Modalidade (implícita) | SE | 2 | 7 | Médio | 5 | 2026-02-28 |
| Editar Modalidade | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Modalidade (implícita)** — ALR (2): Modalidade · Categoria. DER (7): Nome · Descrição · Premiação · Categoria · Id do Vinculo · Situação · Ação.

```json
{"pe": "Consultar Modalidade (implícita)",
 "alr": ["Modalidade", "Categoria"],
 "der": ["Nome", "Descrição", "Premiação", "Categoria", "Id do Vinculo", "Situação", "Ação"]}
```
- **Editar Modalidade** — ALR (1): Modalidade. DER (4): Nome · Descrição · Ação · Mensagem.

```json
{"pe": "Editar Modalidade",
 "alr": ["Modalidade"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

**Total: 8 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-005 |

---

*Feature Set: Modalidades · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
