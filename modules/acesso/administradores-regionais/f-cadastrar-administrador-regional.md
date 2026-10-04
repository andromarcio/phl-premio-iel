<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ADM-02
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

# Cadastrar Administrador Regional
> **Nível 3** - Feature Set: Administradores Regionais — Major Feature Set: Acesso e Gestão - `ACS-ADM-02`

## Descrição
Permite ao administrador nacional cadastrar um usuário existente do login corporativo como administrador regional, deixando-o apto a receber UFs de escopo.

A partir da Lista de Administradores, o administrador nacional abre o formulário de novo administrador, seleciona o usuário do login corporativo — o e-mail de contato vem preenchido da conta corporativa — e aciona "Salvar".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-020_Cadastrar_Admin_Regionais`](../../../hus/HU-020_Cadastrar_Admin_Regionais.docx) | Criação | — a HU não numera critérios de aceite; designa o usuário como administrador regional, o que o põe na lista de administradores de onde a HU parte para atribuir as UFs |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/administracao-usuario` (Formulário de Administrador)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A identidade do administrador vem do login corporativo (SSO/AD); o cadastro seleciona um usuário existente e o designa como administrador regional, sem criar senha própria. ⚠️ *(a confirmar se é seleção de usuário existente do diretório corporativo)*
2. Um mesmo usuário é registrado como administrador regional uma única vez. ⚠️ *(unicidade a confirmar)*
3. O administrador passa a atuar em validação somente após ter ao menos uma UF vinculada (feita em Vincular UF ao Administrador).

---

## Cenários

```gherkin
Feature: Cadastrar Administrador Regional

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Designar usuário como administrador regional
    Given que acesso o formulário de novo administrador
    When seleciono um usuário do login corporativo e salvo
    Then o sistema registra o usuário como administrador regional e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Usuário não selecionado
    Given que estou no formulário de novo administrador
    When deixo o campo de usuário em branco e clico em "Salvar"
    Then o sistema não registra e exibe "Campo obrigatório."

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Usuário já é administrador regional
    Given que o usuário selecionado já está cadastrado como administrador regional
    When tento cadastrá-lo novamente
    Then o sistema não registra e mantém um único cadastro para o usuário

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de escrita
    Given que meu perfil não tem permissão para cadastrar administradores
    When tento acessar o cadastro de administrador
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Usuário | externo: Portal corporativo | entrada do usuário | editável | seleção (usuário do login corporativo) | sim | usuário existente no diretório corporativo (SSO/AD); não pode já ser administrador regional ⚠️ |
| E-mail | externo: Portal corporativo | externo: Portal corporativo | somente leitura | texto | não | e-mail de contato herdado da conta corporativa (SSO/AD); → ver FIELD-DICTIONARY: E-mail |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Perfil | Administrador Regional | Na designação do usuário |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Usuário | lê e grava | Confere que o usuário ainda não é administrador regional (regra 2) e grava a designação no vínculo local de usuários do sistema, o mesmo arquivo lógico que guarda as UFs vinculadas e o e-mail de contato (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Formulário próprio em `/administracao-usuario`: seleção do usuário do login corporativo e confirmação da designação como administrador regional.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo Usuário com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e retorna à lista de administradores |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um usuário do login corporativo é registrado como administrador regional e passa a constar na lista | cenário "Designar usuário como administrador regional" |
| SC-02 | A designação sem usuário selecionado é rejeitada | cenário "Usuário não selecionado" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Administrador Regional | principal | EE | 1 | 12 | Simples | 3 | 2026-02-28 |

> No baseline, o processo elementar se chama *Incluir Usuário*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Cadastrar Administrador Regional** — EE · ALR 1 · DER 12 · Simples · 3 PF

```json
{"pe": "Cadastrar Administrador Regional",
 "alr": ["Usuário"],
 "der": ["Login", "Nome", "CPF", "Telefone", "Celular", "Email", "Cargo", "Perfil", "UF Atuação", "Entidade", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Usuário` — a transação grava o administrador regional com o perfil e as UFs de atuação no vínculo usuário↔UF (o baseline conta o vínculo de UF dentro desta inclusão, e por isso `ACS-ADM-04` — Vincular UF ao Administrador não tem contagem própria)

⚠️ A planilha enumera os campos do formulário de usuário (CPF, telefone, celular, cargo, entidade), que este N3 não descreve: aqui a designação é a seleção de um usuário que já existe no login corporativo (regra 1, ⚠️ a confirmar). Ficou o número da planilha; a diferença vai à equipe de métricas junto com o questionamento do baseline.

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa da HU na `## Origem` (a HU não numera critérios), coluna Entidade em `## Campos` (usuário e e-mail vindos do portal corporativo, `externo`; o Tipo do Usuário deixa de apontar para a entidade local), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 e do inventário APF (módulo Usuário) ⚠️ identidade vinda do SSO |

---

*Feature Set: Administradores Regionais · Major Feature Set: Acesso e Gestão · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
