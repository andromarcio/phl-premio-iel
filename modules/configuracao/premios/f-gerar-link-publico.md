<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-PRE-07
feature_set: CFG-PRE
dominio: CFG
entidade: Link Público
data_model_ref: data-models/configuracao.md#link-publico
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

# Gerar Link Público
> **Nível 3** - Feature Set: Prêmios — Major Feature Set: Configuração da Premiação - `CFG-PRE-07`

## Descrição
Permite ao administrador emitir o link público de inscrição de um tipo de participante, disponibilizando o endereço para divulgação aos candidatos.

No Formulário do Prêmio em modo de edição, o administrador aciona "Links Públicos", escolhe em cascata a categoria, a modalidade e o tipo de participante e aciona "Gerar Link", recebendo o endereço com o botão de cópia.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-002_Cadastrar_Premios`](../../../hus/HU-002_Cadastrar_Premios.docx) | Criação | `CA-5, CA-6` — endereço completo do link com botão de cópia funcional; um único link por tipo de participante no prêmio |

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
Feature: Gerar Link Público

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Categoria | Categoria | entrada do usuário | editável | seleção → Categoria | sim | categoria da edição |
| Modalidade | Modalidade | entrada do usuário | editável | seleção → Modalidade | sim | modalidade da categoria selecionada |
| Tipo de participante | Tipo de Participante | entrada do usuário | editável | seleção → Tipo de Participante | sim | oferta que receberá o link; único por edição |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Endereço do link público | URL única de inscrição do tipo de participante | Ao gerar o link |
| Data de criação do link | Data e hora da emissão | Ao gerar o link |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Link Público | lê e grava | Confere se o tipo de participante já tem link na edição (regra 1) e recebe o link emitido, com o endereço e a data de criação (campos automáticos) |
| Formulário Dinâmico | lê | O link só é emitido se o tipo de participante já tem o formulário de inscrição configurado (regra 2) |
| Enquadramento | lê | O link só é emitido se o tipo de participante já tem ao menos um enquadramento (regra 2) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Gerar Link Público | principal | EE | 4 | 5 | Complexo | 6 | 2026-02-28 |

> No baseline, o processo elementar se chama *Gerar Novo Link*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Gerar Link Público** — EE · ALR 4 · DER 5 · Complexo · 6 PF

```json
{"pe": "Gerar Link Público",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo de Participante"],
 "der": ["Categoria", "Modalidade", "Tipo de Participante", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — o link é gravado na edição (subgrupo Link Público), que não admite dois links para o mesmo tipo de participante
2. `Categoria` — a categoria escolhida na cascata, entre as vinculadas à edição
3. `Modalidade` — a modalidade escolhida, entre as da categoria
4. `Tipo de Participante` — o tipo de participante que recebe o link, conferido quanto ao formulário e ao enquadramento configurados

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios `CA-n` da HU na `## Origem`, coluna Entidade em `## Campos`, `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-002 |

---

*Feature Set: Prêmios · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
