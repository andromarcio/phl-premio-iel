<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: ACS-ADM-04
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

# Vincular UF ao Administrador
> **Nível 3** - Feature Set: Administradores Regionais — Major Feature Set: Acesso e Gestão - `ACS-ADM-04`

## Descrição
Permite ao administrador nacional vincular uma ou mais UFs a um administrador regional, definindo o conjunto de inscrições que ele pode enxergar e validar.

No formulário do administrador, no campo "UFs de Atuação", o administrador nacional escolhe o administrador regional, marca as UFs desejadas — cada uma com sigla e nome — e aciona "Salvar".

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-020_Cadastrar_Admin_Regionais`](../../../hus/HU-020_Cadastrar_Admin_Regionais.docx) | Criação | — a HU não numera critérios de aceite; realiza as funcionalidades *Listar UFs Disponíveis*, *Associar UFs ao Administrador Regional* e *Visualizar UFs do Administrador* e as regras de negócio da HU (ao menos uma UF, visibilidade das inscrições pelas UFs, vigência imediata e filtro automático com UF única) |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/administracao-usuario/:login` *(campo “UFs de Atuação”)* (Configuração de UFs do Administrador)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. Ao menos uma UF deve estar vinculada ao administrador regional.
2. As UFs vinculadas determinam quais inscrições o administrador enxerga e pode validar.
3. A alteração do vínculo de UFs passa a valer imediatamente para a visibilidade das inscrições do administrador.
4. Com uma única UF vinculada, o escopo do administrador é essa UF; com múltiplas UFs vinculadas, o administrador precisa escolher uma UF para delimitar o escopo antes de validar.

---

## Cenários

```gherkin
Feature: Vincular UF ao Administrador

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Vincular UFs a um administrador
    Given que selecionei um administrador regional
    When marco as UFs "SP" e "RJ" e clico em "Salvar"
    Then o sistema grava o vínculo e exibe "Registro salvo com sucesso."
    And as inscrições de "SP" e "RJ" passam a ficar visíveis para o administrador

  # ── Erros de validação ─────────────────────────────────────────

  Scenario: Salvar sem nenhuma UF
    Given que estou na configuração de UFs de um administrador
    When não marco nenhuma UF e clico em "Salvar"
    Then o sistema não grava e exibe "Campo obrigatório."

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Administrador com uma única UF
    Given que um administrador possui apenas a UF "SP" vinculada
    When ele acessa a validação de inscrições
    Then o escopo é limitado automaticamente às inscrições de "SP"

  Scenario: Alteração de UFs em vigor imediato
    Given que um administrador estava vinculado apenas à UF "SP"
    When vinculo também a UF "RJ" e salvo
    Then o sistema passa a exibir as inscrições de "SP" e "RJ" para o administrador sem novo cadastro

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Usuário sem permissão de escrita
    Given que meu perfil não tem permissão para vincular UFs
    When tento acessar a configuração de UFs de um administrador
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Administrador Regional | externo: Portal corporativo | entrada do usuário | editável | seleção (usuário do login corporativo) | sim | usuário com perfil de administrador regional |
| UFs vinculadas | Unidade Federativa | entrada do usuário | editável | seleção múltipla → Unidade Federativa | sim | ao menos uma UF selecionada |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| — | — | — |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Usuário | lê e grava | Mostra as UFs já vinculadas ao administrador e grava o novo conjunto marcado no vínculo usuário↔UF, que passa a valer de imediato na visibilidade das inscrições (regras 1 a 3) |

---

## Comportamento de tela

### Onde fica
Página própria em `/administracao-usuario/:login` *(campo “UFs de Atuação”)* (Configuração de UFs do Administrador): seleção do administrador, seleção múltipla das UFs (sigla e nome) e ação de salvar.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" desabilitado com indicador enquanto grava |
| Erro de validação | Destaca a seleção de UFs com "Campo obrigatório." quando nenhuma UF é marcada |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." |
| Empty state | Não se aplica |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma ou mais UFs são vinculadas ao administrador e passam a definir a visibilidade das inscrições | cenário "Vincular UFs a um administrador" |
| SC-02 | A tentativa de salvar sem nenhuma UF é rejeitada | Critério de aceite "Ao menos uma UF" (HU-020) |
| SC-03 | A alteração do vínculo de UFs vale imediatamente na visibilidade das inscrições | cenário "Alteração de UFs em vigor imediato" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — passo dentro de cadastrar/editar administrador. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), prosa da HU na `## Origem` (a HU não numera critérios), coluna Entidade em `## Campos` (administrador vindo do portal corporativo, `externo`; o Tipo deixa de apontar para a entidade local), `## Dados lidos e gravados`, coluna Papel em `## Métricas de tamanho` — sem processo elementar medido: o baseline conta o vínculo de UF dentro de Cadastrar e Editar Administrador Regional. Sem mudança de regra, cenário ou número de PF |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-020 |

---

*Feature Set: Administradores Regionais · Major Feature Set: Acesso e Gestão · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
