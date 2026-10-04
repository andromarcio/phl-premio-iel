---
id: CFG-PRE-07
feature_set: CFG-PRE
dominio: CFG
entidade: Link Público
prioridade: P1
mvp: true
data_model_ref: data-models/configuracao.md#link-publico
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

# Gerar Link Público
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-07`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador emitir o link público de inscrição de um tipo de participante, disponibilizando o endereço para divulgação aos candidatos.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Links Públicos de Inscrição (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Dados** → botão “Links Públicos”)*), a partir do Formulário do Prêmio em modo de edição

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Cada tipo de participante tem no máximo um link público por edição.
2. O link só é emitido quando o tipo de participante já tem a configuração de inscrição e ao menos um enquadramento definidos.
3. O link público direciona o candidato à inscrição do tipo de participante correspondente na edição.

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Emitir o link de um tipo de participante
  Given que estou nos Links Públicos de uma edição em modo de edição
  When seleciono Categoria, Modalidade e Tipo de Participante e aciono "Gerar Link"
  Then o sistema emite o link público e o disponibiliza com opção de cópia do endereço

# ── Erros de validação ─────────────────────────────────────────

Scenario: Tipo de participante ainda não configurado
  Given que o tipo de participante selecionado não tem formulário ou enquadramento configurado
  When aciono "Gerar Link"
  Then o sistema não emite o link e exibe "Configure o formulário e ao menos um enquadramento do tipo de participante antes de gerar o link."

# ── Conflitos com dados existentes ─────────────────────────────

Scenario: Link já emitido para o tipo de participante
  Given que já existe um link público para o tipo de participante nesta edição
  When aciono "Gerar Link" para o mesmo tipo de participante
  Then o sistema não emite outro link e exibe "Já existe um link público para este tipo de participante neste prêmio."
  # ← MESSAGE-DICTIONARY: CFG_LINK_TIPO_DUPLICADO
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Categoria | entrada do usuário | editável | seleção → Categoria | sim | categoria da edição |
| Modalidade | entrada do usuário | editável | seleção → Modalidade | sim | modalidade da categoria selecionada |
| Tipo de participante | entrada do usuário | editável | seleção → Tipo de Participante | sim | oferta que receberá o link; único por edição |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Endereço do link público | URL única de inscrição do tipo de participante | Ao gerar o link |
| Data de criação do link | Data e hora da emissão | Ao gerar o link |

---

## Comportamento de tela

### Onde fica
Diálogo em cascata na tela Links Públicos de Inscrição (`/configuracao-premiacao/premiacoes/:premiacaoId/configurar` *(aba **Dados** → botão “Links Públicos”)*): o administrador escolhe Categoria, depois Modalidade e depois Tipo de Participante; ao gerar, o endereço completo é apresentado com botão de cópia para a área de transferência.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Gerar Link" desabilitado com indicador enquanto o link é emitido |
| Erro de validação | Exibe "Configure o formulário e ao menos um enquadramento do tipo de participante antes de gerar o link." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Apresenta o endereço do link com botão de cópia |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O link público é emitido com o endereço completo e botão de cópia funcional | Critério de aceite 5 (HU-002) |
| SC-02 | Não é possível emitir dois links para o mesmo tipo de participante na mesma edição | Critério de aceite 6 (HU-002) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Gerar Novo Link | EE | 4 | 5 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

- **Gerar Novo Link** — ALR (4): Premiação · Categoria · Modalidade · Tipo de Participante. DER (5): Categoria · Modalidade · Tipo de Participante · Ação · Mensagem.

```json
{"pe": "Gerar Novo Link",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo de Participante"],
 "der": ["Categoria", "Modalidade", "Tipo de Participante", "Ação", "Mensagem"]}
```

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
