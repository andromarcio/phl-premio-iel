---
id: ACS-ADM-02
feature_set: ACS-ADM
dominio: ACS
entidade: Usuário
prioridade: P1
mvp: true
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
---

# Cadastrar Administrador Regional
> **Nível 3** - Feature Set: Administradores Regionais — Domínio: Acesso e Gestão - `ACS-ADM-02`
> **Prioridade**: P1 · **MVP**: sim

## Descrição
Permite ao administrador nacional cadastrar um usuário existente do login corporativo como administrador regional, deixando-o apto a receber UFs de escopo.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Usuário | login corporativo (SSO/AD) | editável | seleção → Usuário | sim | usuário existente no diretório corporativo; não pode já ser administrador regional ⚠️ |
| E-mail | login corporativo (SSO/AD) | somente leitura | texto | não | e-mail de contato herdado da conta corporativa; → ver FIELD-DICTIONARY: E-mail |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Perfil | Administrador Regional | Na designação do usuário |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Incluir Usuário | EE | 1 | 12 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Incluir Usuário** — ALR (1): Usuário. DER (12): Login · Nome · CPF · Telefone · Celular · Email · Cargo · Perfil · UF Atuação · Entidade · Ação · Mensagem.

```json
{"pe": "Incluir Usuário",
 "alr": ["Usuário"],
 "der": ["Login", "Nome", "CPF", "Telefone", "Celular", "Email", "Cargo", "Perfil", "UF Atuação", "Entidade", "Ação", "Mensagem"]}
```

**Total: 3 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 e do inventário APF (módulo Usuário) ⚠️ identidade vinda do SSO |

---

*Feature Set: Administradores Regionais · Domínio: Acesso e Gestão · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
