---
id: CFG-TIP-16
feature_set: CFG-TIP
dominio: CFG
entidade: Tipo de Participante
prioridade: P3
mvp: false
data_model_ref: data-models/configuracao.md#tipo-de-participante
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

# Importar Configuração do Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Domínio: Configuração da Premiação - `CFG-TIP-16`
> **Prioridade**: P3 · **MVP**: não

## Descrição
Permite ao administrador importar, a partir de uma planilha, a estrutura de inscrição e avaliação de um tipo de participante já existente, aproveitando uma configuração pronta de outra fonte em vez de montá-la do zero.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Catálogo de Tipos de Participante (`/tipos-participante`), a partir da ação de importação com envio de planilha.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A importação preenche a estrutura de inscrição e avaliação (campos, enquadramentos, anexos exigidos e questões) de um tipo de participante a partir de uma planilha.
2. A importação se aplica a um tipo de participante já existente; não cria o tipo.
3. A importação respeita o limite de um único conjunto de campos de inscrição e um único questionário por tipo de participante.
4. A estrutura importada substitui a configuração atual do tipo de participante. ⚠️ *(política de sobrescrita × complemento a confirmar)*

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Importar configuração a partir de planilha
  Given que seleciono um tipo de participante existente e uma planilha com a estrutura
  When confirmo a importação
  Then o sistema aplica a estrutura ao tipo e exibe "Registro salvo com sucesso."

# ── Erros de validação ─────────────────────────────────────────

Scenario: Planilha em formato inválido
  Given que seleciono uma planilha fora do formato esperado
  When confirmo a importação
  Then o sistema não aplica a estrutura e exibe "Não foi possível processar a planilha informada."
  # ← MESSAGE-DICTIONARY: CFG_IMPORTACAO_ARQUIVO_INVALIDO

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Usuário sem permissão para importar
  Given que meu perfil não tem permissão para importar configuração
  When tento acessar a importação
  Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Tipo de participante | seleção → Tipo de Participante | somente leitura | seleção | sim | tipo de destino, já existente |
| Planilha de estrutura | entrada do usuário | editável | arquivo | sim | planilha com a estrutura de inscrição e avaliação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Ação de importação disparada do Catálogo de Tipos de Participante (`/tipos-participante`): o administrador escolhe o tipo de destino, envia a planilha e confirma a importação.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Ação desabilitada com indicador enquanto processa a planilha |
| Erro de validação | Exibe "Não foi possível processar a planilha informada." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e reflete a estrutura importada no tipo |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A estrutura de inscrição e avaliação de uma planilha é aplicada a um tipo existente | cenário "Importar configuração a partir de planilha" |
| SC-02 | O escopo da importação é confirmado frente à importação da edição em Prêmios | N2 CFG-TIP (⚠️ escopo a confirmar) |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Importar Configuração Excel | EE | 4 | 32 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

- **Importar Configuração Excel** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (32): Nome · Descrição · Data Início · Data Fim · Categoria · Modalidade · Objetivo · Tipo Participante · Enquadramento · Critério · Categoria · Etapa · Rótulo do Campo · Tipo do Campo · Obrigatório · Largura · Descrição/Dica · Tipo Questão · Titulo · Enunciado · Obrigatório · Peso Nota · Limite Caracteres · Alternativas · Obrigatório · Nome Anexo · Descrição · Obrigatório · Extensão Permitida · Tamanho Máximo · Ação · Mensagem.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do N2 CFG-TIP ⚠️ sem HU dedicada — escopo da importação a confirmar frente à importação da edição em Prêmios |

---

*Feature Set: Tipos de Participante · Domínio: Configuração da Premiação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
