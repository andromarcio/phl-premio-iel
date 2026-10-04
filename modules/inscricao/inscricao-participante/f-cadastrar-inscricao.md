<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-01
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-015_Inscricao_Participante
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

# Cadastrar Inscrição
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-01`

## Descrição
Permite ao participante iniciar uma nova inscrição em rascunho pelo link público da premiação, criando o registro de trabalho onde o preenchimento terá continuidade.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/inscricao/:token` (Landing Pública de Inscrição), acessada pelo link público com o token da premiação.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O acesso à inscrição parte de um link público que carrega o token de validação da premiação; um token inválido ou expirado não concede acesso à inscrição.
2. A identidade do participante provém do login corporativo do Sistema Indústria (SSO), com um perfil por usuário. ⚠️ *(o pré-cadastro com nome, e-mail e senha própria descrito na HU-015 diverge do SSO previsto no N0 — confirmar qual mecanismo de acesso vale)*
3. Cada inscrição nasce vinculada à premiação do link acessado e a um único participante.
4. A inscrição é criada no estado inicial de rascunho e reúne todo o trabalho de preenchimento posterior do participante.

---

## Cenários

```gherkin
Feature: Cadastrar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Iniciar inscrição pelo link público válido
    Given que acesso o link público de inscrição com um token válido
    When informo meu nome e e-mail e prossigo
    Then o sistema cria a inscrição em rascunho vinculada à premiação
    And o participante segue para o preenchimento da inscrição

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Nome ou e-mail em branco no pré-cadastro
    Given que estou no pré-cadastro da inscrição
    When deixo o nome ou o e-mail em branco e prossigo
    Then o sistema não cria a inscrição e exibe "Campo obrigatório."

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: E-mail já cadastrado
    Given que informo no pré-cadastro um e-mail já cadastrado no sistema
    When prossigo
    Then o sistema conduz o participante para o acesso com o e-mail informado

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Token do link inválido ou expirado
    Given que acesso um link público com token inválido ou expirado
    When a inscrição é carregada
    Then o sistema não concede acesso e exibe "O link de inscrição é inválido ou expirou."
    # ← MESSAGE-DICTIONARY: INS_TOKEN_INVALIDO
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome | entrada do usuário | editável | texto | sim | nome completo do participante → ver FIELD-DICTIONARY: Nome de pessoa |
| E-mail | entrada do usuário | editável | texto | sim | → ver FIELD-DICTIONARY: E-mail |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Status | Rascunho | Na criação da inscrição |
| Premiação | A premiação do link acessado | Na criação da inscrição |
| Data de início | Data e hora da criação | Na criação da inscrição |
| Percentual de preenchimento | 0% | Na criação da inscrição |

---

## Comportamento de tela

### Onde fica
Landing pública em `/inscricao/:token` com a identidade visual da premiação e o assistente de início da inscrição (pré-cadastro do participante).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto valida o token e carrega a identidade visual |
| Erro de validação | Destaca o campo em branco com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Cria a inscrição em rascunho e segue para o preenchimento |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um link com token válido inicia uma inscrição em rascunho vinculada à premiação | cenário "Iniciar inscrição pelo link público válido" |
| SC-02 | Um token inválido ou expirado não concede acesso à inscrição | cenário "Token do link inválido ou expirado" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Realizar Inscrição (Rascunho) | EE | 3 | 27 | Complexo | 6 | 2026-02-28 |

### Memória de cálculo

- **Realizar Inscrição (Rascunho)** — ALR (3): Premiação · Inscrição · Tipo de Participante. DER (27): Percentual Inscrição · Qtd questões preenchidas/Total questões · Título Questão Formulário de Inscrição · Descrição Questão · Obrigatoriedade questão · Resposta · Número Questão Questionário de Avaliação · Título Questão · Tipo Questão · Obrigatoriedade · Peso · Resposta · Qtd min membros equipe · Qtd max membros equipe · Qtd membros cadastrados · Nome membro · CPF · E-mail · Telefone · Genero · Tipo de validação do formulário · Mensagem de validação · Tipo Anexo · Tipo Arquivo · Arquivo · Ação · Mensagem.

**Total: 6 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-015 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
