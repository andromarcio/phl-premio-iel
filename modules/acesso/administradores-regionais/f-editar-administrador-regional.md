---
id: ACS-ADM-03
feature_set: ACS-ADM
dominio: ACS
entidade: Usuário
prioridade: P2
mvp: false
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

# Editar Administrador Regional
> **Nível 3** - Feature Set: Administradores Regionais — Domínio: Acesso e Gestão - `ACS-ADM-03`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador nacional alterar os dados editáveis de um administrador regional, como o e-mail de contato, mantendo o cadastro atualizado.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Usuário | login corporativo (SSO/AD) | imutável | seleção → Usuário | — | não pode ser alterado após a designação |
| E-mail | entrada do usuário | editável | texto | não | → ver FIELD-DICTIONARY: E-mail |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Usuário (implícito) | EE | 1 | 11 | Simples | 3 | 2026-02-28 |
| Editar Usuário | EE | 1 | 11 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Usuário (implícito)** — ALR (1): Usuário. DER (11): Login · Nome · CPF · Telefone · Celular · Email · Cargo · Perfil · UF Atuação · Entidade · Ação.

```json
{"pe": "Consultar Usuário (implícito)",
 "alr": ["Usuário"],
 "der": ["Login", "Nome", "CPF", "Telefone", "Celular", "Email", "Cargo", "Perfil", "UF Atuação", "Entidade", "Ação"]}
```
- **Editar Usuário** — ALR (1): Usuário. DER (11): Nome · CPF · Telefone · Celular · Email · Cargo · Perfil · UF Atuação · Entidade · Ação · Mensagem.

```json
{"pe": "Editar Usuário",
 "alr": ["Usuário"],
 "der": ["Nome", "CPF", "Telefone", "Celular", "Email", "Cargo", "Perfil", "UF Atuação", "Entidade", "Ação", "Mensagem"]}
```

**Total: 6 PF** (2 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (2 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 e do inventário APF (módulo Usuário) |

---

*Feature Set: Administradores Regionais · Domínio: Acesso e Gestão · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
