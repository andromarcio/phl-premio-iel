<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ADM-03
feature_set: ACS-ADM
dominio: ACS
entidade: Usuário
data_model_ref: data-models/acesso.md#usuario-vinculo-por-uf
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-020_Cadastrar_Admin_Regionais
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

# Editar Administrador Regional
> **Nível 3** - Feature Set: Administradores Regionais — Major Feature Set: Acesso e Gestão - `ACS-ADM-03`

## Descrição
Permite ao administrador nacional alterar os dados editáveis de um administrador regional, como o e-mail de contato, mantendo o cadastro atualizado.

Na Lista de Administradores, o administrador nacional abre o administrador regional no formulário, onde o usuário de origem aparece só para leitura, altera o e-mail de contato e aciona "Salvar".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-020_Cadastrar_Admin_Regionais`](../../../hus/HU-020_Cadastrar_Admin_Regionais.docx) | Criação | — a HU não numera critérios de aceite; mantém o cadastro do administrador regional a quem a HU atribui as UFs, sem tocar nas UFs, que ficam em Vincular UF ao Administrador |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/administracao-usuario/:login` (Formulário de Administrador)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O usuário de origem do administrador é imutável: a edição não substitui a identidade vinda do login corporativo (SSO/AD).
2. A alteração das UFs vinculadas ao administrador não pertence a esta edição; é feita em Vincular UF ao Administrador.

---

## Cenários

```gherkin
Feature: Editar Administrador Regional

  # ← MESSAGE-DICTIONARY: BASELINE
  # ← FIELD-DICTIONARY: E-mail

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Editar o e-mail de contato
    Given que selecionei um administrador regional existente
    When altero o e-mail de contato e clico em "Salvar"
    Then o sistema grava a alteração e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: E-mail em formato inválido
    Given que estou editando um administrador regional
    When informo um e-mail sem "@" ou sem domínio e clico em "Salvar"
    Then o sistema não grava e exibe "E-mail inválido."

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de escrita
    Given que meu perfil não tem permissão para editar administradores
    When tento editar um administrador regional
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Usuário | externo: Portal corporativo | exibido do cadastro | imutável | seleção (usuário do login corporativo) | — | identidade vinda do login corporativo (SSO/AD); não pode ser alterado após a designação |
| E-mail | Usuário | entrada do usuário | editável | texto | não | → ver FIELD-DICTIONARY: E-mail |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Comportamento de tela

### Onde fica
Formulário do administrador em `/administracao-usuario/:login`: o usuário de origem é exibido como somente leitura e o e-mail de contato fica disponível para edição.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo E-mail com "E-mail inválido." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A alteração do e-mail de contato de um administrador é persistida | cenário "Editar o e-mail de contato" |
| SC-02 | O usuário de origem permanece inalterado após a edição | Regra de negócio 1 |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Consultar Usuário (implícito) | acessório | EE | 1 | 11 | Simples | 3 | 2026-02-28 |
| Editar Administrador Regional | principal | EE | 1 | 11 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar principal se chama *Editar Usuário*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Consultar Usuário (implícito)** — EE · ALR 1 · DER 11 · Simples · 3 PF

```json
{"pe": "Consultar Usuário (implícito)",
 "alr": ["Usuário"],
 "der": ["Login", "Nome", "CPF", "Telefone", "Celular", "Email", "Cargo", "Perfil", "UF Atuação", "Entidade", "Ação"]}
```

Por que cada ALR:
1. `Usuário` — o formulário abre preenchido com os dados do administrador, inclusive as UFs de atuação e campos que a pesquisa não mostrava (CPF, telefone, cargo)

⚠️ A planilha classifica a consulta implícita como EE; pela intenção primária — recuperar dados para exibir — seria CE ou SE. Ficaram o tipo e o número da planilha; a classificação vai à equipe de métricas junto com o questionamento do baseline.

**Editar Administrador Regional** — EE · ALR 1 · DER 11 · Simples · 3 PF

```json
{"pe": "Editar Administrador Regional",
 "alr": ["Usuário"],
 "der": ["Nome", "CPF", "Telefone", "Celular", "Email", "Cargo", "Perfil", "UF Atuação", "Entidade", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Usuário` — a transação grava os dados alterados do administrador regional, inclusive o e-mail de contato do vínculo local

⚠️ A planilha enumera os campos do formulário de usuário (CPF, telefone, celular, cargo, perfil, UF de atuação, entidade), enquanto este N3 descreve como editável só o e-mail de contato e deixa a troca de UFs para Vincular UF ao Administrador (regra 2). Ficou o número da planilha; a diferença vai à equipe de métricas junto com o questionamento do baseline.

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa da HU na `## Origem` (a HU não numera critérios), coluna Entidade em `## Campos` (usuário de origem vindo do portal corporativo, `externo`; o Tipo do Usuário deixa de apontar para a entidade local), coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 e do inventário APF (módulo Usuário) |

---

*Feature Set: Administradores Regionais · Major Feature Set: Acesso e Gestão · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
