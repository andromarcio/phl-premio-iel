<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-03
feature_set: AVL-ALO
dominio: AVL
entidade: Avaliador
data_model_ref: data-models/acesso.md#usuário-vínculo-por-uf
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-025_Alocar_Avaliadores
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

# Cadastrar Avaliador
> **Nível 3** - Feature Set: Alocação de Avaliadores — Major Feature Set: Avaliação - `AVL-ALO-03`

## Descrição
Permite ao administrador cadastrar, sem sair do fluxo de alocação, um novo avaliador no cadastro corporativo, já com o perfil Avaliador e as unidades regionais a que fica vinculado.

Na tela Alocação por Grupo, o administrador aciona "Cadastrar avaliador", informa login, nome e e-mail — e, se quiser, CPF, cargo e as UFs vinculadas —, decide se o convite segue por e-mail e salva.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-025_Alocar_Avaliadores`](../../../hus/HU-025_Alocar_Avaliadores.docx) | Criação | — ação auxiliar "Cadastrar Avaliador" da HU, que não numera critérios: criar, sem sair da alocação, o usuário com perfil Avaliador no cadastro corporativo, com login único e UFs limitadas ao escopo do administrador |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: a tela Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`), pelo diálogo inline "Cadastrar avaliador".

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. O login identifica o avaliador no cadastro corporativo e é único; não pode coincidir com um login já existente.
2. O avaliador é criado com o perfil Avaliador.
3. As unidades regionais que podem ser vinculadas ao avaliador limitam-se ao escopo do administrador: o nacional vincula qualquer UF; o regional, apenas as UFs do próprio perfil.
4. Quando o cadastro é acionado a partir de um grupo específico, o avaliador criado passa a integrar o pool daquele grupo.

---

## Cenários

```gherkin
Feature: Cadastrar Avaliador

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Cadastrar novo avaliador
    Given que informo login, nome e e-mail válidos de um avaliador inexistente
    When confirmo o cadastro
    Then o sistema cria o avaliador com o perfil Avaliador e exibe "Registro salvo com sucesso."

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Login em branco
    Given que estou no cadastro de avaliador
    When deixo o campo Login em branco e confirmo
    Then o sistema não cria e exibe "Campo obrigatório."

  Scenario: E-mail em formato inválido
    Given que informo um e-mail sem "@" ou sem domínio
    When confirmo o cadastro
    Then o sistema não cria e exibe "E-mail inválido."
    # ← FIELD-DICTIONARY: E-mail

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Login já existente no cadastro corporativo
    Given que já existe um usuário com o login informado
    When confirmo o cadastro
    Then o sistema não cria e exibe "Este login já existe no cadastro corporativo. Utilize a busca de avaliadores existentes."
    # ← MESSAGE-DICTIONARY: AVL_LOGIN_DUPLICADO

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Administrador regional vinculando UF fora do seu escopo
    Given que sou administrador regional
    When abro o cadastro de avaliador
    Then o sistema oferece apenas as UFs vinculadas ao meu perfil para vínculo
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Login | externo: Portal corporativo | entrada do usuário | editável | texto | sim | único no cadastro corporativo; máximo de 200 caracteres |
| Nome | externo: Portal corporativo | entrada do usuário | editável | texto | sim | máximo de 200 caracteres |
| E-mail | externo: Portal corporativo | entrada do usuário | editável | texto | sim | → ver FIELD-DICTIONARY: E-mail |
| CPF | externo: Portal corporativo | entrada do usuário | editável | texto | não | → ver FIELD-DICTIONARY: CPF |
| Cargo | externo: Portal corporativo | entrada do usuário | editável | texto | não | texto livre |
| Enviar convite por e-mail | externo: Portal corporativo | entrada do usuário | editável | booleano | não | marcado por padrão; quando marcado, o cadastro corporativo envia o e-mail de pré-cadastro |
| UFs vinculadas | Unidade Federativa | entrada do usuário | editável | multi-seleção → Unidade Federativa | não | restrito ao escopo do administrador logado |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Perfil | Avaliador | Na criação do avaliador |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Usuário | lê e grava | Recebe o vínculo do novo avaliador às UFs escolhidas; as UFs do administrador regional limitam as opções de vínculo (regra 3) |
| Alocação de Avaliadores | grava | Acionado a partir de um grupo, o cadastro inclui o avaliador criado no pool daquele grupo (regra 4) |

---

## Comportamento de tela

### Onde fica
Diálogo "Cadastrar avaliador" aberto a partir da tela Alocação por Grupo (`/avaliacao-admin/alocacao-matriz`), com os campos de identificação, o vínculo de UFs e a opção de enviar convite.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca o campo obrigatório com "Campo obrigatório." |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e fecha o diálogo |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Um avaliador com login inédito e dados válidos é criado com o perfil Avaliador | cenário "Cadastrar novo avaliador" |
| SC-02 | A tentativa de cadastro com login já existente é rejeitada | cenário "Login já existente no cadastro corporativo" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Cadastrar Avaliador | principal | EE | 2 | 7 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

**Cadastrar Avaliador** — EE · ALR 2 · DER 7 · Médio · 4 PF

```json
{"pe": "Cadastrar Avaliador",
 "alr": ["Alocação Avaliadores", "Usuário"],
 "der": ["Login / E-mail AD", "Nome Completo", "CPF", "Cargo / Instituição", "UFs de atuação", "Ação", "Mensagem"]}
```

Por que cada ALR:
1. `Alocação Avaliadores` — acionado a partir de um grupo, o avaliador criado entra no pool daquele grupo (regra 4)
2. `Usuário` — a transação grava o vínculo do avaliador às UFs escolhidas, limitadas ao escopo do administrador (regra 3)

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa); `## Origem` com o que a feature realiza da HU, que não numera critérios; coluna Entidade em `## Campos`, com os dados de identificação gravados no portal corporativo; `## Dados lidos e gravados`; coluna Papel e memória de cálculo em bloco JSON, com a enumeração antiga em lista retirada e o porquê de cada ALR em prosa. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Alocação de Avaliadores · Major Feature Set: Avaliação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
