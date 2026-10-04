<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: CFG-TIP-16
feature_set: CFG-TIP
dominio: CFG
entidade: Tipo de Participante
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
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Importar Configuração do Tipo de Participante
> **Nível 3** - Feature Set: Tipos de Participante — Major Feature Set: Configuração da Premiação - `CFG-TIP-16`

## Descrição
Permite ao administrador importar, a partir de uma planilha, a estrutura de inscrição e avaliação de um tipo de participante já existente, aproveitando uma configuração pronta de outra fonte em vez de montá-la do zero.

No Catálogo de Tipos de Participante, o administrador aciona a importação, escolhe o tipo de destino, envia a planilha com a estrutura e confirma.

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
Feature: Importar Configuração do Tipo de Participante

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

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Tipo de participante | Tipo de Participante | entrada do usuário | somente leitura | seleção → Tipo de Participante | sim | tipo de destino, já existente |
| Planilha de estrutura | Tipo de Participante | entrada do usuário | editável | arquivo | sim | planilha com a estrutura de inscrição e avaliação |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Formulário Dinâmico | lê e grava | O tipo tem um único conjunto de campos de inscrição, que a importação respeita e substitui (regras 3 e 4) |
| Campo do Formulário | grava | A importação preenche os campos de inscrição do tipo (regra 1) |
| Enquadramento | grava | A importação preenche os enquadramentos do tipo (regra 1) |
| Configuração de Anexo | grava | A importação preenche os anexos exigidos do tipo (regra 1) |
| Questionário | lê e grava | O tipo tem um único questionário, que a importação respeita e substitui (regras 3 e 4) |
| Questão de Avaliação | grava | A importação preenche as questões do questionário (regra 1) |
| Alternativa da Questão | grava | As alternativas das questões objetivas vêm na planilha (DER *Alternativas* do baseline) |
| Premiação | lê | A planilha identifica a premiação da estrutura (ALR do baseline) |
| Categoria | lê | A planilha identifica a categoria da oferta (ALR do baseline) |
| Modalidade | lê | A planilha identifica a modalidade da oferta (ALR do baseline) |

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

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Importar Configuração do Tipo de Participante | principal | EE | 4 | 32 | Complexo | 6 | 2026-02-28 |

> No baseline, o processo elementar se chama *Importar Configuração Excel*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Importar Configuração do Tipo de Participante** — EE · ALR 4 · DER 32 · Complexo · 6 PF

```json
{"pe": "Importar Configuração do Tipo de Participante",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Nome", "Descrição (premiação)", "Data Início", "Data Fim", "Categoria (estrutura)", "Modalidade", "Objetivo", "Tipo Participante", "Enquadramento", "Critério", "Categoria (critério)", "Etapa", "Rótulo do Campo", "Tipo do Campo", "Obrigatório (campo)", "Largura", "Descrição/Dica", "Tipo Questão", "Titulo", "Enunciado", "Obrigatório (questão)", "Peso Nota", "Limite Caracteres", "Alternativas", "Obrigatório (após alternativas)", "Nome Anexo", "Descrição (anexo)", "Obrigatório (anexo)", "Extensão Permitida", "Tamanho Máximo", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Premiação` — a planilha traz os dados da premiação (nome, descrição, datas, critério e etapa)
2. `Categoria` — a planilha traz a categoria da oferta
3. `Modalidade` — a planilha traz a modalidade da oferta e o objetivo
4. `Tipo Participante` — a transação grava a estrutura de inscrição e avaliação do tipo (campos, enquadramentos, questões e anexos exigidos), subgrupos do mesmo arquivo lógico

⚠️ A planilha registra *Obrigatório* quatro vezes e *Categoria* e *Descrição* duas vezes cada, em grupos diferentes da planilha de importação; aqui desambiguados pelo grupo em que aparecem. O terceiro *Obrigatório*, entre *Alternativas* e *Nome Anexo*, ficou como *após alternativas*, porque a planilha não diz a que grupo pertence. Pelo CPM o mesmo DER conta uma vez; ficou como o baseline contou, a confirmar com a equipe de métricas.

⚠️ A planilha mede também dados da premiação (nome, datas, critério e etapa), que o N3 não descreve. O escopo da importação, frente à importação da edição em Prêmios, segue a confirmar (regra 4 e N2).

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), coluna Entidade em `## Campos` (o `seleção → Tipo de Participante`, que estava na coluna Preenchimento, passa à coluna Tipo), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature e os DER repetidos desambiguados; a feature segue sem `## Origem`, porque não tem HU dedicada. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado do N2 CFG-TIP ⚠️ sem HU dedicada — escopo da importação a confirmar frente à importação da edição em Prêmios |

---

*Feature Set: Tipos de Participante · Major Feature Set: Configuração da Premiação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
