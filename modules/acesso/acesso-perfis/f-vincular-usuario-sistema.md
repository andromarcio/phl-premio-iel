<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ACE-03
feature_set: ACS-ACE
dominio: ACS
entidade: Usuário
data_model_ref: data-models/acesso.md#usuario-vinculo-por-uf
endpoints: []
error_codes: []
depende_de: [ACS-ACE-01]
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

# Vincular Usuário ao Sistema
> **Nível 3** - Feature Set: Acesso e Perfis — Major Feature Set: Acesso e Gestão - `ACS-ACE-03`

## Descrição
Dá acesso à premiação, com o perfil Participante, a quem já tem conta no Sistema Indústria mas ainda não está habilitado nesta plataforma — evitando que a pessoa fique presa na mensagem de acesso não permitido ao tentar entrar pelo link público.

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Página do Link Público (`/inscricao/:token`), disparada automaticamente quando o login devolve acesso não permitido

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O vínculo só é criado para quem já possui conta no Sistema Indústria.
2. O vínculo só é criado para quem ainda não tem acesso à premiação; quem já tem permanece como está.
3. O perfil concedido pelo vínculo é sempre Participante.
4. O vínculo não cria conta nem redefine senha — a identidade continua sendo a do Sistema Indústria.
5. Quem não é localizado no Sistema Indústria não recebe vínculo e segue o caminho do pré-cadastro. → ver `INS-PAR-08` (Registrar Pré-cadastro)

---

## Cenários

```gherkin
Feature: Vincular Usuário ao Sistema

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Liberar acesso a quem já é do Sistema Indústria
    Given que tenho conta no Sistema Indústria e nunca acessei a premiação
    When tento entrar pelo link público e o acesso é recusado
    Then o sistema me vincula à premiação com o perfil Participante
    And consigo entrar com a minha senha atual

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Quem já tinha acesso
    Given que já tenho acesso à premiação
    When o vínculo é tentado novamente
    Then nada é alterado no meu acesso

  Scenario: E-mail sem conta no Sistema Indústria
    Given que meu e-mail não tem conta no Sistema Indústria
    When o vínculo é tentado
    Then o sistema informa que o usuário não foi localizado e não cria vínculo

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: E-mail em formato inválido
    When o vínculo é tentado com um e-mail sem formato válido
    Then o sistema não executa o vínculo e aponta o e-mail como inválido
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| E-mail | entrada do usuário | editável | texto | sim | formato de e-mail válido → ver FIELD-DICTIONARY: E-mail |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Perfil de acesso | Participante | Ao criar o vínculo |
| Resultado do vínculo | vinculado ou não vinculado, com o motivo | Ao concluir a tentativa |

---

## Comportamento de tela

### Onde fica
Não tem tela própria. É disparada pela Página do Link Público (`/inscricao/:token`) quando a tentativa de login devolve acesso não permitido, usando o e-mail que a pessoa acabou de informar. Concluído o vínculo, a página repete o login sem pedir nada de novo.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Indicador no botão de entrar enquanto o vínculo é tentado |
| Erro de validação | Destaca o e-mail em formato inválido |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Refaz o login e segue para a inscrição |
| Empty state | Usuário não localizado leva ao caminho de pré-cadastro |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Quem já tem conta corporativa consegue entrar na premiação sem intervenção do administrador | cenário "Liberar acesso a quem já é do Sistema Indústria" |
| SC-02 | Uma segunda tentativa de vínculo não altera o acesso de quem já o tem | cenário "Quem já tinha acesso" |

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
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (normalização de acesso de usuário corporativo já existente) — capacidade implementada e até então não especificada |

---

*Feature Set: Acesso e Perfis · Major Feature Set: Acesso e Gestão · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
