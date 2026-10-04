<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ACE-01
feature_set: ACS-ACE
dominio: ACS
entidade: Usuário
data_model_ref: data-models/acesso.md#usuario-vinculo-por-uf
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

# Autenticar Usuário
> **Nível 3** - Feature Set: Acesso e Perfis — Major Feature Set: Acesso e Gestão - `ACS-ACE-01`

## Descrição
Permite ao usuário entrar no sistema pelo login corporativo do Sistema Indústria (SSO), autenticando a sua identidade para iniciar uma sessão com o perfil correspondente. ⚠️ *(autenticação externa ao produto — a confirmar se figura como feature)*

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/login` (redireciona ao login corporativo/SSO — tela externa) ⚠️

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A identidade e a autenticação são fornecidas pelo login corporativo (SSO/AD); o sistema não mantém cadastro próprio de senhas. ⚠️ *(a confirmar)*
2. Cada usuário possui um único perfil, resolvido a partir da identidade autenticada. ⚠️ *(a confirmar com AUTHZ)*
3. O acesso ao link público de inscrição não exige esta autenticação. ⚠️ *(a confirmar)*

---

## Cenários

```gherkin
Feature: Autenticar Usuário

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Autenticar com a conta corporativa
    Given que possuo uma conta válida no login corporativo
    When me autentico pelo SSO
    Then o sistema inicia a sessão e libera o acesso conforme o meu perfil

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Credenciais recusadas pelo login corporativo
    Given que informo credenciais inválidas no login corporativo
    When tento me autenticar
    Then o sistema não inicia a sessão e mantém o usuário no login corporativo
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Credenciais corporativas | login corporativo (SSO/AD) — externo | somente leitura | — | sim | validadas pelo provedor de identidade corporativo (externo) ⚠️ |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Situação da sessão | Autenticada | Após a validação bem-sucedida pelo login corporativo |

---

## Comportamento de tela

### Onde fica
Ponto de entrada em `/login`: o produto redireciona o usuário ao login corporativo (SSO), externo ao sistema, e retoma a sessão autenticada ao retorno. ⚠️

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" durante o redirecionamento e o retorno do login corporativo |
| Erro de validação | Credenciais recusadas são tratadas pelo login corporativo (externo) ⚠️ |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Inicia a sessão e encaminha o usuário à área correspondente ao perfil |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um usuário com conta corporativa válida é autenticado e inicia uma sessão com o seu perfil | cenário "Autenticar com a conta corporativa" |
| SC-02 | Credenciais recusadas pelo login corporativo não iniciam sessão | cenário "Credenciais recusadas pelo login corporativo" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — LOGON — não contado; regra CAIXA 7. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

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
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado de `global/AUTHZ.md` e do N0 (login corporativo/SSO) — sem HU dedicada ⚠️ |

---

*Feature Set: Acesso e Perfis · Major Feature Set: Acesso e Gestão · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
