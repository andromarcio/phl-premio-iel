---
id: CFG-VIN-10
feature_set: CFG-VIN
dominio: CFG
entidade: Oferta
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#oferta-tipo--modalidade--categoria
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

# Editar Submodalidade
> **Nível 3** - Feature Set: Vínculos e Ofertas — Domínio: Configuração da Premiação - `CFG-VIN-10`
> **Prioridade**: P2 · **MVP**: não

## Descrição

> ⚠️ **Colisão de terminologia confirmada no código** (2026-08-28). O que esta feature descreve — o vínculo tipo de participante × modalidade × categoria, com parâmetros de equipe e slug — é a **Oferta** (`TB_TIPO_PART_MOD_CAT`), configurada na aba **Geral** do editor de Tipo de Participante. Na interface implementada, o rótulo **“Sub Modalidades”** designa outra coisa: o **Enquadramento** (`TB_ENQUADRAMENTO`, features `CFG-TIP-10`/`CFG-TIP-11`). Renomear esta feature depende de decisão do PO — ver `global/CONFORMIDADE-CODIGO.md` § 3.2.
Permite ao administrador alterar os parâmetros de uma submodalidade já cadastrada — permissão de equipe, limites de membros, slug e ordem — mantendo a oferta atualizada. ⚠️ *(escopo editável da submodalidade a confirmar)*

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)* (Submodalidades da Oferta, edição da submodalidade)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O cruzamento que define a oferta — tipo de participante, modalidade e categoria — é imutável na edição; a alteração muda apenas os parâmetros da submodalidade.
2. Quando a submodalidade permite equipe, o máximo de membros é maior ou igual ao mínimo.
3. O slug da URL da submodalidade é único entre as ofertas da edição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Alterar os parâmetros de uma submodalidade
  Given que selecionei uma submodalidade existente
  When altero a permissão de equipe e os limites de membros e clico em "Salvar"
  Then o sistema grava as alterações e exibe "Registro salvo com sucesso."

# ── Erros de validação ─────────────────────────────────────────

Scenario: Máximo de membros menor que o mínimo
  Given que a submodalidade permite equipe
  When informo um máximo de membros menor que o mínimo e clico em "Salvar"
  Then o sistema não grava e aponta a inconsistência entre mínimo e máximo

# ── Conflitos com dados existentes ─────────────────────────────

Scenario: Slug já usado por outra oferta da edição
  Given que outra oferta da edição já usa o slug informado
  When tento salvar a submodalidade com esse slug
  Then o sistema não grava e mantém o slug anterior
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | imutável | seleção | — | define a oferta; não muda após a criação |
| Modalidade e categoria | Modalidade × Categoria | imutável | seleção | — | define a oferta; não muda após a criação |
| Permite equipe | entrada do usuário | editável | sim/não | não | quando desmarcado, dispensa os limites de membros |
| Mínimo de membros da equipe | entrada do usuário | editável | número | condicional | exigido quando permite equipe |
| Máximo de membros da equipe | entrada do usuário | editável | número | condicional | maior ou igual ao mínimo |
| Slug da URL | entrada do usuário | editável | texto | não | único entre as ofertas da edição → ver FIELD-DICTIONARY: URL |
| Ordem | entrada do usuário | editável | número | não | posição da oferta na modalidade-categoria |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Página própria em `/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(nó Tipo de Participante → aba **Geral**)* (Submodalidades da Oferta): edição dos parâmetros da submodalidade selecionada, com o cruzamento tipo × modalidade × categoria apresentado em modo leitura.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca os campos de equipe quando o máximo é menor que o mínimo |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | As alterações de parâmetros de uma submodalidade são persistidas | cenário "Alterar os parâmetros de uma submodalidade" |
| SC-02 | O cruzamento tipo × modalidade × categoria não é alterado na edição | regra de negócio 1 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Submodalidade (implícita) | CE | 4 | 3 | Médio | 4 | 2026-02-28 |
| Editar Submodalidade | EE | 1 | 4 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Submodalidade (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome · Descrição · Ação.

```json
{"pe": "Consultar Submodalidade (implícita)",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação"]}
```
- **Editar Submodalidade** — ALR (1): Tipo Participante. DER (4): Nome · Descrição · Ação · Mensagem.

```json
{"pe": "Editar Submodalidade",
 "alr": ["Tipo Participante"],
 "der": ["Nome", "Descrição", "Ação", "Mensagem"]}
```

**Total: 7 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-011 |

---

*Feature Set: Vínculos e Ofertas · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
