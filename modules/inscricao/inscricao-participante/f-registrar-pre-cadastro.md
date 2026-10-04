<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: INS-PAR-08
feature_set: INS-PAR
dominio: INS
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: [CFG-PRE-07]
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

# Registrar Pré-cadastro
> **Nível 3** - Feature Set: Inscrição do Participante — Major Feature Set: Inscrição - `INS-PAR-08`

## Descrição
Permite a quem chega pelo link público informar nome e e-mail para obter acesso ao Sistema Indústria e já ter a inscrição daquela oferta criada, sem depender de um cadastro prévio.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-015_Inscricao_Participante`](../../../hus/HU-015_Inscricao_Participante.docx) | Criação | — |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Página do Link Público (`/inscricao/:token`), passo "Inscreva-se"

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O pré-cadastro só é aceito com um link público válido e dentro do período de inscrição da oferta.
2. O nome informado tem entre 3 e 200 caracteres.
3. O e-mail informado tem no máximo 300 caracteres. → ver FIELD-DICTIONARY: E-mail
4. Quando o e-mail informado ainda não tem conta no Sistema Indústria, o pré-cadastro cria essa conta e uma senha temporária é enviada ao e-mail informado.
5. Quando o e-mail informado já tem conta no Sistema Indústria, o pré-cadastro reaproveita a conta existente e nenhuma senha nova é emitida.
6. O pré-cadastro cria no máximo uma inscrição por pessoa e oferta: havendo inscrição em andamento para o mesmo e-mail e a mesma oferta, ela é reaproveitada.
7. A inscrição criada pelo pré-cadastro nasce na situação Rascunho.
8. O pré-cadastro não autentica a pessoa: preencher a inscrição exige login. → ver `ACS-ACE-01` (Autenticar Usuário)

---

## Cenários

```gherkin
Feature: Registrar Pré-cadastro

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Primeiro acesso de quem ainda não tem conta
    Given que abri um link público de inscrição vigente
    And que meu e-mail ainda não tem conta no Sistema Indústria
    When informo meu nome e meu e-mail e confirmo
    Then o sistema cria minha conta, envia a senha temporária para o meu e-mail e cria a inscrição em Rascunho
    And a página me orienta a verificar o e-mail antes de entrar

  Scenario: Pré-cadastro de quem já tem conta
    Given que abri um link público de inscrição vigente
    And que meu e-mail já tem conta no Sistema Indústria
    When informo meu nome e meu e-mail e confirmo
    Then o sistema cria a inscrição em Rascunho e me orienta a entrar com a senha que já possuo

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: E-mail em formato inválido
    When informo um e-mail sem formato válido e confirmo
    Then o sistema não registra o pré-cadastro e aponta o e-mail como inválido

  Scenario: Nome curto demais
    When informo um nome com menos de 3 caracteres e confirmo
    Then o sistema não registra o pré-cadastro e aponta o nome como inválido

  # ── Conflitos com dados existentes ────────────────────────────

  Scenario: Segunda tentativa para a mesma oferta
    Given que já iniciei uma inscrição nesta oferta com o mesmo e-mail
    When informo novamente meu nome e meu e-mail
    Then o sistema não cria uma segunda inscrição e me avisa que já existe uma inscrição em andamento

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Link expirado
    Given que o link público está expirado
    When tento registrar o pré-cadastro
    Then o sistema informa que o link está indisponível e não cria a inscrição

  Scenario: Fora do período de inscrição
    Given que o período de inscrição da oferta ainda não começou
    When abro o link público
    Then a página informa as datas de início e de encerramento e não oferece o pré-cadastro
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Nome completo | entrada do usuário | editável | texto | sim | de 3 a 200 caracteres → ver FIELD-DICTIONARY: Nome |
| E-mail | entrada do usuário | editável | texto | sim | formato de e-mail válido; no máximo 300 caracteres → ver FIELD-DICTIONARY: E-mail |

*O link público de origem não é digitado pela pessoa: vem do endereço acessado e identifica a oferta em que a inscrição será criada.*

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Oferta da inscrição | oferta associada ao link público acessado | Ao registrar o pré-cadastro |
| Situação | Rascunho | Ao criar a inscrição |
| Data de início da inscrição | data e hora do pré-cadastro | Ao criar a inscrição |

---

## Comportamento de tela

### Onde fica
Primeiro passo da Página do Link Público (`/inscricao/:token`), no bloco "Inscreva-se", com os campos de nome e e-mail e o botão "Iniciar Inscrição". Concluído o pré-cadastro, a página avança para "Verifique seu e-mail" (quando a conta foi criada) ou direto para "Faça login" (quando a conta já existia).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Iniciar Inscrição" desabilitado com indicador enquanto o pré-cadastro é registrado |
| Erro de validação | Destaca abaixo do campo o nome curto demais ou o e-mail em formato inválido |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Avança para o passo seguinte da jornada, com a orientação correspondente |
| Empty state | Link inválido ou expirado exibe a tela "Link indisponível", sem o formulário |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Quem não tem conta consegue iniciar a inscrição informando apenas nome e e-mail | cenário "Primeiro acesso de quem ainda não tem conta" |
| SC-02 | O mesmo e-mail não gera uma segunda inscrição na mesma oferta | cenário "Segunda tentativa para a mesma oferta" |
| SC-03 | Link expirado não produz conta nem inscrição | cenário "Link expirado" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem processo elementar correspondente. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

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
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (pré-cadastro público a partir do link, com criação de conta no diretório corporativo) — capacidade implementada e até então citada apenas de passagem em INS-PAR-01. ⚠️ Confronta o não-objetivo do N0 "não gerir identidade" — ver `global/CONFORMIDADE-CODIGO.md` § 7 |

---

*Feature Set: Inscrição do Participante · Major Feature Set: Inscrição · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
